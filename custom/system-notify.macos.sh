#!/bin/bash

# macOS System Notification for Claude Code
# Enhanced desktop notifications with project context and status visualization
# Following "experienced simplicity" principle
# Usage: ./system-notify.macos.sh <event_type> [project_name]

# Configuration
APP_NAME="Claude Code"

# Get event type and project name
EVENT_TYPE="${1:-test}"
PROJECT_NAME="${2:-${CLAUDE_PROJECT_NAME:-$(basename "$PWD")}}"

# Function to get current time in readable format
get_time() {
    date "+%-I:%M %p"
}

# Function to check and potentially install terminal-notifier
check_terminal_notifier() {
    if command -v terminal-notifier &> /dev/null; then
        return 0
    fi
    
    # Check if we've already asked about installation
    if [ -f ~/.claude/.notifier-install-declined ]; then
        return 1
    fi
    
    # Interactive prompt for installation
    if [ -t 0 ] && [ -t 1 ]; then  # Check if running interactively
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "📱 Desktop Notification Setup"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
        echo "Desktop notifications require terminal-notifier on macOS Sequoia."
        echo "Without it, notifications may not appear due to a known system issue."
        echo ""
        echo "Would you like to install terminal-notifier now?"
        echo "(This is a one-time setup)"
        echo ""
        read -p "Install terminal-notifier? [Y/n] (recommended): " -n 1 -r
        echo ""
        
        if [[ $REPLY =~ ^[Nn]$ ]]; then
            echo ""
            echo "⚠️  You chose not to install terminal-notifier."
            echo "   Falling back to osascript (may not work on macOS Sequoia)."
            echo "   To install later: brew install terminal-notifier"
            echo ""
            mkdir -p ~/.claude
            touch ~/.claude/.notifier-install-declined
            return 1
        else
            # User agreed or pressed Enter (default Yes)
            echo ""
            echo "Installing terminal-notifier..."
            if command -v brew &> /dev/null; then
                if brew install terminal-notifier; then
                    echo "✅ terminal-notifier installed successfully!"
                    return 0
                else
                    echo "❌ Installation failed. Falling back to osascript."
                    return 1
                fi
            else
                echo "❌ Homebrew not found. Please install Homebrew first:"
                echo "   /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
                echo ""
                echo "Then install terminal-notifier:"
                echo "   brew install terminal-notifier"
                return 1
            fi
        fi
    else
        # Non-interactive mode - just show a message once
        if [ ! -f ~/.claude/.notifier-tip-shown ]; then
            echo "💡 Tip: Install terminal-notifier for reliable notifications on macOS Sequoia:"
            echo "   brew install terminal-notifier"
            echo ""
            mkdir -p ~/.claude
            touch ~/.claude/.notifier-tip-shown
        fi
        return 1
    fi
}

# Function to send notification (terminal-notifier preferred, osascript fallback)
send_notification() {
    local title="$1"
    local subtitle="$2"
    local message="$3"
    local sound="${4:-}"
    
    if check_terminal_notifier; then
        # Use terminal-notifier (reliable on all macOS versions)
        terminal-notifier \
            -title "$title" \
            -subtitle "$subtitle" \
            -message "$message" \
            ${sound:+-sound "$sound"} \
            -group "claude-code-$PROJECT_NAME" \
            2>/dev/null
        return $?
    else
        # Fallback to osascript (known issues in macOS Sequoia)
        # Try with subtitle first
        if osascript -e "display notification \"$message\" with title \"$title\" subtitle \"$subtitle\"${sound:+ sound name \"$sound\"}" 2>/dev/null; then
            return 0
        fi
        
        # Try without subtitle for older macOS
        if osascript -e "display notification \"$subtitle: $message\" with title \"$title\"${sound:+ sound name \"$sound\"}" 2>/dev/null; then
            return 0
        fi
        
        # If both fail, it's likely the Sequoia bug
        # Only show this message once per session
        if [ -z "$SEQUOIA_WARNING_SHOWN" ]; then
            echo "⚠️  Notifications may not appear due to macOS Sequoia limitations."
            echo "   See: https://github.com/dongzhenye/claude-code-notifications/issues/5"
            export SEQUOIA_WARNING_SHOWN=1
        fi
        return 1
    fi
}

# Send notification based on event type
case "$EVENT_TYPE" in
    notification|input)
        # When Claude needs user input
        send_notification \
            "$APP_NAME 🔔" \
            "Input Required - $PROJECT_NAME" \
            "Claude needs your input to continue"
        ;;
        
    stop|complete|done)
        # When Claude completes a task
        TIME=$(get_time)
        send_notification \
            "$APP_NAME ✅" \
            "Task Complete - $PROJECT_NAME" \
            "Completed at $TIME"
        ;;
        
    error|failed)
        # When an error occurs
        send_notification \
            "$APP_NAME ❌" \
            "Error - $PROJECT_NAME" \
            "An error occurred during task execution" \
            "Basso"
        ;;
        
    start|begin)
        # When Claude starts a task (optional)
        send_notification \
            "$APP_NAME 🚀" \
            "Task Started - $PROJECT_NAME" \
            "Processing your request..." \
            "Pop"
        ;;
        
    test)
        # Test notification
        send_notification \
            "$APP_NAME 🧪" \
            "Test Notification - $PROJECT_NAME" \
            "Notifications are working!"
        echo "✅ Test notification sent for project: $PROJECT_NAME"
        ;;
        
    *)
        # Help message
        echo "Claude Code System Notifications for macOS"
        echo "=========================================="
        echo ""
        echo "Usage: $0 <event_type> [project_name]"
        echo ""
        echo "Event types:"
        echo "  notification, input  - 🔔 When Claude needs user input"
        echo "  stop, complete, done - ✅ When Claude completes a task"
        echo "  error, failed        - ❌ When an error occurs"
        echo "  start, begin         - 🚀 When Claude starts a task"
        echo "  test                 - 🧪 Test the notification system"
        echo ""
        echo "Project name:"
        echo "  - Optional second parameter"
        echo "  - Auto-detected from current directory if not provided"
        echo "  - Can be set via CLAUDE_PROJECT_NAME environment variable"
        echo ""
        echo "Examples:"
        echo "  $0 notification                    # Auto-detect project name"
        echo "  $0 stop \"MyAwesomeProject\"         # Specify project name"
        echo "  $0 error                           # Error notification"
        echo "  CLAUDE_PROJECT_NAME=Foo $0 test    # Use environment variable"
        echo ""
        echo "Requirements:"
        echo "  - Optional: terminal-notifier (brew install terminal-notifier)"
        echo "  - Fallback: Built-in osascript"
        echo ""
        echo "Current project: $PROJECT_NAME"
        exit 0
        ;;
esac