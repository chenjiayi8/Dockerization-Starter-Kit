#!/bin/sh

# down
php artisan down 

# clean caches
php artisan cache:clear
php artisan route:clear
php artisan config:clear
php artisan view:clear

composer clearcache
npm cache clear --force

# update dependencies
composer install
npm install

# mix
npm run dev

# Lavara config
php artisan config:cache \
  && php artisan route:cache \
  && php artisan optimize

# up
php artisan up
