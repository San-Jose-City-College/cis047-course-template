FROM mcr.microsoft.com/devcontainers/php:1-8.3-apache

# Install system dependencies and tools
RUN apt-get update && apt-get install -y \
    mariadb-client \
    mysql-client \
    git \
    zip \
    unzip \
    curl \
    wget \
    vim \
    nano \
    build-essential \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions required for web development
RUN docker-php-ext-install \
    mysqli \
    pdo \
    pdo_mysql \
    opcache \
    json

# Install and enable additional useful PHP extensions
RUN pecl install xdebug && docker-php-ext-enable xdebug

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Enable Apache modules
RUN a2enmod rewrite && \
    a2enmod headers && \
    a2enmod ssl

# Set the Apache document root to the public folder
ENV APACHE_DOCUMENT_ROOT=/workspaces/cis047-course-template/public

# Update Apache configuration to use the public folder as document root
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' \
    /etc/apache2/sites-available/*.conf && \
    sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' \
    /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Configure PHP for development
RUN echo "display_errors = On" >> /usr/local/etc/php/conf.d/99-custom.ini && \
    echo "error_reporting = E_ALL" >> /usr/local/etc/php/conf.d/99-custom.ini && \
    echo "xdebug.mode = debug" >> /usr/local/etc/php/conf.d/99-custom.ini && \
    echo "xdebug.start_with_request = yes" >> /usr/local/etc/php/conf.d/99-custom.ini && \
    echo "xdebug.client_host = host.docker.internal" >> /usr/local/etc/php/conf.d/99-custom.ini && \
    echo "xdebug.client_port = 9003" >> /usr/local/etc/php/conf.d/99-custom.ini && \
    echo "post_max_size = 128M" >> /usr/local/etc/php/conf.d/99-custom.ini && \
    echo "upload_max_filesize = 128M" >> /usr/local/etc/php/conf.d/99-custom.ini

# Create necessary directories
RUN mkdir -p /workspaces/cis047-course-template/public && \
    mkdir -p /workspaces/cis047-course-template/database

# Set working directory
WORKDIR /workspaces/cis047-course-template

# Expose Apache port
EXPOSE 80 443

# Start Apache in foreground
CMD ["apache2-foreground"]
