# Usar la imagen PHP 8.2 FPM
FROM php:8.2-fpm 

# 1. Instalar dependencias del sistema y extensiones PHP para PostgreSQL
RUN apt-get update && apt-get install -y \ 
    git curl zip unzip libpng-dev libonig-dev libxml2-dev libzip-dev libicu-dev libpq-dev \ 
    nodejs npm \ 
    && docker-php-ext-install pdo pdo_pgsql pgsql mbstring zip exif pcntl gd intl \ 
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 2. Instalar Composer de forma oficial
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Directorio de trabajo
WORKDIR /var/www 

# Copiar archivos
COPY . . 

# 3. Instalar dependencias (Sin --no-dev para asegurar que los Seeders carguen bien)
RUN composer install --optimize-autoloader --no-interaction

# 4. Assets de Frontend
RUN npm install && npm run build 

# 5. Permisos críticos para Laravel
RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache

EXPOSE 8000 

# 6. COMANDO DE ARRANQUE SEGURO
# Primero migra (crea tablas), luego intenta seed (mete datos), luego arranca.
CMD php artisan migrate --force && \
    php artisan db:seed --class=PlayerSeeder --force && \
    php artisan serve --host=0.0.0.0 --port=8000