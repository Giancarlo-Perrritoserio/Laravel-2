FROM php:8.2-fpm

RUN apt-get update && apt-get install -y \
    git unzip zip curl libpng-dev libonig-dev libxml2-dev libpq-dev nginx \
    && docker-php-ext-install pdo pdo_pgsql mbstring exif pcntl bcmath gd

WORKDIR /var/www/html
COPY . .

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer install --no-dev --optimize-autoloader

COPY default.conf /etc/nginx/sites-available/default

RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

EXPOSE 80
CMD service nginx start && php-fpm