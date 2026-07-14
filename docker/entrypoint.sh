#!/usr/bin/env bash
set -uo pipefail

cffpath="${1:-${INPUT_CFFPATH:-CITATION.cff}}"

set +e
Rscript /app/validate_cff.R -p "$cffpath"
r_status=$?
set -e

if test -f "citation_cff.md" && test -n "${GITHUB_STEP_SUMMARY:-}"; then
  cat citation_cff.md >"$GITHUB_STEP_SUMMARY"
fi

if test -f "issue.md"; then
  echo "::error:: CFF file has errors, see Job Summary"
  exit 1
fi

exit "$r_status"
