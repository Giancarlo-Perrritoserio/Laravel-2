#!/bin/bash

# Esperar a que PostgreSQL esté disponible (opcional)
echo "Esperando a que PostgreSQL esté disponible..."
until nc -z -v -w30 "$DB_HOST" "$DB_PORT"; do
  echo "Esperando a la base de datos en $DB_HOST:$DB_PORT..."
  sleep 5
done
echo "PostgreSQL está disponible. Continuando..."

# Generar clave si no existe
if [ ! -f storage/oauth-private.key ]; then
    echo "Generando clave de aplicación..."
    php artisan key:generate --force
fi

# Migrar base de datos
echo "Ejecutando migraciones..."
php artisan migrate --force

# Iniciar servicios
echo "Iniciando servidor..."
service nginx start
php-fpm
