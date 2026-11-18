#!/usr/bin/env bash
# AI starter kit: SessionStart hook.
# Prints a short "where you left off" note for Claude (stdout becomes context at session start),
# flags a previous session in this folder that ended without a wrap-up, and pulls the latest
# changes for a shared project. Never blocks a session: every path exits 0.
# Portable on purpose: macOS bash 3.2 and Git Bash on Windows (no mapfile, no assoc arrays, no GNU-only flags).

AI_HOME="${AI_KIT_HOME:-$HOME/AI}"
DIR="${CLAUDE_PROJECT_DIR:-$PWD}"

# Windows: turn C:\Users\name\AI into /c/Users/name/AI so file tests work in Git Bash.
if command -v cygpath >/dev/null 2>&1; then
  DIR="$(cygpath -u "$DIR" 2>/dev/null || printf '%s' "$DIR")"
  AI_HOME="$(cygpath -u "$AI_HOME" 2>/dev/null || printf '%s' "$AI_HOME")"
fi

STATE_DIR="$AI_HOME/.state"
LOG="$STATE_DIR/sessions.log"
DIR="${DIR%/}"
# Normalize the folder so the same folder always matches: expand ~, resolve to a full path,
# and on Windows ignore letter case (Windows paths are not case-sensitive).
case "$DIR" in "~"*) DIR="$HOME${DIR#\~}" ;; esac
DIR="$(cd "$DIR" 2>/dev/null && pwd -P || printf '%s' "$DIR")"
if command -v cygpath >/dev/null 2>&1; then DIR="$(printf '%s' "$DIR" | tr '[:upper:]' '[:lower:]')"; fi
mkdir -p "$STATE_DIR" 2>/dev/null

# Only folders that keep a PROGRESS.md are "tracked": the AI home and each project.
[ -f "$DIR/PROGRESS.md" ] || exit 0

echo "[AI kit startup note for Claude: see the Start of session nudge in CLAUDE.md]"
echo "Folder: $DIR"

# 1. Was the last session in this folder wrapped up?
TAB="$(printf '\t')"
if [ -f "$LOG" ]; then
  last_type="$(D="$DIR" awk -F"$TAB" '$3==ENVIRON["D"] {t=$1} END {print t}' "$LOG" 2>/dev/null)"
  if [ "$last_type" = "start" ]; then
    echo "The last session in this folder ended without a wrap-up."
  fi
fi
printf 'start\t%s\t%s\n' "$(date +%s)" "$DIR" >> "$LOG" 2>/dev/null

# 2. Where things stand: the top of PROGRESS.md, up to the Log.
echo ""
echo "From PROGRESS.md:"
awk '/^## Log/ {exit} /^<!--/ {next} NF {print}' "$DIR/PROGRESS.md" 2>/dev/null | head -n 25

# 3. The most recent log entry, if there is one.
entry="$(awk '/^## Log/ {inlog=1; next} inlog && /^### / {n++} n==1 {print} n>1 {exit}' "$DIR/PROGRESS.md" 2>/dev/null | head -n 12)"
if [ -n "$entry" ]; then
  echo ""
  echo "Most recent log entry:"
  printf '%s\n' "$entry"
fi

echo ""
# 4. Shared project: get the latest changes before anyone starts working. Runs last, so a slow
#    network can never cost the progress note above.
if [ -d "$DIR/.git" ] && [ -n "$(git -C "$DIR" remote 2>/dev/null)" ]; then
  TO=""
  before="$(git -C "$DIR" rev-parse HEAD 2>/dev/null)"
  if timeout --version >/dev/null 2>&1; then TO="timeout 20"; fi  # GNU timeout only (not Windows timeout.exe)
  if GIT_TERMINAL_PROMPT=0 GCM_INTERACTIVE=never $TO git -C "$DIR" -c http.lowSpeedLimit=1000 -c http.lowSpeedTime=15 pull --ff-only -q >/dev/null 2>&1; then
    echo "Shared project: pulled the latest changes from GitHub."
    if [ "$(git -C "$DIR" rev-parse HEAD 2>/dev/null)" != "$before" ]; then
      echo "The pull brought in someone else's updates, so the note above is out of date: read PROGRESS.md before summarizing where things stand."
    fi
  else
    echo "Shared project: could not get the latest changes automatically (offline, or local changes in the way). The wrap-up will sort it out; mention it only if it matters for today's work."
  fi
fi

exit 0
