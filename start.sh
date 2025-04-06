#!/bin/bash

# 1. Configuración inicial
if [ ! -f .env ]; then
    cp .env.example .env
    echo "APP_ENV=production" >> .env
    echo "APP_DEBUG=false" >> .env
    echo "DB_CONNECTION=sqlite" >> .env
    echo "CACHE_DRIVER=file" >> .env
    echo "SESSION_DRIVER=file" >> .env
    echo "QUEUE_CONNECTION=sync" >> .env
fi

# 2. Generar APP_KEY si no existe
if ! grep -q '^APP_KEY=base64' .env; then
    php artisan key:generate --force
fi

# 3. Configurar base de datos SQLite
if [ ! -f database/database.sqlite ]; then
    touch database/database.sqlite
    chmod 777 database/database.sqlite
fi

# 4. Configurar permisos
chown -R www-data:www-data storage bootstrap/cache database
chmod -R 775 storage bootstrap/cache database

# 5. Limpiar cachés
php artisan config:clear
php artisan view:clear
php artisan route:clear

# 6. Migraciones y optimización
php artisan migrate --force
php artisan optimize

# 7. Iniciar servicios
echo "🟢 Iniciando servicios..."
exec /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf