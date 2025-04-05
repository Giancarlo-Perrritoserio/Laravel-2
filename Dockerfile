# Usamos PHP 8.2 con FPM
FROM php:8.2-fpm

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    zip \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libpq-dev \
    nginx \
    netcat \
    && docker-php-ext-install pdo pdo_pgsql mbstring exif pcntl bcmath gd

# Verificar configuración de PHP (para depuración)
RUN php --ini

# Copiar archivos del proyecto
WORKDIR /var/www/html
COPY . .

# Instalar Composer y limpiar caché
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer clear-cache && composer install --no-dev --optimize-autoloader

# Copiar configuración de Nginx
COPY default.conf /etc/nginx/sites-available/default

# Permisos correctos
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
RUN chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Copiar script de inicio
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Exponer el puerto HTTP 80
EXPOSE 80

# Ejecutar el script de inicio
CMD ["/start.sh"]
