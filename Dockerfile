FROM php:8.2-fpm

# 1. Instalar dependencias (ahora con SQLite)
RUN apt-get update && apt-get install -y \
    git unzip zip curl libpng-dev libonig-dev libxml2-dev \
    sqlite3 libsqlite3-dev nginx supervisor \
    && docker-php-ext-install pdo pdo_sqlite mbstring exif pcntl bcmath gd

# 2. Directorios para logs
RUN mkdir -p /var/log/supervisor \
    && mkdir -p /var/log/nginx \
    && mkdir -p /var/log/php-fpm \
    && chown -R www-data:www-data /var/log/nginx /var/log/php-fpm

WORKDIR /var/www/html
COPY . .

# 3. Crear base de datos SQLite
RUN touch database/database.sqlite \
    && chmod 777 database/database.sqlite

# 4. Instalación de Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer install --no-dev --optimize-autoloader --no-interaction

# 5. Permisos
RUN chown -R www-data:www-data /var/www/html \
    && find /var/www/html -type d -exec chmod 755 {} \; \
    && find /var/www/html -type f -exec chmod 644 {} \; \
    && chmod -R 777 storage bootstrap/cache database/database.sqlite

# 6. Configuración final
COPY default.conf /etc/nginx/sites-available/default
COPY supervisor.conf /etc/supervisor/conf.d/

# 7. Volumen para persistencia (opcional)
VOLUME /var/www/html/database

EXPOSE 80

# Script de inicio optimizado para SQLite
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh
CMD ["/usr/local/bin/start.sh"]