#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
source "$ROOT_DIR/scripts/env.sh"
umask 077
mkdir -p "$HOME/.ssh" "$DEVOPS_STATE_DIR"
if [ ! -f "$HOME/.ssh/devops_diplomado_aws" ]; then
  ssh-keygen -t rsa -b 4096 -N '' -C devops-diplomado -f "$HOME/.ssh/devops_diplomado_aws"
fi
test -f "$HOME/.ssh/devops_diplomado_aws.pub"
chmod 600 "$HOME/.ssh/devops_diplomado_aws"
PUBLIC_IPV4="$(curl -4 -fsS --connect-timeout 10 --max-time 20 https://checkip.amazonaws.com | tr -d '\r\n ')"
if ! [[ "$PUBLIC_IPV4" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
  echo 'No se obtuvo una IPv4 publica valida. Revisa tu conexion.' >&2
  exit 1
fi
if [ -f "$ROOT_DIR/terraform/terraform.tfvars" ]; then
  cp "$ROOT_DIR/terraform/terraform.tfvars" "$ROOT_DIR/terraform/terraform.tfvars.backup"
fi
cat > "$ROOT_DIR/terraform/terraform.tfvars" <<EOF
aws_region    = "us-east-1"
project_name  = "devops-diplomado"
instance_type = "t3.micro"
admin_cidr    = "$PUBLIC_IPV4/32"
EOF
echo "Configuracion local lista. IP autorizada: $PUBLIC_IPV4/32"
echo "Estado persistente: $DEVOPS_STATE_DIR/terraform.tfstate"
echo 'Este script NO crea recursos AWS. Comprueba Free Plan y creditos antes de apply.'

