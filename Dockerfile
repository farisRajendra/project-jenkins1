# Gunakan base image PHP dengan Apache
FROM php:8.2-apache

# Install ekstensi PHP yang dibutuhkan Laravel
RUN apt-get update && apt-get install -y \
    libzip-dev zip unzip git curl \
    && docker-php-ext-install pdo pdo_mysql zip

# Aktifkan mod_rewrite untuk Laravel (dibutuhkan untuk routing)
RUN a2enmod rewrite

# Salin file Laravel ke direktori kerja container
COPY . /var/www/html

# Atur working directory
WORKDIR /var/www/html

# Atur permission storage & bootstrap
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 775 storage bootstrap/cache

# Salin file .env contoh (opsional, jika tidak sudah di dalam repo)
# COPY .env.example .env

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Jalankan composer install
RUN composer install --no-dev --optimize-autoloader

# Expose port Apache (default 80)
EXPOSE 80
