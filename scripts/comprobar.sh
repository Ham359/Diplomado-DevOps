#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
source "$ROOT_DIR/scripts/env.sh"
for tool in terraform ansible-playbook ansible-inventory aws ssh curl git; do
  command -v "$tool" >/dev/null || { echo "Falta $tool en el PATH del agente." >&2; exit 1; }
done
if [ "$(uname -s)" != Darwin ]; then
  echo 'Este proyecto espera un agente NATIVO macOS. No ejecutar dentro del contenedor Jenkins.' >&2
  exit 1
fi
test -f "$SSH_KEY_FILE" || { echo 'No se encontro la clave SSH privada.' >&2; exit 1; }
test -n "${TF_VAR_ssh_public_key:-}" || { echo 'Falta TF_VAR_ssh_public_key.' >&2; exit 1; }
ACTUAL_PUBLIC_KEY="$(ssh-keygen -y -f "$SSH_KEY_FILE")"
if [ "$(printf '%s' "$ACTUAL_PUBLIC_KEY" | awk '{print $1" "$2}')" != \
     "$(printf '%s' "$TF_VAR_ssh_public_key" | awk '{print $1" "$2}')" ]; then
  echo 'La clave publica de Terraform no corresponde a la clave privada de Ansible.' >&2
  exit 1
fi
aws sts get-caller-identity --query Account --output text
terraform version
ansible-playbook --version | head -n 1
echo "Usuario agente: $(whoami) | HOME: $HOME"
echo "Estado: $DEVOPS_STATE_DIR/terraform.tfstate"
echo 'Herramientas, identidad AWS y pareja de claves comprobadas.'

