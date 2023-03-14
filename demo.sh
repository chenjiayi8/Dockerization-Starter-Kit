#!/bin/sh

# make sure the project is down
docker compose down

# prepare demo project
rm -rf ./app
wget https://github.com/laravel/laravel/archive/refs/heads/8.x.zip
mkdir temp
unzip 8.x.zip -d temp/
mv ./temp/laravel-8.x/  ./app
rm 8.x.zip
rmdir temp

# build container
docker compose up -d --build

# install dependencies
docker exec -it app init.sh
