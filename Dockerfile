# Use PHP 8.4 FPM image
FROM php:8.4-fpm

# Install system dependencies
# Se añade libpq-dev para que las extensiones de PostgreSQL puedan compilarse
RUN apt-get update && apt-get install -y \
    git curl zip unzip libpng-dev libonig-dev libxml2-dev libzip-dev libicu-dev \
    libpq-dev \
    nodejs npm \
    && docker-php-ext-install pdo pdo_pgsql pgsql mbstring zip exif pcntl gd intl \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Instalar Composer copiando el binario oficial
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www

# Copy project files
COPY . .

# Install PHP dependencies
composer install --no-dev --optimize-autoloader --no-interaction && npm install && npm run build && php artisan migrate --force

# Install Node dependencies
RUN npm install
RUN npm run build

# Expose port
EXPOSE 8000

# El comando utiliza 0.0.0.0 para que sea accesible desde fuera del contenedor
CMD php artisan serve --host=0.0.0.0 --port=8000