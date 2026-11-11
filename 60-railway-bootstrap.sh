#!/bin/sh
# Runs after upstream's migrations. Creates the first admin and the API token from variables, once.
set -e
APP=/var/www/html

for v in APP_KEY ADMIN_EMAIL ADMIN_PASSWORD API_TOKEN; do
  eval "val=\${$v:-}"
  if [ -z "$val" ]; then
    echo "railway-bootstrap: $v is not set, refusing to start with an open registration page" >&2
    exit 1
  fi
done

php /usr/local/share/railway-bootstrap.php

# artisan ran as root: hand every writable path back to the web user.
chown -R www-data:www-data /data "$APP/storage" "$APP/bootstrap/cache"
