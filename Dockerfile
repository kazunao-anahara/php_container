FROM php:7.2.7-fpm-alpine

RUN apk update \
	&& apk add --no-cache \
		libbz2 \
		gd \
		gettext \
		libmcrypt \
		libxslt \
	&& apk add --no-cache --virtual .build-php \
		$PHPIZE_DEPS \
		mariadb \
		mariadb-dev \
		gd-dev \
		jpeg-dev \
		libpng-dev \
		libwebp-dev \
		libxpm-dev \
		zlib-dev \
		freetype-dev \
		bzip2-dev \
		libexif-dev \
		xmlrpc-c-dev \
		pcre-dev \
		gettext-dev \
		libmcrypt-dev \
		libxslt-dev \
	&& pecl install apcu \
	&& docker-php-ext-enable apcu \
	&& pecl install apcu_bc \
	&& docker-php-ext-install \
		mysqli \
		opcache \
		gd \
		bz2 \
		pdo pdo_mysql \
		bcmath exif gettext pcntl \
		soap sockets sysvsem sysvshm xmlrpc xsl zip \
	&& apk del .build-php \
	&& rm -f /usr/local/etc/php/conf.d/docker-php-ext-apc.ini \
	&& rm -f /usr/local/etc/php/conf.d/docker-php-ext-apcu.ini \
	&& rm -f /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini \
	&& mkdir -p /etc/php.d/

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
	php wp-cli.phar --info && \
	chmod +x wp-cli.phar && \
	mv wp-cli.phar /usr/local/bin/wp && \
	wget https://phar.phpunit.de/phpunit-6.5.phar && \
	chmod +x phpunit-6.5.phar && \
	mv phpunit-6.5.phar /usr/local/bin/phpunit