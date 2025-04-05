FROM php:8.2-fpm

# 1. Instalar dependencias específicas para PostgreSQL (CORREGIDO)
RUN apt-get update && apt-get install -y \
    git unzip zip curl libpng-dev libonig-dev libxml2-dev \
    libpq-dev nginx supervisor \
    && docker-php-ext-install pdo pdo_pgsql mbstring exif pcntl bcmath gd

# 2. Configuración de PHP para producción
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# 3. Configuración de Supervisor
COPY supervisor.conf /etc/supervisor/conf.d/

WORKDIR /var/www/html
COPY . .

# 4. Instalación de Composer (sin SQLite)
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer install --no-dev --optimize-autoloader --no-interaction

# 5. Permisos (sin /database)
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# 6. Configuración de entorno (usa variables de Render)
RUN php artisan config:clear

EXPOSE 80
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]