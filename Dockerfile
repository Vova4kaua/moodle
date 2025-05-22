FROM debian:bullseye

# Установка зависимостей
RUN apt-get update && \
    apt-get install -y apt-transport-https lsb-release ca-certificates wget gnupg

# Добавление репозитория PHP 8.2
RUN wget -qO - https://packages.sury.org/php/apt.gpg | apt-key add - && \
    echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list && \
    apt-get update

# Установка Apache, PHP, MySQL и нужных модулей
RUN apt-get install -y apache2 mariadb-server php8.2 php8.2-cli php8.2-common php8.2-mysql \
    php8.2-xml php8.2-curl php8.2-zip php8.2-gd php8.2-mbstring php8.2-soap \
    php8.2-intl php8.2-readline php8.2-bcmath libapache2-mod-php8.2 unzip git

# Копируем Moodle
COPY . /var/www/html

# Права на файлы
RUN chown -R www-data:www-data /var/www/html && chmod -R 755 /var/www/html

# moodledata
RUN mkdir -p /var/www/moodledata && \
    chown -R www-data:www-data /var/www/moodledata && chmod -R 777 /var/www/moodledata

# Убираем ворнинг Apache
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Порт
EXPOSE 80

# Создаём скрипт запуска
RUN echo '#!/bin/bash\n\
service mysql start\n\
mysql -e "CREATE DATABASE IF NOT EXISTS moodle;"\n\
mysql -e "CREATE USER IF NOT EXISTS '\''moodle'\''@'\''localhost'\'' IDENTIFIED BY '\''moodlepass'\'';"\n\
mysql -e "GRANT ALL PRIVILEGES ON moodle.* TO '\''moodle'\''@'\''localhost'\'';"\n\
mysql -e "FLUSH PRIVILEGES;"\n\
apache2ctl -D FOREGROUND' > /start.sh && chmod +x /start.sh

# Запуск
CMD ["/start.sh"]
