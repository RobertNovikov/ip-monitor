Install:
docker-compose build
docker-compose run app rake db:create
docker-compose up

Tests:
docker-compose build
docker-compose run app rake db:create RACK_ENV=test
docker-compose run app rspec
