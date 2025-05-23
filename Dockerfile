FROM debian:bullseye

# Установка зависимостей
RUN apt-get update && \
    apt-get install -y apt-transport-https lsb-release ca-certificates wget gnupg

# Добавляем PHP 8.2 от Sury
RUN wget -qO - https://packages.sury.org/php/apt.gpg | apt-key add - && \
    echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list && \
    apt-get update

# Установка Apache + PHP + модули, нужные для Moodle
RUN apt-get update && apt-get install -y \
    apache2 php8.2 php8.2-cli php8.2-common php8.2-mysql \
    php8.2-xml php8.2-curl php8.2-zip php8.2-gd php8.2-mbstring \
    php8.2-soap php8.2-intl php8.2-readline php8.2-bcmath \
    php8.2-fileinfo php8.2-exif php8.2-tokenizer php8.2-json \
    php8.2-sodium php8.2-opcache php8.2-dom php8.2-ctype \
    php8.2-simplexml php8.2-xmlreader php8.2-pcre php8.2-hash \
    unzip git curl


# Настройка PHP
RUN echo "max_input_vars = 5000" > /etc/php/8.2/apache2/conf.d/99-moodle.ini

# Копируем весь проект
COPY . /var/www/html

# Права на файлы и moodledata
RUN chown -R www-data:www-data /var/www/html && chmod -R 755 /var/www/html && \
    mkdir -p /var/www/moodledata && \
    chown -R www-data:www-data /var/www/moodledata && \
    chmod -R 777 /var/www/moodledata

# Убираем ворнинг Apache
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Открываем порт
EXPOSE 80

# Запуск Apache
CMD ["apache2ctl", "-D", "FOREGROUND"]
