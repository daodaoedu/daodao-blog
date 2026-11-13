#!/usr/bin/env bash
set -euo pipefail

codeql_root=${1:-.}
codeql_revision=${2:-HEAD}
codeql_inventory=${3:-}
codeql_commit=$(git -C "$codeql_root" rev-parse --verify --end-of-options "${codeql_revision}^{commit}")
codeql_tree=$(git -C "$codeql_root" rev-parse --verify "${codeql_commit}^{tree}")
codeql_entries=$(mktemp)
trap 'rm -f "$codeql_entries"' EXIT
git -C "$codeql_root" ls-tree -r -z --full-tree "$codeql_tree" > "$codeql_entries"

codeql_js=0
codeql_actions=0
while IFS= read -r -d '' codeql_entry; do
  codeql_mode=${codeql_entry%% *}
  case "$codeql_mode" in 100644|100755) ;; *) continue ;; esac
  codeql_path=${codeql_entry#*$'\t'}
  case "$codeql_path" in
    *.js|*.jsx|*.ts|*.tsx|*.mjs|*.cjs|*.mts|*.cts) codeql_js=$((codeql_js + 1)) ;;
  esac
  case "$codeql_path" in
    .github/workflows/*.yml|.github/workflows/*.yaml)
      codeql_workflow=${codeql_path#.github/workflows/}
      if [[ "$codeql_workflow" != */* ]]; then codeql_actions=$((codeql_actions + 1)); fi
      ;;
  esac
done < "$codeql_entries"

codeql_languages=''
if (( codeql_actions > 0 )); then codeql_languages='"actions"'; fi
if (( codeql_js > 0 )); then
  if [[ -n "$codeql_languages" ]]; then codeql_languages+=','; fi
  codeql_languages+='"javascript-typescript"'
fi
codeql_languages="[$codeql_languages]"
codeql_matrix="{\"language\":$codeql_languages}"
if [[ -n "$codeql_inventory" ]]; then
  mkdir -p -- "$codeql_inventory"
  cp -- "$codeql_entries" "$codeql_inventory/tracked-tree.nul"
  printf '{"commit":"%s","tree":"%s","javascriptTypeScriptFiles":%d,"workflowFiles":%d,"languages":%s}\n' \
    "$codeql_commit" "$codeql_tree" "$codeql_js" "$codeql_actions" "$codeql_languages" > "$codeql_inventory/selection.json"
fi
if [[ -n "${GITHUB_OUTPUT:-}" ]]; then
  printf 'matrix=%s\nlanguages=%s\n' "$codeql_matrix" "$codeql_languages" >> "$GITHUB_OUTPUT"
fi
printf '%s\n' "$codeql_matrix"
