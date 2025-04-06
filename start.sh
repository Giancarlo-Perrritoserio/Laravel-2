#!/bin/bash

# Configuración de conexión a PostgreSQL
DB_HOST="dpg-cvotovpr0fns739tce3g-a"  # Usa el hostname INTERNO
DB_PORT=5432
DB_USER="semana2_ktof_user"
DB_NAME="semana2_ktof"
DB_PASS="Dlydxk01OPr57dOQZIKD2HEbPJ1eKwvW"

# Función para verificar conexión
check_db_connection() {
    echo "Intentando conectar a PostgreSQL..."
    for i in {1..10}; do
        if PGPASSWORD=$DB_PASS psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "SELECT 1" >/dev/null 2>&1; then
            echo "✅ ¡Conexión exitosa a PostgreSQL!"
            return 0
        fi
        echo "Intento $i/10 fallido. Esperando 5 segundos..."
        sleep 5
    done
    echo "❌ Error: No se pudo conectar a PostgreSQL después de 50 segundos"
    return 1
}

# Verificar conexión
if ! check_db_connection; then
    # Mostrar información de diagnóstico
    echo "=== DIAGNÓSTICO ==="
    echo "Host: $DB_HOST"
    echo "Port: $DB_PORT"
    echo "User: $DB_USER"
    echo "Database: $DB_NAME"
    echo "Password: ${DB_PASS:0:2}***** (oculto por seguridad)"
    exit 1
fi

# Configuración de Laravel
php artisan config:clear
php artisan cache:clear

# Generar clave de aplicación si no existe
if [ -z "$(grep '^APP_KEY=base64' .env)" ]; then
    php artisan key:generate --force
fi

# Ejecutar migraciones (solo si existe la tabla migrations)
if PGPASSWORD=$DB_PASS psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "\dt" | grep -q migrations; then
    php artisan migrate --force
else
    echo "La tabla migrations no existe. Ejecuta manualmente las migraciones."
fi

# Iniciar servicios
echo "🚀 Iniciando servicios..."
exec /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf