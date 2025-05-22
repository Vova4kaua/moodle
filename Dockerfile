FROM php:8.1-apache

RUN apt-get update && apt-get install -y \
    git zip unzip libpq-dev libzip-dev libjpeg-dev libpng-dev libwebp-dev libxpm-dev \
    libxml2-dev libicu-dev libldap2-dev libssl-dev zlib1g-dev libonig-dev \
    && docker-php-ext-install intl pdo pdo_pgsql zip gd opcache

COPY moodle/ /var/www/html/

RUN mkdir /var/www/moodledata && chown -R www-data:www-data /var/www/moodledata

EXPOSE 80
