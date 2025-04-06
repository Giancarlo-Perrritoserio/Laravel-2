FROM php:8.2-fpm

# 1. Instalar dependencias (SQLite + PostgreSQL por si acaso)
RUN apt-get update && apt-get install -y \
    git unzip zip curl libpng-dev libonig-dev libxml2-dev \
    sqlite3 libsqlite3-dev libpq-dev nginx supervisor \
    && docker-php-ext-install pdo pdo_sqlite pdo_pgsql mbstring exif pcntl bcmath gd

# 2. Directorios para logs y sesiones
RUN mkdir -p /var/log/supervisor \
    && mkdir -p /var/log/nginx \
    && mkdir -p /var/log/php-fpm \
    && mkdir -p /var/www/html/storage/framework/sessions \
    && chown -R www-data:www-data /var/log/nginx /var/log/php-fpm /var/www/html/storage

# 3. Configuración de PHP
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

WORKDIR /var/www/html
COPY . .

# 4. Crear archivos esenciales
RUN touch database/database.sqlite \
    && touch storage/logs/laravel.log \
    && chmod -R 777 storage bootstrap/cache database/database.sqlite

# 5. Instalación de Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer install --no-dev --optimize-autoloader --no-interaction

# 6. Configuración final
COPY default.conf /etc/nginx/sites-available/default
COPY supervisor.conf /etc/supervisor/conf.d/

# 7. Volumen para persistencia
VOLUME /var/www/html/storage /var/www/html/database

EXPOSE 80

# Script de inicio optimizado
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh
CMD ["/usr/local/bin/start.sh"]