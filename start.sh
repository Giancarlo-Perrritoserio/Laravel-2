#!/bin/bash

echo "Esperando a que PostgreSQL esté disponible..."
until nc -z -v -w30 "$DB_HOST" "$DB_PORT"; do
  echo "Esperando a la base de datos en $DB_HOST:$DB_PORT..."
  sleep 5
done

echo "Generando clave de aplicación si es necesario..."
php artisan key:generate --force

echo "Ejecutando migraciones..."
php artisan migrate --force

echo "Iniciando servidor..."
service nginx start
php-fpm
