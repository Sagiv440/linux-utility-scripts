#!/bin/bash

# Usage:
#   ./install_app.sh <source_file_or_folder> <app_name> [-f] [-d]
#
# Examples:
#   ./install_app.sh ~/Downloads/Etcher.AppImage etcher
#   ./install_app.sh ~/Downloads/balenaEtcher-linux-x64 balena-etcher -f -d
#
# Flags:
#   -f  Force reinstall (delete old files before installing)
#   -d  Copy the entire folder (include dependencies)

set -e  # Stop on any error

INSTALL_APP=$1
APP_NAME=$2
FLAG1=$3
FLAG2=$4
TARGET_DIR="/opt/$APP_NAME"
LINK_PATH="/usr/local/bin/$APP_NAME"

# 🧱 Validate input
if [ -z "$INSTALL_APP" ] || [ -z "$APP_NAME" ]; then
  echo "❌ Usage: $0 <source_file_or_folder> <app_name> [-f] [-d]"
  exit 1
fi

# 🧩 Detect flags (order-independent)
FORCE=false
COPY_DEPS=false
for arg in "$FLAG1" "$FLAG2"; do
  case "$arg" in
    -f) FORCE=true ;;
    -d) COPY_DEPS=true ;;
  esac
done

INSTALL_PATH="$(realpath "$INSTALL_APP")"
INSTALL_DIR="$(dirname "$INSTALL_PATH")"

# 🚮 Handle force reinstall
if $FORCE; then
  if [ -d "$TARGET_DIR" ]; then
    echo "⚠️  Removing old directory: $TARGET_DIR"
    sudo rm -rf "$TARGET_DIR"
  fi
  if [ -L "$LINK_PATH" ]; then
    echo "⚠️  Removing old symlink: $LINK_PATH"
    sudo rm -f "$LINK_PATH"
  fi
fi

# 📁 Create target directory
echo "📁 Creating directory: $TARGET_DIR"
sudo mkdir -p "$TARGET_DIR"

# 🧩 Install logic
if [ -f "$INSTALL_PATH" ] && ! $COPY_DEPS; then
  # Single-file app
  echo "📦 Copying single file: $INSTALL_PATH → $TARGET_DIR"
  sudo cp "$INSTALL_PATH" "$TARGET_DIR/"
else
  # Full folder (dependencies included)
  echo "📦 Copying entire folder: $INSTALL_DIR → $TARGET_DIR"
  sudo cp -r "$INSTALL_DIR"/* "$TARGET_DIR/"
fi

# 🧱 Ensure executable permission
if [ -f "$TARGET_DIR/$APP_NAME" ]; then
  sudo chmod +x "$TARGET_DIR/$APP_NAME"
fi

# 🔗 Create symlink
EXEC_FILE="$TARGET_DIR/$APP_NAME"

# If the exact executable doesn't exist, try to find one automatically
if [ ! -f "$EXEC_FILE" ]; then
  EXEC_FILE=$(find "$TARGET_DIR" -maxdepth 1 -type f -executable | head -n 1)
fi

if [ -n "$EXEC_FILE" ]; then
  echo "🔗 Creating symlink: $LINK_PATH → $EXEC_FILE"
  sudo ln -sf "$EXEC_FILE" "$LINK_PATH"
else
  echo "⚠️  No executable file found — symlink skipped."
fi

echo "✅ $APP_NAME installed successfully!"

