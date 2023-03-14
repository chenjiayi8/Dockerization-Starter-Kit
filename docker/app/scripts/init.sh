#!/bin/sh

# install dependencies
composer install
npm install
# mix
npm run dev

# database
php artisan migrate:fresh  --seed

# Lavara config
php artisan storage:link \
  && php artisan config:cache \
  && php artisan route:cache \
  && php artisan optimize

# log file
chmod -R 775 storage

# up
php artisan up