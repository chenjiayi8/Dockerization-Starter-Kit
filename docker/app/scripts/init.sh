#!/bin/sh

# install dependencies
composer install
npm install
# mix
npm run dev

# laravel key
php artisan key:generate

# Lavara config
php artisan storage:link \
  && php artisan config:cache \
  && php artisan route:cache \
  && php artisan optimize

# permissions
chmod -R 777 storage

# up
php artisan up