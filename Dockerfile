# Dockerfile

# Docker image is based on the official Ubuntu 24.04 ("noble") image
# https://hub.docker.com/_/ubuntu
FROM ubuntu:noble

ENV COMPOSER_PARAMETERS="--no-ansi --no-interaction --no-progress"

# Deploy latest Ubuntu updates
RUN apt-get update && apt-get --yes upgrade

# Install additional Ubuntu packages incl. nginx, PHP-FPM, and SQLite
RUN TERM=xterm-256color DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends -q lsb-release ca-certificates apt-transport-https bzip2 graphicsmagick imagemagick mailutils mcrypt patch unzip zip locales curl
RUN TERM=xterm-256color DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends -q nginx php-curl php-fpm php-gd php-imagick php-intl php-mbstring php-mysql php-xml php-zip php-sqlite3 sqlite3

# Configure en_US.UTF-8 locale
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen ; locale-gen --purge en_US.UTF-8 ; dpkg-reconfigure --frontend=noninteractive locales ; update-locale LANG=en_US.UTF-8

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy TYPO3-specific PHP configuration
COPY php.ini /etc/php/8.3/fpm/conf.d/99-typo3.ini

# Download TYPO3 v13 LTS base distribution
RUN cd /var/www && composer ${COMPOSER_PARAMETERS} create-project typo3/cms-base-distribution:^13 typo3v13

# Copy TYPO3 additional configuration
COPY additional.php /var/www/typo3v13/config/system/additional.php

# Set environment variables for non-interactive TYPO3 installation
ENV TYPO3_DB_DRIVER="sqlite"
ENV TYPO3_SETUP_ADMIN_EMAIL="admin@example.com"
ENV TYPO3_SETUP_ADMIN_USERNAME="admin"
ENV TYPO3_SETUP_ADMIN_PASSWORD="password"
ENV TYPO3_PROJECT_NAME="TYPO3 v13 LTS - Ride the Wave"
ENV TYPO3_SETUP_CREATE_SITE="http://localhost:8080"
ENV TYPO3_SERVER_TYPE="other"

# Install TYPO3 v13 LTS
RUN cd /var/www/typo3v13/ && ./vendor/bin/typo3 --no-ansi --force --no-interaction setup

# Clean-up and set proper directory/file ownership
RUN rm -r /var/www/html
RUN chown -Rh www-data: /var/www/typo3v13

WORKDIR /var/www/typo3v13

# Copy bash script as Docker entry point (starts PHP-FPM and nginx)
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod 755 /usr/local/bin/entrypoint.sh

# Copy nginx configuration
COPY nginx.conf /etc/nginx/sites-available/default
RUN chmod 755 /etc/nginx/sites-available/default

# Launch "entrypoint.sh" on Docker container start
CMD ["/usr/local/bin/entrypoint.sh"]
