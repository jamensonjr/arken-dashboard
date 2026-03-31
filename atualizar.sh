#!/bin/bash
# ARKEN — Atualização automática do dashboard
# Chamado pelo launchd diariamente

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
LOG="$SCRIPT_DIR/update.log"
PYTHON=$(which python3)

echo "[$(date '+%Y-%m-%d %H:%M')] Iniciando atualização..." >> "$LOG"

# 1. Exportar dados da planilha para JSON
cd "$SCRIPT_DIR"
$PYTHON exportar_dados.py >> "$LOG" 2>&1

# 2. Commit e push para o GitHub
if git diff --quiet data.json; then
  echo "[$(date '+%Y-%m-%d %H:%M')] Sem alterações nos dados — push ignorado." >> "$LOG"
else
  git add data.json
  git commit -m "auto: atualização diária $(date '+%d/%m/%Y %H:%M')"
  git push origin main >> "$LOG" 2>&1
  echo "[$(date '+%Y-%m-%d %H:%M')] ✅ Dashboard atualizado no GitHub Pages." >> "$LOG"
fi

echo "---" >> "$LOG"
