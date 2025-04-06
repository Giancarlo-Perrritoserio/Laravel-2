#!/bin/bash

# Configuración de variables
DB_HOST="dpg-cvk2plruibrs739sj38g-a"
DB_PORT="5432"
DB_USER="pruebarender_db_user"
DB_NAME="pruebarender_db"
DB_PASS="O2sW813IkSxZO4LTZ4mAaAZ5HEYwCydI"

# Esperar a PostgreSQL con timeout
echo "Esperando a PostgreSQL..."
for i in {1..30}; do
    if PGPASSWORD=$DB_PASS psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "SELECT 1" >/dev/null 2>&1; then
        echo "PostgreSQL está listo!"
        break
    fi
    sleep 2
    if [ $i -eq 30 ]; then
        echo "Error: No se pudo conectar a PostgreSQL después de 60 segundos"
        exit 1
    fi
done

# Configuración de Laravel
php artisan config:clear
php artisan cache:clear

# Solo generar clave si no existe
if [ -z "$(grep '^APP_KEY=base64' .env)" ]; then
    php artisan key:generate --force
fi

# Ejecutar migraciones (opcional, quitar si no se necesitan)
php artisan migrate --force

# Iniciar servicios
echo "Iniciando servicios..."
exec /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf