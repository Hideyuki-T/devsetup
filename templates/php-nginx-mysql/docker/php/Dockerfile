FROM php:8.2-fpm

RUN apt-get update && apt-get install -y \
    libonig-dev \
    libzip-dev \
    zip \
    unzip \
    curl \
  && docker-php-ext-install pdo_mysql mbstring zip \
  && apt-get clean

WORKDIR /var/www/html

CMD ["php-fpm"]
