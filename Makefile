#! /usr/bin/make -f
migrate:
	@echo 'Executing migrations files...'
	@docker exec -it shellbot_node_1 node ./node_modules/.bin/typeorm migration:run
install:
	@echo 'Installing dependencies...'
	@docker-compose build
	@docker-compose run node npm install --only=dev
build:
	@echo 'Buildind javascript files from typescript.'
	@docker-compose run node npm run-script build && echo '✅ Build succeeded' || echo '❌ Build failed'
create-config: build
	@echo 'Creating the config file.'
	@docker-compose run node dist/Service/ConfigCreator.js
lint:
	tslint -c tslint.json 'src/**/*.ts'
start: build
	@echo 'Starting the bot...'
	@docker-compose up -d && echo '✅ Bot started'
stop:
	@echo 'Stopping the bot...'
	@docker-compose down && echo '✅ Bot stopped !'