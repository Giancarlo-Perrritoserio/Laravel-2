#!/bin/bash

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
    
    # Configuración esencial para SQLite
    cat > .env <<EOL
APP_ENV=production
APP_DEBUG=false
DB_CONNECTION=sqlite
CACHE_DRIVER=array
SESSION_DRIVER=database
QUEUE_CONNECTION=sync
EOL
fi

# Generar clave de aplicación si no existe
if ! grep -q '^APP_KEY=base64' .env; then
    php artisan key:generate --force
fi

# Limpiar configuraciones
php artisan config:clear
php artisan cache:clear

# Ejecutar migraciones (solo una vez)
php artisan migrate --force

# Optimizar la aplicación
php artisan optimize

# Configurar permisos finales
chmod -R 775 storage bootstrap/cache database/database.sqlite
chown -R www-data:www-data storage bootstrap/cache database/database.sqlite

# Iniciar servicios
echo "🚀 Iniciando servicios..."
exec /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf