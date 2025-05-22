FROM php:8.1-apache

# Установка нужных пакетов
RUN apt-get update && apt-get install -y \
    git zip unzip libpq-dev libzip-dev libjpeg-dev libpng-dev libwebp-dev libxpm-dev \
    libxml2-dev libicu-dev libldap2-dev libssl-dev zlib1g-dev libonig-dev \
    && docker-php-ext-install intl pdo pdo_pgsql zip gd opcache

# Копируем Moodle в /var/www/html
COPY moodle/ /var/www/html/

# Копируем конфиг и создаем папку для moodledata
COPY config.php /var/www/html/config.php
RUN mkdir /var/www/moodledata && chown -R www-data:www-data /var/www/moodledata

# Права
RUN chown -R www-data:www-data /var/www/html

# Разрешаем .htaccess
RUN a2enmod rewrite
