# larapaper-railway

Thin wrapper over `ghcr.io/usetrmnl/larapaper` (TRMNL e-ink BYOS server) for the Railway template "LaraPaper".
Takes `APP_KEY` from the deploy instead of the key baked into upstream's image, creates the first admin and an API token
from `ADMIN_EMAIL` / `ADMIN_PASSWORD` / `API_TOKEN` at boot so registration is closed before the first request, and keeps the
SQLite database and generated screen images on the single Railway volume mounted at `/data`.
