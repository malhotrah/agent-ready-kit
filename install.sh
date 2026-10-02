#!/usr/bin/env bash
# Installs the /agent-ready Claude Code skill for the current user (macOS / Linux / Git Bash).
#
#   bash install.sh             install (asks before replacing)
#   bash install.sh --force     install, replacing without asking
#   bash install.sh --uninstall remove
set -euo pipefail

SKILL_NAME="agent-ready"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE="$SCRIPT_DIR/skills/$SKILL_NAME"
CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
TARGET="$CLAUDE_DIR/skills/$SKILL_NAME"

FORCE=0
UNINSTALL=0
for arg in "$@"; do
  case "$arg" in
    --force|-f) FORCE=1 ;;
    --uninstall) UNINSTALL=1 ;;
    -h|--help) sed -n '2,7p' "$0"; exit 0 ;;
    *) echo "Unknown option: $arg" >&2; exit 2 ;;
  esac
done

if [ "$UNINSTALL" -eq 1 ]; then
  if [ -d "$TARGET" ]; then rm -rf "$TARGET"; echo "Removed $TARGET"; else echo "Nothing to remove: $TARGET does not exist."; fi
  exit 0
fi

if [ ! -f "$SOURCE/SKILL.md" ]; then
  echo "Can't find $SOURCE/SKILL.md. Run this script from the agent-ready-kit folder." >&2
  exit 1
fi

command -v claude >/dev/null 2>&1 || echo "WARNING: 'claude' is not on PATH. Install Claude Code first: https://docs.claude.com/en/docs/claude-code" >&2
command -v node   >/dev/null 2>&1 || echo "WARNING: 'node' is not on PATH. The generated hooks are Node scripts. /agent-ready will offer to skip them." >&2

if [ -d "$TARGET" ]; then
  if [ "$FORCE" -ne 1 ]; then
    read -r -p "$TARGET already exists. Replace it with this version? [y/N] " answer
    case "$answer" in y|Y|yes|YES) ;; *) echo "Cancelled. Nothing changed."; exit 1 ;; esac
  fi
  rm -rf "$TARGET"
fi

mkdir -p "$(dirname "$TARGET")"
cp -R "$SOURCE" "$TARGET"

cat <<EOF

Installed /$SKILL_NAME to $TARGET

Next:
  1. Open Claude Code in the repo you want to prepare:   cd <your-repo> && claude
  2. Run:   /$SKILL_NAME          (or '/$SKILL_NAME audit' to only report gaps)
EOF
