#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
TMP_DIR="$PROJECT_DIR/.claude/tmp"
mkdir -p "$TMP_DIR"
STATUS_FILE="$TMP_DIR/quality-gates.ok"
rm -f "$STATUS_FILE"

cd "$PROJECT_DIR"

npm run format
npm run lint
npm run typecheck
npm test

touch "$STATUS_FILE"
exit 0
