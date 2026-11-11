#!/bin/sh
# Runs before upstream's migrations (50-laravel-automations.sh). One Railway volume at /data holds the SQLite
# file and the generated screen images; the app's image path becomes a symlink into it.
set -e
APP=/var/www/html
mkdir -p /data/images
[ -e /data/database.sqlite ] || : > /data/database.sqlite

gen="$APP/storage/app/public/images/generated"
if [ ! -L "$gen" ]; then
  [ -d "$gen" ] && cp -a "$gen/." /data/images/ 2>/dev/null || true
  rm -rf "$gen"
  ln -s /data/images "$gen"
fi

chown -R www-data:www-data /data
echo "railway-data: uid=$(id -u) data_owner=$(stat -c %u:%g /data) writable=$(test -w /data && echo yes || echo no)"
