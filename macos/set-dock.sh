#!/bin/sh
# Reset Dock and set apps: Finder, dia, Safari, Messages, Music, Vesktop, Slack, Spark, LINE.
# Run after brew bundle (dockutil must be installed). Requires logout/restart to take effect if Dock was not running.

if ! command -v dockutil >/dev/null 2>&1; then
  echo "› dockutil not found, skipping Dock setup (run: brew bundle)"
  exit 0
fi

echo "› Resetting Dock..."
dockutil --remove all --no-restart 2>/dev/null || true

# Add in order (skip if app not installed). Finder is always in Dock.
for app in \
  "/Applications/Dia.app" \
  "/Applications/Safari.app" \
  "/Applications/Messages.app" \
  "/Applications/Music.app" \
  "/Applications/Vesktop.app" \
  "/Applications/Slack.app" \
  "/Applications/Spark.app" \
  "/Applications/LINE.app"
do
  if [ -d "$app" ]; then
    dockutil --add "$app" --no-restart 2>/dev/null || true
  fi
done

killall Dock 2>/dev/null || true
echo "› Dock set."
