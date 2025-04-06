#!/bin/bash

# Configuración de Laravel
php artisan config:clear
php artisan cache:clear

# Crear base de datos SQLite si no existe
if [ ! -f database/database.sqlite ]; then
    touch database/database.sqlite
    chmod 777 database/database.sqlite
    echo "✅ Base de datos SQLite creada"
fi

# Configurar .env si no existe (para Render)
if [ ! -f .env ]; then
    echo "⚙️ Creando archivo .env..."
    cp .env.example .env
    # Configuración mínima para SQLite
    echo "DB_CONNECTION=sqlite" >> .env
    echo "CACHE_DRIVER=array" >> .env
    echo "SESSION_DRIVER=file" >> .env
    echo "QUEUE_CONNECTION=sync" >> .env
fi

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

# Ejecutar migraciones (forzar todas)
php artisan migrate:fresh --force

# Optimizar la aplicación
php artisan optimize


# Iniciar servicios
echo "🚀 Iniciando servicios..."
exec /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf