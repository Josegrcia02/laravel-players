# Usar la imagen PHP 8.2 FPM
FROM php:8.2-fpm 

# 1. Instalar dependencias del sistema (incluida libpq-dev para PostgreSQL)
RUN apt-get update && apt-get install -y \ 
    git curl zip unzip libpng-dev libonig-dev libxml2-dev libzip-dev libicu-dev libpq-dev \ 
    nodejs npm \ 
    && docker-php-ext-install pdo pdo_mysql pdo_pgsql mbstring zip exif pcntl gd intl \ 
    && apt-get clean && rm -rf /var/lib/apt/lists/* # 2. Instalar Composer de forma oficial
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Establecer el directorio de trabajo
WORKDIR /var/www 

# Copiar los archivos del proyecto
COPY . . 

# 3. Instalar dependencias de PHP (QUITAMOS EL --no-dev PARA QUE FUNCIONE EL FAKE)
RUN composer install --optimize-autoloader --no-interaction

# 4. Instalar dependencias de Node y compilar assets (Vite)
RUN npm install 
RUN npm run build 

# 5. Ajustar permisos para carpetas de escritura de Laravel
RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache

# Exponer el puerto configurado
EXPOSE 8000 

# 6. COMANDO FINAL
CMD php artisan migrate --force && \
    php artisan db:seed --force && \
    php artisan serve --host=0.0.0.0 --port=8000