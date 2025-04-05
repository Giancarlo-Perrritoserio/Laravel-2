#!/bin/bash

# Validar que las variables de entorno necesarias estén presentes
if [ -z "$DB_HOST" ] || [ -z "$DB_PORT" ]; then
  echo "❌ ERROR: Las variables DB_HOST o DB_PORT no están definidas."
  exit 1
fi

echo "⏳ Esperando a que PostgreSQL esté disponible en $DB_HOST:$DB_PORT..."

# Esperar a la base de datos con retry loop
until nc -z -v -w5 "$DB_HOST" "$DB_PORT"; do
  echo "⏳ Esperando conexión a la base de datos..."
  sleep 5
done

echo "✅ Conexión con la base de datos establecida."

# Generar clave de aplicación si no está presente
if [ -z "$APP_KEY" ] || [ "$APP_KEY" == "base64:AAAAAAAAAAAAAAAAAAAAA==" ]; then
  echo "🔑 Generando APP_KEY..."
  php artisan key:generate --force
else
  echo "🔑 APP_KEY ya está definido."
fi

# Migrar base de datos
echo "📦 Ejecutando migraciones..."
php artisan migrate --force

# Iniciar servicios
echo "🚀 Iniciando servidor Nginx y PHP-FPM..."
service nginx start
exec php-fpm
