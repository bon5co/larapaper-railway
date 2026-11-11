# LaraPaper for Railway.
#
# Upstream ships a .env with ONE APP_KEY baked into the image (every container of the stock image shares it),
# opens the first-account registration to whoever reaches the URL first, and keeps its SQLite file and generated
# screen images under two separate paths (two volumes in its compose file; Railway gives a service one).
# This wrapper (1) takes APP_KEY from the deploy, (2) creates the first admin and an API token from
# ADMIN_EMAIL / ADMIN_PASSWORD / API_TOKEN at boot, so registration is closed before the first request,
# and (3) puts the database and the generated images on the single volume at /data.
FROM ghcr.io/usetrmnl/larapaper:0.46.0@sha256:98d14dcf52531e92a5c27bc1f4cfdc57bf5e04d41fc3759b0fb8d21d9834d739

USER root

ENV APP_ENV=production \
    APP_DEBUG=false \
    DB_CONNECTION=sqlite \
    DB_DATABASE=/data/database.sqlite \
    FORCE_HTTPS=true \
    SESSION_SECURE_COOKIE=true \
    MULTIUSER_REGISTRATION_ENABLED=false \
    LOG_CHANNEL=stderr \
    LOG_STACK=stderr \
    LOG_LEVEL=warning \
    TRUSTED_PROXY=off \
    PHP_OPCACHE_ENABLE=1 \
    ADMIN_NAME=Admin

COPY 20-railway-data.sh /etc/entrypoint.d/20-railway-data.sh
COPY 60-railway-bootstrap.sh /etc/entrypoint.d/60-railway-bootstrap.sh
COPY bootstrap.php /usr/local/share/railway-bootstrap.php
RUN chmod +x /etc/entrypoint.d/20-railway-data.sh /etc/entrypoint.d/60-railway-bootstrap.sh \
 && grep -q "ADMIN_PASSWORD" /usr/local/share/railway-bootstrap.php
