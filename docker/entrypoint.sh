#!/usr/bin/env bash
set -euo pipefail

cffpath="${1:-${INPUT_CFFPATH:-CITATION.cff}}"

Rscript /app/validate_cff.R -p "$cffpath"

if test -f "citation_cff.md" && test -n "${GITHUB_STEP_SUMMARY:-}"; then
  cat citation_cff.md >"$GITHUB_STEP_SUMMARY"
fi

if test -f "issue.md"; then
  echo "::error:: CFF file has errors, see Job Summary"
  exit 1
fi
