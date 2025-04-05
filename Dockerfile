FROM php:8.2-fpm

# 1. Instalar dependencias
RUN apt-get update && apt-get install -y \
    git unzip zip curl libpng-dev libonig-dev libxml2-dev \
    libpq-dev nginx supervisor \
    && docker-php-ext-install pdo pdo_pgsql mbstring exif pcntl bcmath gd

# 2. Directorios para logs
RUN mkdir -p /var/log/supervisor \
    && mkdir -p /var/log/nginx \
    && mkdir -p /var/log/php-fpm \
    && chown -R www-data:www-data /var/log/nginx /var/log/php-fpm

# 3. Configuración PHP-FPM CORREGIDA (sin usar echo -e)
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" && \
    { \
        echo '[www]'; \
        echo 'pm = dynamic'; \
        echo 'pm.max_children = 5'; \
        echo 'pm.start_servers = 2'; \
        echo 'pm.min_spare_servers = 1'; \
        echo 'pm.max_spare_servers = 3'; \
        echo 'pm.max_requests = 500'; \
    } > /usr/local/etc/php-fpm.d/zz-docker.conf

WORKDIR /var/www/html
COPY . .

# 4. Instalación de Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer install --no-dev --optimize-autoloader --no-interaction

# 5. Configuración de entorno
RUN cp .env.example .env && php artisan key:generate

# 6. Permisos
RUN chown -R www-data:www-data /var/www/html \
    && find /var/www/html -type d -exec chmod 755 {} \; \
    && find /var/www/html -type f -exec chmod 644 {} \; \
    && chmod -R 777 storage bootstrap/cache

# 7. Configuración final
COPY default.conf /etc/nginx/sites-available/default
COPY supervisor.conf /etc/supervisor/conf.d/

# Verificar conexión a PostgreSQL
RUN apt-get install -y postgresql-client \
    && pg_isready -h $DB_HOST -p $DB_PORT -U $DB_USERNAME -d $DB_DATABASE \
    && php artisan config:clear \
    && php artisan cache:clear

    
EXPOSE 80
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]