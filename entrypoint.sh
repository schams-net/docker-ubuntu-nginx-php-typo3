#!/bin/sh
set -e

# Start FastCGI Process Manager (FPM)
/etc/init.d/php8.3-fpm start

# Start nginx in the foreground
nginx -g "daemon off;"
