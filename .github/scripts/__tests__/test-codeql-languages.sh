#!/usr/bin/env bash
set -euo pipefail
codeql_script=$(cd "$(dirname "$0")/.." && pwd)/codeql-languages.sh
codeql_fixture=$(mktemp -d)
trap 'rm -rf "$codeql_fixture"' EXIT
codeql_git() { git -C "$codeql_fixture" -c core.hooksPath=/dev/null "$@"; }
codeql_expect_languages() {
  python3 - "$1" "$2" <<'PYTEST'
import json, sys
actual = json.loads(sys.argv[1])
expected = json.loads(sys.argv[2])
assert set(actual) == {"language"}
assert set(actual["language"]) == set(expected), (actual, expected)
assert len(actual["language"]) == len(expected), (actual, expected)
PYTEST
}
codeql_commit() {
  codeql_git add .
  codeql_git -c user.name='CI Test' -c user.email='ci@example.invalid' -c commit.gpgsign=false commit -qm "$1"
}
codeql_git init -q
mkdir -p "$codeql_fixture/.github/workflows/nested" "$codeql_fixture/articles/en"
printf '# Article\n' > "$codeql_fixture/articles/en/guide.md"
codeql_commit 'Markdown only'
codeql_expect_languages "$(env -u GITHUB_OUTPUT bash "$codeql_script" "$codeql_fixture" HEAD)" '[]'
printf 'name: Inactive nested YAML\n' > "$codeql_fixture/.github/workflows/nested/ignored.yml"
codeql_commit 'Nested YAML is not a GitHub workflow'
codeql_expect_languages "$(env -u GITHUB_OUTPUT bash "$codeql_script" "$codeql_fixture" HEAD)" '[]'
printf 'name: Fixture\n' > "$codeql_fixture/.github/workflows/content.yml"
codeql_commit 'data-only'
codeql_data=$(codeql_git rev-parse HEAD)
codeql_actual=$(env -u GITHUB_OUTPUT bash "$codeql_script" "$codeql_fixture" HEAD "$codeql_fixture/inventory")
codeql_expect_languages "$codeql_actual" '["actions"]'
python3 - "$codeql_fixture/inventory/selection.json" <<'PY'
import json, sys
v = json.load(open(sys.argv[1]))
assert v['javascriptTypeScriptFiles'] == 0
assert v['workflowFiles'] == 1
PY
rm -rf "$codeql_fixture/inventory"
printf 'export const value = 1;\n' > "$codeql_fixture/main.ts"
printf 'console.log("hello");\n' > "$codeql_fixture/line
break.js"
ln -s /outside/private.js "$codeql_fixture/linked.js"
codeql_commit 'real JavaScript and TypeScript'
codeql_actual=$(env -u GITHUB_OUTPUT bash "$codeql_script" "$codeql_fixture" HEAD "$codeql_fixture/inventory")
codeql_expect_languages "$codeql_actual" '["actions","javascript-typescript"]'
python3 - "$codeql_fixture/inventory/selection.json" <<'PY'
import json, sys
v = json.load(open(sys.argv[1]))
assert v['javascriptTypeScriptFiles'] == 2, v
assert v['workflowFiles'] == 1
PY
codeql_expect_languages "$(env -u GITHUB_OUTPUT bash "$codeql_script" "$codeql_fixture" "$codeql_data")" '["actions"]'
codeql_output="$codeql_fixture/output"
GITHUB_OUTPUT="$codeql_output" bash "$codeql_script" "$codeql_fixture" HEAD >/dev/null
python3 - "$codeql_output" <<'PYTEST'
import json, sys
values = dict(line.strip().split("=", 1) for line in open(sys.argv[1]))
assert set(json.loads(values["matrix"])["language"]) == {"actions", "javascript-typescript"}
assert set(json.loads(values["languages"])) == {"actions", "javascript-typescript"}
PYTEST
if bash "$codeql_script" "$codeql_fixture" --upload-pack=sh >/dev/null 2>&1; then
  echo 'Invalid revision unexpectedly accepted' >&2
  exit 1
fi
printf 'PASS: data-only Actions, real JS/TS, immutable revision, symlink exclusion, newline path and output contract\n'
