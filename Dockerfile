FROM php:8.1-apache

# Установка зависимостей
RUN apt-get update && apt-get install -y \
    git zip unzip libpq-dev libzip-dev libjpeg-dev libpng-dev libwebp-dev libxpm-dev \
    libxml2-dev libicu-dev libldap2-dev libssl-dev zlib1g-dev libonig-dev \
    && docker-php-ext-install intl pdo pdo_pgsql zip gd opcache

# Копируем весь проект в папку сайта Apache
COPY . /var/www/html/

# Создаём moodledata и даём права
RUN mkdir /var/www/moodledata && chown -R www-data:www-data /var/www/html /var/www/moodledata

# Открываем порт 80
EXPOSE 80
