# We need a reusable list of PHP extensions to install for all the targets
# If you need any additional extensions, feel free to add them here
ARG PHP_EXTS="bcmath ctype fileinfo mbstring pdo pdo_mysql tokenizer dom exif pcntl intl sockets gd zip"

# We need a reusable list of PHP extensions installable through pecl for all the targets
ARG PHP_PECL_EXTS="redis amqp mongodb"
ARG PHP_VERSION="7.4"
ARG ALPINE_VERSION="3.14"

################################################################################################
################################################################################################

FROM php:${PHP_VERSION}-fpm-alpine${ALPINE_VERSION} as php_with_dep
# We need to declare that we want to use the args in this build step
ARG PHPIZE_DEPS
ARG PHP_EXTS
ARG PHP_PECL_EXTS
ARG ALPINE_VERSION
RUN echo -e "https://repo.snapp.tech/repository/alpine/v${ALPINE_VERSION}/main\nhttps://repo.snapp.tech/repository/alpine/v${ALPINE_VERSION}/community" > /etc/apk/repositories


RUN apk add --virtual build-dependencies --no-cache icu-dev autoconf g++ make zlib-dev libzip-dev rabbitmq-c rabbitmq-c-dev libpng libpng-dev libjpeg-turbo-dev libwebp-dev gd openssl ca-certificates libxml2-dev oniguruma-dev
RUN docker-php-ext-install -j$(nproc) ${PHP_EXTS}
RUN pecl install ${PHP_PECL_EXTS}
RUN docker-php-ext-enable ${PHP_PECL_EXTS}



################################################################################################
################################################################################################

FROM php_with_dep as code_base

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set our working directory
WORKDIR /opt/apps

# We need to create a composer group and user, and create a home directory for it, so we keep the rest of our image safe,
# And not accidentally run malicious scripts
RUN addgroup -S composer \
    && adduser -S composer -G composer \
    && chown -R composer /opt/apps

# Next we want to switch over to the composer user before running installs.
USER composer

# Copy in our dependency files
COPY --chown=composer composer.json composer.lock ./

# Install all the dependencies without running any installation scripts.
# The reason we skip scripts, is the code base hasn't been copied in yet and script will likely fail,
# as artisan isn't in yet.
# This also helps us to cache previous runs and layers.
# As long as comoser.json and composer.lock doesn't change the install will be cached.
RUN composer install --no-dev --no-scripts --no-autoloader --prefer-dist

# Copy in our actual source code so we can run the installation scripts we need
COPY --chown=composer . .

RUN mkdir -p storage/framework/views && \
    mkdir -p storage/framework/cache

# Install all the dependencies running installation scripts as well
RUN composer install --no-dev --prefer-dist



################################################################################################
################################################################################################
FROM php_with_dep as fpm


WORKDIR /opt/apps

# Next we have to copy in our code base from our initial build which we installed in the previous stage
COPY --from=code_base /opt/apps .

RUN mkdir -p storage/logs && mkdir -p storage/framework/views && mkdir -p storage/framework/sessions
RUN chmod 777 -R storage/


RUN mkdir -p storage/framework/views
# Next we want to cache the event, routes, and views so we don't try to write them when we are in Kubernetes
RUN php artisan event:cache && \
    php artisan route:cache && \
    php artisan view:cache

EXPOSE 9000


################################################################################################
################################################################################################
FROM php_with_dep as cron

RUN apk add supervisor

# Set the working directory, same as previously
WORKDIR /opt/apps

USER root

# Copy locations.json file
RUN  mkdir -p storage/app/files/
COPY ./locations.json  storage/app/files/

# Next we have to copy in our code base from our initial build which we installed in the previous stage
COPY --from=code_base /opt/apps .
COPY supervisord.conf /etc/supervisor/supervisord.conf
COPY supervisord.conf /etc/supervisord.conf

# We want to create a laravel.cron file with Laravel cron settings, which we can import into crontab,
# and run crond as the primary command in the forground
RUN touch laravel.cron && \
    echo "    * cd /opt/apps && php artisan schedule:run" >> laravel.cron && \
    crontab laravel.cron

CMD ["./entrypoint.sh"]


################################################################################################
################################################################################################
FROM nginxinc/nginx-unprivileged:1.20-alpine as webserver

# Set the working directory, same as previously
WORKDIR /opt/apps

COPY docker/nginx.conf.template /etc/nginx/templates/default.conf.template

# Copy in ONLY the public directory of our project.
# This is where all the static assets will live, which nginx will serve for us.
# Any PHP requests will be passed down to FPM
COPY --from=code_base /opt/apps/public /opt/apps/public
EXPOSE 8080
