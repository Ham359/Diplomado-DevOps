#!/usr/bin/env bash
# Archivo interno, cargar desde los otros scripts con source.
export PATH="/opt/homebrew/bin:/usr/local/bin:$HOME/.local/bin:$PATH"
export AWS_DEFAULT_REGION="us-east-1"
export AWS_PAGER=""
export TF_IN_AUTOMATION=1
export TF_INPUT=0
export SSH_KEY_FILE="${SSH_KEY_FILE:-$HOME/.ssh/devops_diplomado_aws}"
export DEVOPS_STATE_DIR="${DEVOPS_STATE_DIR:-$HOME/devops-diplomado-estado/aws}"
if [ -n "${AWS_ACCESS_KEY_ID:-}" ]; then
  unset AWS_PROFILE
else
  export AWS_PROFILE="${AWS_PROFILE:-devops-lab}"
fi
if [ -z "${TF_VAR_ssh_public_key:-}" ] && [ -f "$HOME/.ssh/devops_diplomado_aws.pub" ]; then
  export TF_VAR_ssh_public_key
  TF_VAR_ssh_public_key="$(cat "$HOME/.ssh/devops_diplomado_aws.pub")"
fi

