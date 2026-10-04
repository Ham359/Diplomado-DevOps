#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
source "$ROOT_DIR/scripts/env.sh"
umask 077
mkdir -p "$DEVOPS_STATE_DIR"
chmod 700 "$DEVOPS_STATE_DIR"
if [ "${1:-}" = init ]; then
  shift
  exec terraform -chdir="$ROOT_DIR/terraform" init -input=false -reconfigure \
    "-backend-config=path=$DEVOPS_STATE_DIR/terraform.tfstate" "$@"
fi
exec terraform -chdir="$ROOT_DIR/terraform" "$@"

