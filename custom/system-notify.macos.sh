#!/bin/bash

# macOS System Notification Example
# This script shows visual notifications using macOS native notification system

# Get parameters
EVENT_TYPE="${1:-notification}"
TITLE="${2:-Claude Code}"
MESSAGE="${3:-Task completed}"

# Different notifications for different events
case "$EVENT_TYPE" in
    "notification")
        osascript -e "display notification \"$MESSAGE\" with title \"$TITLE\" sound name \"Glass\""
        ;;
    "stop")
        osascript -e "display notification \"$MESSAGE\" with title \"$TITLE\" sound name \"Tink\""
        ;;
    *)
        osascript -e "display notification \"$MESSAGE\" with title \"$TITLE\""
        ;;
esac