#!/bin/bash

# Usage:
#   ./uninstall_app.sh <app_name> [-f]
#
# Example:
#   ./uninstall_app.sh balena-etcher
#   ./uninstall_app.sh etcher -f
#
# Removes:
#   - /opt/<app_name>  (folder or single file)
#   - /usr/local/bin/<app_name>  (symlink)
#
# The -f flag skips confirmation.

set -e  # Stop on any error

APP_NAME=$1
FLAG=$2
TARGET_DIR="/opt/$APP_NAME"
LINK_PATH="/usr/local/bin/$APP_NAME"

# 🧱 Validate input
if [ -z "$APP_NAME" ]; then
  echo "❌ Usage: $0 <app_name> [-f]"
  exit 1
fi

# 🚩 Detect force flag
FORCE=false
if [ "$FLAG" == "-f" ]; then
  FORCE=true
fi

# 🧾 Ask for confirmation (unless -f)
if ! $FORCE; then
  read -p "⚠️  Are you sure you want to uninstall '$APP_NAME'? [y/N]: " confirm
  if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "🛑 Uninstallation cancelled."
    exit 0
  fi
fi

echo "🚮 Uninstalling '$APP_NAME'..."

# 🗑️ Remove directory or single file under /opt
if [ -d "$TARGET_DIR" ]; then
  echo "🗑️  Removing directory: $TARGET_DIR"
  sudo rm -rf "$TARGET_DIR"
elif [ -f "$TARGET_DIR" ]; then
  echo "🗑️  Removing file: $TARGET_DIR"
  sudo rm -f "$TARGET_DIR"
else
  echo "ℹ️  Nothing found at $TARGET_DIR"
fi

# 🗑️ Remove symlink
if [ -L "$LINK_PATH" ]; then
  echo "🗑️  Removing symlink: $LINK_PATH"
  sudo rm -f "$LINK_PATH"
else
  echo "ℹ️  No symlink found at $LINK_PATH"
fi

echo "✅ '$APP_NAME' has been completely uninstalled!"

