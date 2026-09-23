#!/usr/bin/env bash
# Portable kanata installer: binary + permissions + config + systemd service.
# Run from anywhere as long as kanata.kbd and kanata.service sit next to this script
# (e.g. inside your dotfiles repo, or in ~/.config/kanata).
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> kanata binary"
mkdir -p "$HOME/.local/bin"
if [ ! -x "$HOME/.local/bin/kanata" ]; then
  TMP="$(mktemp -d)"
  curl -sL "https://github.com/jtroo/kanata/releases/latest/download/linux-binaries-x64.zip" -o "$TMP/kanata.zip"
  unzip -o "$TMP/kanata.zip" -d "$TMP"
  # NOTE: first-run-on-a-new-machine caveat — the exact binary name inside this zip
  # hasn't been verified against a live download. If this find comes up empty,
  # run `unzip -l "$TMP/kanata.zip"` and fix the -iname pattern below.
  BIN="$(find "$TMP" -maxdepth 2 -type f -iname 'kanata*' ! -iname '*.zip' | head -n1)"
  if [ -z "$BIN" ]; then
    echo "Could not find the kanata binary inside the downloaded zip. Contents:"
    find "$TMP" -maxdepth 2
    exit 1
  fi
  cp "$BIN" "$HOME/.local/bin/kanata"
  chmod +x "$HOME/.local/bin/kanata"
  rm -rf "$TMP"
else
  echo "already present, skipping download"
fi

echo "==> input/uinput permissions (sudo, idempotent)"
sudo groupadd -f uinput
sudo usermod -aG input,uinput "$USER"
echo 'KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"' | sudo tee /etc/udev/rules.d/99-kanata.rules >/dev/null
sudo udevadm control --reload-rules
sudo udevadm trigger
sudo modprobe uinput
echo uinput | sudo tee /etc/modules-load.d/uinput.conf >/dev/null

echo "==> config"
mkdir -p "$HOME/.config/kanata"
if [ "$DIR/kanata.kbd" -ef "$HOME/.config/kanata/kanata.kbd" ]; then
  echo "already the installed copy, skipping"
else
  cp "$DIR/kanata.kbd" "$HOME/.config/kanata/kanata.kbd"
fi

echo "==> systemd user service"
mkdir -p "$HOME/.config/systemd/user"
cp "$DIR/kanata.service" "$HOME/.config/systemd/user/kanata.service"
systemctl --user daemon-reload
systemctl --user enable --now kanata.service

echo "==> Done. If you were just added to input/uinput groups for the first time, log out and back in."
