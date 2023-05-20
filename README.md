# Install:
docker-compose build\
docker-compose run app rake db:create\
docker-compose up

# Tests:
docker-compose build RACK_ENV=test\
docker-compose run app rake db:create RACK_ENV=test\
docker-compose run app rspec RACK_ENV=test

# Swagger
In dev mode swagger json available on http://localhost:3000/swagger_doc \
To view swagger documentation you can visit https://petstore.swagger.io/#/ and paste url to swagger json

# Ping interval
You can configure ping interval in config/schedule.rb\
You can configure ping timeout with constant in config/constants.yml
