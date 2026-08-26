FROM mcr.microsoft.com/devcontainers/php:1-8.2-apache

# Install additional PHP extensions
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Enable Apache modules
RUN a2enmod rewrite

# Set the Apache document root to the public folder
ENV APACHE_DOCUMENT_ROOT=/workspaces/cis047-course-template/public

# Update the Apache configuration
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Install Node.js and npm
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && apt-get install -y nodejs

# Install additional tools
RUN apt-get update && apt-get install -y \
    mysql-client \
    git \
    zip \
    unzip
