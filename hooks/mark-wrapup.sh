#!/usr/bin/env bash
# AI starter kit: record that a session in this folder was wrapped up.
# Called by the wrap-up skill as its last step: bash "$HOME/.claude/hooks/ai-kit/mark-wrapup.sh" "<folder>"
# The session-start hook reads the same log to notice sessions that ended without a wrap-up.

AI_HOME="${AI_KIT_HOME:-$HOME/AI}"
DIR="${1:-${CLAUDE_PROJECT_DIR:-$PWD}}"

if command -v cygpath >/dev/null 2>&1; then
  DIR="$(cygpath -u "$DIR" 2>/dev/null || printf '%s' "$DIR")"
  AI_HOME="$(cygpath -u "$AI_HOME" 2>/dev/null || printf '%s' "$AI_HOME")"
fi

DIR="${DIR%/}"
# Normalize the folder so the same folder always matches: expand ~, resolve to a full path,
# and on Windows ignore letter case (Windows paths are not case-sensitive).
case "$DIR" in "~"*) DIR="$HOME${DIR#\~}" ;; esac
DIR="$(cd "$DIR" 2>/dev/null && pwd -P || printf '%s' "$DIR")"
if command -v cygpath >/dev/null 2>&1; then DIR="$(printf '%s' "$DIR" | tr '[:upper:]' '[:lower:]')"; fi
mkdir -p "$AI_HOME/.state" 2>/dev/null
printf 'wrapup\t%s\t%s\n' "$(date +%s)" "$DIR" >> "$AI_HOME/.state/sessions.log" && echo "Wrap-up recorded for $DIR"
exit 0
