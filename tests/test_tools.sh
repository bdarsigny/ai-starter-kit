#!/usr/bin/env bash
# Tests for the kit's helper tools. Read-only: works on the fixture in tests/fixtures and a scratch folder.
# Usage: bash tests/test_tools.sh   (macOS bash 3.2, Linux, or Git Bash on Windows)

KIT="$(cd "$(dirname "$0")/.." && pwd)"
TOOL="$KIT/tools/docx-to-text.sh"
FIX="$KIT/tests/fixtures/sample-brief.docx"
SCRATCH="$(mktemp -d 2>/dev/null || mktemp -d -t aikit)"
PASS=0; FAIL=0

check() { # name, haystack, needle, expect(present|absent)
  if printf '%s' "$2" | grep -qF -- "$3"; then found=present; else found=absent; fi
  if [ "$found" = "$4" ]; then PASS=$((PASS+1)); echo "ok   - $1"; else FAIL=$((FAIL+1)); echo "FAIL - $1 (expected '$3' $4)"; printf '%s\n' "$2" | sed 's/^/       | /'; fi
}
rc_is() { # name, actual, expected
  if [ "$2" -eq "$3" ]; then PASS=$((PASS+1)); echo "ok   - $1"; else FAIL=$((FAIL+1)); echo "FAIL - $1 (exit $2, expected $3)"; fi
}

echo "perl: $(command -v perl)  unzip: $(command -v unzip || echo none)"

out="$(bash "$TOOL" "$FIX")"; rc=$?
rc_is "docx converts" $rc 0
check "heading text" "$out" "Sample garden plan" present
check "entities decoded" "$out" 'May & tomatoes that "actually" grow. Isn'"'"'t that' present
check "list item marked" "$out" "- Raised bed near the shed" present
check "angle brackets decoded" "$out" "- Compost bin <small>" present
check "no leftover tags" "$out" "<w:" absent
check "last paragraph" "$out" "Which seeds to start indoors." present

# Path with spaces, like "C:\Users\Patti\Downloads\Your Vermont 251 Project.docx"
mkdir -p "$SCRATCH/My Downloads"; cp "$FIX" "$SCRATCH/My Downloads/Project Brief.docx"
out="$(bash "$TOOL" "$SCRATCH/My Downloads/Project Brief.docx")"; rc=$?
rc_is "path with spaces" $rc 0
check "path with spaces text" "$out" "Sample garden plan" present

out="$(bash "$TOOL" "$SCRATCH/missing.docx" 2>&1)"; rc=$?
rc_is "missing file exits 1" $rc 1
check "missing file message" "$out" "file not found" present

printf 'just text\n' > "$SCRATCH/notes.docx"
out="$(bash "$TOOL" "$SCRATCH/notes.docx" 2>&1)"; rc=$?
rc_is "non-Word file exits 2" $rc 2
check "non-Word file message" "$out" "docx-to-text:" present

rm -rf "$SCRATCH"
echo "$PASS passed, $FAIL failed"
[ $FAIL -eq 0 ]
