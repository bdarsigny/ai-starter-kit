#!/usr/bin/env bash
# Tests for the kit's hook scripts. Runs entirely in a scratch folder; never touches a real AI folder.
# Usage: bash tests/test_hooks.sh   (macOS bash 3.2, Linux, or Git Bash on Windows)

KIT="$(cd "$(dirname "$0")/.." && pwd)"
SCRATCH="$(mktemp -d 2>/dev/null || mktemp -d -t aikit)"
export AI_KIT_HOME="$SCRATCH/AI"
START="$KIT/hooks/session-start.sh"
MARK="$KIT/hooks/mark-wrapup.sh"
PASS=0; FAIL=0

check() { # name, haystack, needle, expect(present|absent)
  if printf '%s' "$2" | grep -q -- "$3"; then found=present; else found=absent; fi
  if [ "$found" = "$4" ]; then PASS=$((PASS+1)); echo "ok   - $1"; else FAIL=$((FAIL+1)); echo "FAIL - $1 (expected '$3' $4)"; printf '%s\n' "$2" | sed 's/^/       | /'; fi
}

mkdir -p "$AI_KIT_HOME/projects/demo"
cp "$KIT/templates/personal/PROGRESS.md" "$AI_KIT_HOME/PROGRESS.md"
cat > "$AI_KIT_HOME/projects/demo/PROGRESS.md" <<'EOF'
# Progress: demo

## Where things stand

Planning the first outing.

## Next steps

- Pick three towns

## Log

### 2026-11-20: Set up the project
- Made the folder

### 2026-11-19: Older entry
- Should not appear
EOF

# 1. Untracked folder (no PROGRESS.md): silent, exit 0.
mkdir -p "$SCRATCH/elsewhere"
out="$(CLAUDE_PROJECT_DIR="$SCRATCH/elsewhere" bash "$START")"; rc=$?
check "untracked folder prints nothing" "$out" "From PROGRESS" absent
[ $rc -eq 0 ] && { PASS=$((PASS+1)); echo "ok   - untracked folder exits 0"; } || { FAIL=$((FAIL+1)); echo "FAIL - untracked exit $rc"; }

# 2. First session in a project: shows progress and latest log entry only.
out="$(CLAUDE_PROJECT_DIR="$AI_KIT_HOME/projects/demo" bash "$START")"
check "shows where things stand" "$out" "Planning the first outing" present
check "shows latest log entry" "$out" "Set up the project" present
check "omits older log entries" "$out" "Should not appear" absent
check "no unwrapped flag on first session" "$out" "without a wrap-up" absent

# 3. Second session with no wrap-up in between: flagged.
out="$(CLAUDE_PROJECT_DIR="$AI_KIT_HOME/projects/demo" bash "$START")"
check "flags session that was not wrapped up" "$out" "without a wrap-up" present

# 4. Wrap-up recorded (with a trailing slash), then a new session: not flagged.
bash "$MARK" "$AI_KIT_HOME/projects/demo/" >/dev/null
out="$(CLAUDE_PROJECT_DIR="$AI_KIT_HOME/projects/demo" bash "$START")"
check "no flag after wrap-up" "$out" "without a wrap-up" absent

# 5. Folders are tracked separately: the AI home has its own history.
out="$(CLAUDE_PROJECT_DIR="$AI_KIT_HOME" bash "$START")"
check "AI home shows its own progress" "$out" "Just getting started" present
check "AI home not flagged by project history" "$out" "without a wrap-up" absent

