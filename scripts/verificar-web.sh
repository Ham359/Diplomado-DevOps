#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
source "$ROOT_DIR/scripts/env.sh"
WEB_URL="$(bash "$ROOT_DIR/scripts/tf.sh" output -raw web_url)"
PAGE="$(curl --noproxy '*' -fsS --retry 5 --retry-delay 3 --retry-connrefused \
  --connect-timeout 10 --max-time 20 "$WEB_URL")"
case "$PAGE" in
  *DEVOPS_DIPLOMADO_OK*) ;;
  *) echo 'No se encontro la pagina esperada.' >&2; exit 1;;
esac
echo "HTTP y contenido comprobados desde el Mac: $WEB_URL"
