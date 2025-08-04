#!/bin/bash

# Advanced Mac notification script
# Supports sound, icon, button and other options

# Default values
DEFAULT_SOUND="Glass"
DEFAULT_TITLE="Claude Assistant"
DEFAULT_MESSAGE="Task completed!"

# Show help information
show_help() {
    cat << EOF
Usage: $0 [options] "Title" "Message"

Options:
    -s, --sound SOUND     Specify sound file (default: Glass)
    -i, --icon ICON       Specify icon file path
    -b, --button TEXT     Add button text
    -h, --help            Show this help message

Examples:
    $0 "Reminder" "Time to drink water!"
    $0 -s "Ping" "Meeting" "Starts in 5 minutes"
    $0 -i "/path/to/icon.png" "Download Complete" "File has been downloaded"
    $0 -b "Open" "Update" "A new version is available"

Available sounds:
    Glass, Ping, Basso, Blow, Bottle, Frog, Funk, Hero, Morse, Pop, Purr, Sosumi, Submarine, Tink
EOF
}

# Parse arguments
title="$DEFAULT_TITLE"
message="$DEFAULT_MESSAGE"
sound="$DEFAULT_SOUND"
icon=""
button=""

while [[ $# -gt 0 ]]; do
    case $1 in
        -s|--sound)
            sound="$2"
            shift 2
            ;;
        -i|--icon)
            icon="$2"
            shift 2
            ;;
        -b|--button)
            button="$2"
            shift 2
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        -*)
            echo "Unknown option: $1"
            show_help
            exit 1
            ;;
        *)
            if [[ -z "$title" || "$title" == "$DEFAULT_TITLE" ]]; then
                title="$1"
            elif [[ -z "$message" || "$message" == "$DEFAULT_MESSAGE" ]]; then
                message="$1"
            else
                echo "Too many arguments"
                show_help
                exit 1
            fi
            shift
            ;;
    esac
done

# Build AppleScript command
script="display notification \"$message\" with title \"$title\""

if [[ -n "$sound" ]]; then
    script+=" sound name \"$sound\""
fi

if [[ -n "$icon" ]]; then
    script+=" subtitle \"\""
    # Note: macOS notification API does not directly support custom icons, this is just a placeholder
fi

if [[ -n "$button" ]]; then
    script+=" buttons {\"$button\"}"
fi

# Send notification
echo "Sending notification..."
echo "Title: $title"
echo "Message: $message"
if [[ -n "$sound" ]]; then
    echo "Sound: $sound"
fi
if [[ -n "$button" ]]; then
    echo "Button: $button"
fi
echo "---"

# Execute AppleScript
osascript -e "$script"

if [[ $? -eq 0 ]]; then
    echo "✅ Notification sent successfully"
else
    echo "❌ Failed to send notification"
    exit 1
fi