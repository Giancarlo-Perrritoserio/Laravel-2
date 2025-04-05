FROM php:8.2-fpm

# 1. Instalación de dependencias ampliada
RUN apt-get update && apt-get install -y \
    git unzip zip curl libpng-dev libonig-dev libxml2-dev libpq-dev \
    nginx supervisor libzip-dev \
    && docker-php-ext-install pdo pdo_pgsql mbstring exif pcntl bcmath gd zip

# 2. Configuración de PHP para producción
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# 3. Supervisor para manejar Nginx + PHP-FPM
COPY supervisor.conf /etc/supervisor/conf.d/

WORKDIR /var/www/html
COPY . .

# 4. Instalación optimizada de Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer install --no-dev --optimize-autoloader --no-interaction

# 5. Permisos reforzados
RUN chown -R www-data:www-data /var/www/html \
    && find /var/www/html -type f -exec chmod 664 {} \; \
    && find /var/www/html -type d -exec chmod 775 {} \; \
    && chmod -R 777 /var/www/html/storage

# 6. Limpieza de caché
RUN php artisan config:clear \
    && php artisan cache:clear

EXPOSE 80
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]