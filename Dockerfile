FROM debian:bullseye

# Установка зависимостей
RUN apt-get update && \
    apt-get install -y apt-transport-https lsb-release ca-certificates wget gnupg

# Добавляем репозиторий PHP 8.2
RUN wget -qO - https://packages.sury.org/php/apt.gpg | apt-key add - && \
    echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list && \
    apt-get update

# Установка Apache и PHP 8.2 + нужные модули
RUN apt-get install -y apache2 php8.2 php8.2-cli php8.2-common php8.2-mysql php8.2-pgsql php8.2-xml php8.2-curl php8.2-zip php8.2-gd php8.2-mbstring php8.2-soap php8.2-intl php8.2-readline php8.2-bcmath libapache2-mod-php8.2 unzip git
RUN cp /etc/hosts /tmp/hosts && \
    echo "13.48.98.205 db.yekhlncemkkubciednku.supabase.co" >> /tmp/hosts && \
    cp /tmp/hosts /etc/hosts


# Копируем Moodle (если он уже в папке)
COPY . /var/www/html

# Права доступа
RUN chown -R www-data:www-data /var/www/html && chmod -R 755 /var/www/html
# Создать каталог moodledata и дать права
RUN mkdir -p /var/www/moodledata && \
    chown -R www-data:www-data /var/www/moodledata && \
    chmod -R 0777 /var/www/moodledata

# Добавляем ServerName, чтобы не было ворнинга
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Открываем порт
EXPOSE 80

# Запуск Apache
CMD ["apache2ctl", "-D", "FOREGROUND"]
