FROM php:7.4-fpm

# Set working directory
WORKDIR /var/www/html

# Install dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    git \
    curl \
    libzip-dev \
    libssl-dev \
    libcurl4-openssl-dev \
    pkg-config \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    sudo \
    gnupg \
    apt-transport-https \
    lsb-release

# Install necessary packages for SQL Server driver
RUN apt-get install -y \
    freetds-bin \
    freetds-dev \
    tdsodbc \
    locales

# Set locale to enable UTF-8
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install mysqli pdo_mysql mbstring exif pcntl bcmath gd zip

# Install Redis extension
RUN pecl install redis && docker-php-ext-enable redis

# Install MongoDB extension (use legacy version for PHP 7.4)
RUN pecl install mongodb-1.13.0 && docker-php-ext-enable mongodb

# Install Xdebug
RUN pecl install xdebug-3.1.6 \
    && docker-php-ext-enable xdebug

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Add user for laravel application
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

# Change current user to www
USER www

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]