# 6. Shared project with a working remote: pulls.
REMOTE="$SCRATCH/remote.git"
git init -q --bare "$REMOTE"
P="$AI_KIT_HOME/projects/shared"
git clone -q "$REMOTE" "$P" 2>/dev/null
cp "$AI_KIT_HOME/projects/demo/PROGRESS.md" "$P/PROGRESS.md"
git -C "$P" -c user.name=t -c user.email=t@t add -A
git -C "$P" -c user.name=t -c user.email=t@t commit -q -m init
git -C "$P" push -q origin HEAD 2>/dev/null
git -C "$P" branch -q --set-upstream-to="origin/$(git -C "$P" rev-parse --abbrev-ref HEAD)" 2>/dev/null
out="$(CLAUDE_PROJECT_DIR="$P" bash "$START")"
check "shared project pulls latest" "$out" "pulled the latest" present

check "no stale-note warning when nothing new" "$out" "note above is out of date" absent

# 6b. The other person pushed an update: the note says the summary above is out of date.
OTHER="$SCRATCH/other"
git clone -q "$REMOTE" "$OTHER" 2>/dev/null
echo "- partner update" >> "$OTHER/PROGRESS.md"
git -C "$OTHER" -c user.name=o -c user.email=o@o commit -qam "partner"
git -C "$OTHER" push -q 2>/dev/null
out="$(CLAUDE_PROJECT_DIR="$P" bash "$START")"
check "warns when the pull brought new updates" "$out" "note above is out of date" present

# 7. Shared project whose remote is unreachable: explains, still exits 0.
git -C "$P" remote set-url origin "$SCRATCH/missing.git"
out="$(CLAUDE_PROJECT_DIR="$P" bash "$START")"; rc=$?
check "unreachable remote explained" "$out" "could not get the latest" present
[ $rc -eq 0 ] && { PASS=$((PASS+1)); echo "ok   - unreachable remote exits 0"; } || { FAIL=$((FAIL+1)); echo "FAIL - unreachable exit $rc"; }

# 8. Folder path with spaces.
SP="$AI_KIT_HOME/projects/my garden"
mkdir -p "$SP"; cp "$AI_KIT_HOME/projects/demo/PROGRESS.md" "$SP/PROGRESS.md"
CLAUDE_PROJECT_DIR="$SP" bash "$START" >/dev/null
out="$(CLAUDE_PROJECT_DIR="$SP" bash "$START")"
check "path with spaces tracked" "$out" "without a wrap-up" present

# 9. Wrap-up recorded with a ~ path and with a relative path still matches the folder.
CLAUDE_PROJECT_DIR="$AI_KIT_HOME/projects/demo" bash "$START" >/dev/null
HOME="$SCRATCH" bash "$MARK" "~/AI/projects/demo" >/dev/null
out="$(CLAUDE_PROJECT_DIR="$AI_KIT_HOME/projects/demo" bash "$START")"
check "~ path in wrap-up matches" "$out" "without a wrap-up" absent
(cd "$AI_KIT_HOME/projects" && bash "$MARK" "demo" >/dev/null)
out="$(CLAUDE_PROJECT_DIR="$AI_KIT_HOME/projects/demo" bash "$START")"
check "relative path in wrap-up matches" "$out" "without a wrap-up" absent

# 10. Windows only: the app passes Windows-form paths (C:\Users\...), and the wrap-up may pass another
#     spelling (forward slashes, different letter case). They must all match the same folder.
if command -v cygpath >/dev/null 2>&1; then
  for F in "$AI_KIT_HOME/projects/demo" "$SP"; do
    WIN="$(cygpath -w "$F")"
    MIXED_UPPER="$(cygpath -m "$F" | tr '[:lower:]' '[:upper:]')"
    CLAUDE_PROJECT_DIR="$WIN" bash "$START" >/dev/null
    bash "$MARK" "$MIXED_UPPER" >/dev/null
    out="$(CLAUDE_PROJECT_DIR="$WIN" bash "$START")"
    check "Windows path forms match ($F)" "$out" "without a wrap-up" absent
  done
else
  echo "skip - Windows path forms (no cygpath here)"
fi

rm -rf "$SCRATCH"
echo ""
echo "$PASS passed, $FAIL failed"
[ $FAIL -eq 0 ]
