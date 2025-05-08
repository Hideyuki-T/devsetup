FROM php:8.2-fpm

# システム依存ライブラリをインストール
RUN apt-get update && apt-get install -y \
    libonig-dev \
    libzip-dev \
    zip \
    unzip \
    curl \
    default-mysql-client \
    libmysqlclient-dev \
    libicu-dev \
    libxml2-dev \
  && docker-php-ext-install \
       pdo_mysql \
       mbstring \
       zip \
       intl \
       xml \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

# Node.js（必要なら）
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
 && apt-get update && apt-get install -y nodejs \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

# Composer をコピー
COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer

WORKDIR /var/www/html

CMD ["php-fpm"]
