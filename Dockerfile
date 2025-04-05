FROM php:8.2-fpm

# 1. Instalar dependencias
RUN apt-get update && apt-get install -y \
    git unzip zip curl libpng-dev libonig-dev libxml2-dev \
    libpq-dev nginx supervisor \
    && docker-php-ext-install pdo pdo_pgsql mbstring exif pcntl bcmath gd

# 2. Directorios para logs (VERSIÓN CORREGIDA)
RUN mkdir -p /var/log/supervisor \
    && mkdir -p /var/log/nginx \
    && mkdir -p /var/log/php-fpm \
    && chown -R www-data:www-data /var/log/nginx /var/log/php-fpm

# 3. Configuración PHP-FPM CORREGIDA
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" \
    && echo -e "\
pm = dynamic\n\
pm.max_children = 5\n\
pm.start_servers = 2\n\
pm.min_spare_servers = 1\n\
pm.max_spare_servers = 3\n\
pm.max_requests = 500\n\
" >> /usr/local/etc/php-fpm.d/www.conf


WORKDIR /var/www/html
COPY . .

# 4. Composer y entorno
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer install --no-dev --optimize-autoloader --no-interaction \
    && cp .env.example .env \
    && php artisan key:generate

# 5. Permisos completos
RUN chown -R www-data:www-data /var/www/html \
    && find /var/www/html -type d -exec chmod 755 {} \; \
    && find /var/www/html -type f -exec chmod 644 {} \; \
    && chmod -R 777 storage bootstrap/cache

# 6. Configuración final
COPY default.conf /etc/nginx/sites-available/default
COPY supervisor.conf /etc/supervisor/conf.d/

EXPOSE 80
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]