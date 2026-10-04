#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
source "$ROOT_DIR/scripts/env.sh"
test -f "$ROOT_DIR/ansible/hosts.ini" || { echo 'Falta el inventario: ejecutar Terraform apply primero.' >&2; exit 1; }
test -f "$SSH_KEY_FILE"
cd "$ROOT_DIR/ansible"
ansible-playbook -i hosts.ini --private-key "$SSH_KEY_FILE" playbook.yml

