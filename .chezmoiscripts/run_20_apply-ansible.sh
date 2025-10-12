#!/usr/bin/env bash
set -euo pipefail

PLAYBOOK="$HOME/.local/share/chezmoi/ansible/playbook.yml"

# --- オプション（環境変数） ---
# CHEZMOI_SKIP_ANSIBLE=1  → 何も聞かずにスキップ
# CHEZMOI_ASSUME_YES=1    → 何も聞かずに実行（CI等）
# -----------------------------

# 1) スキップ指定なら抜ける
if [ "${CHEZMOI_SKIP_ANSIBLE:-}" = "1" ]; then
  echo "[run] skip ansible by CHEZMOI_SKIP_ANSIBLE=1"
  exit 0
fi

# 2) playbook が無ければ何もしない
[ -f "$PLAYBOOK" ] || exit 0

# 3) 実行確認（TTYが無い or 自動Yesならそのまま進む）
confirm() {
  if [ "${CHEZMOI_ASSUME_YES:-}" = "1" ] || [ ! -t 0 ]; then
    return 0
  fi
  local ans
  while true; do
    read -r -p "Run Ansible now? [Y/n]: " ans || ans=""
    case "${ans:-Y}" in
      Y|y) return 0 ;;
      N|n) return 1 ;;
      *)   echo "Please answer Y or n." ;;
    esac
  done
}

if ! confirm; then
  echo "[run] user chose not to run Ansible"
  exit 0
fi

# 4) ansible 実行（ローカル・SSHなし）
ansible-playbook -i localhost, -c local "$PLAYBOOK" -K
