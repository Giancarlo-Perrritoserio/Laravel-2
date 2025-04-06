#!/bin/bash

# Configuración de Laravel
php artisan config:clear
php artisan cache:clear

# Generar clave de aplicación si no existe
if [ -z "$(grep '^APP_KEY=base64' .env)" ]; then
    php artisan key:generate --force
fi

# Crear base de datos SQLite si no existe
if [ ! -f database/database.sqlite ]; then
    touch database/database.sqlite
    chmod 777 database/database.sqlite
    echo "✅ Base de datos SQLite creada"
fi

# Ejecutar migraciones
php artisan migrate --force

# Iniciar servicios
echo "🚀 Iniciando servicios..."
exec /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf