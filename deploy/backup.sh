#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
mkdir -p backups
docker compose exec -T mysql sh -c \
  'exec mysqldump --single-transaction --routines -uroot -p"$MYSQL_ROOT_PASSWORD" "$MYSQL_DATABASE"' \
  | gzip > "backups/orchestra-$(date +%F_%H%M).sql.gz"
find backups -name '*.sql.gz' -mtime +14 -delete