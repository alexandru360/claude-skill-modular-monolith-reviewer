#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
STATUS_FILE="$PROJECT_DIR/.claude/tmp/quality-gates.ok"

if [[ ! -f "$STATUS_FILE" ]]; then
  echo "Blocked: quality gates have not produced a passing marker in this session" >&2
  exit 2
fi

exit 0
