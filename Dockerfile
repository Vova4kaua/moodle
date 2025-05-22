FROM debian:bullseye

# Установка зависимостей
RUN apt-get update && \
    apt-get install -y apt-transport-https lsb-release ca-certificates wget gnupg

# Добавление репозитория PHP 8.2
RUN wget -qO - https://packages.sury.org/php/apt.gpg | apt-key add - && \
    echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list && \
    apt-get update

# Установка Apache, PHP и модулей
RUN apt-get install -y apache2 php8.2 php8.2-cli php8.2-common php8.2-mysql \
    php8.2-xml php8.2-curl php8.2-zip php8.2-gd php8.2-mbstring php8.2-soap \
    php8.2-intl php8.2-readline php8.2-bcmath libapache2-mod-php8.2 \
    unzip git mariadb-server

# Копируем Moodle
COPY . /var/www/html

# Права
RUN chown -R www-data:www-data /var/www/html && chmod -R 755 /var/www/html

# Создаём папку moodledata
RUN mkdir -p /var/www/moodledata && \
    chown -R www-data:www-data /var/www/moodledata && \
    chmod -R 777 /var/www/moodledata

# Настройка MySQL и создание БД
RUN service mysql start && \
    mysql -e "CREATE DATABASE moodle;" && \
    mysql -e "CREATE USER 'moodle'@'localhost' IDENTIFIED BY 'moodlepass';" && \
    mysql -e "GRANT ALL PRIVILEGES ON moodle.* TO 'moodle'@'localhost';" && \
    mysql -e "FLUSH PRIVILEGES;"

# Убираем предупреждение Apache
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Открываем порт
EXPOSE 80

# Запускаем и Apache, и MySQL
CMD service mysql start && apache2ctl -D FOREGROUND
