FROM php:8.2-fpm

# Install dependensi
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    nodejs \
    npm

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install ekstensi PHP
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Pasang Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set directory kerja
WORKDIR /var/www

# Salin aplikasi ke container
COPY . /var/www

# Atur permission
RUN chown -R www-data:www-data /var/www
RUN chmod -R 755 /var/www/storage

# Install dependensi PHP
RUN composer install --no-interaction --no-dev --optimize-autoloader

# Install dependensi Node.js dan build assets
RUN npm install && npm run build

# Ekspos port PHP-FPM
EXPOSE 9000

CMD ["php-fpm"]