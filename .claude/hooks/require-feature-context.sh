#!/usr/bin/env bash
set -euo pipefail

INPUT="$(cat)"
TRANSCRIPT_PATH="$(printf '%s' "$INPUT" | jq -r '.transcript_path // empty')"

if [[ -z "${TRANSCRIPT_PATH:-}" || ! -f "$TRANSCRIPT_PATH" ]]; then
  echo "Missing transcript path; cannot verify feature context" >&2
  exit 2
fi

if ! grep -Eiq 'feature-id|bug-id|debt-id' "$TRANSCRIPT_PATH"; then
  echo "Blocked: missing feature-id, bug-id, or debt-id in session context" >&2
  exit 2
fi

exit 0
