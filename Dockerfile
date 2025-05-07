# Gunakan image PHP + Apache untuk Windows
FROM php:8.2-apache

# Set working directory
WORKDIR /var/www/html

# Install dependencies untuk Laravel
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip

# Install ekstensi PHP yang diperlukan
RUN docker-php-ext-install pdo pdo_mysql mbstring exif pcntl bcmath gd

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy semua file Laravel ke container
COPY . .

# Install dependencies Laravel
RUN composer install --no-interaction --prefer-dist --optimize-autoloader

# Generate Laravel key (jika .env belum ada)
RUN if [ ! -f ".env" ]; then cp .env.example .env && php artisan key:generate; fi

# Set permission storage
RUN chown -R www-data:www-data /var/www/html/storage
RUN chmod -R 775 /var/www/html/storage

# Expose port 80
EXPOSE 80

# Jalankan Apache
CMD ["apache2-foreground"]