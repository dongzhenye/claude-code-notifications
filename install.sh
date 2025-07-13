#!/bin/bash

# Claude Code Sound Notifications - Quick Setup Script
# This script helps you set up sound notifications for Claude Code
# Author: Zhenye Dong (dongzhenye@gmail.com)
# Repository: https://github.com/dongzhenye/claude-code-sound-notifications

echo "🔔 Claude Code Sound Notifications Setup"
echo "======================================="
echo ""

# Check if Claude Code is installed
if ! command -v claude &> /dev/null; then
    echo "❌ Claude Code is not installed or not in PATH"
    echo "Please install Claude Code first: https://github.com/anthropics/claude-code"
    exit 1
fi

echo "Choose your setup method:"
echo "1) Simple terminal bell (1 command, same sound for all events)"
echo "2) Advanced hooks setup (different sounds for different events)"
echo ""
read -p "Enter your choice (1 or 2): " choice

case $choice in
    1)
        echo ""
        echo "Setting up terminal bell notifications..."
        claude config set --global preferredNotifChannel terminal_bell
        echo "✅ Terminal bell notifications enabled!"
        echo ""
        echo "Test with: echo -e '\\a'"
        echo ""
        echo "Note: macOS users may need to enable terminal sounds in preferences"
        ;;
    2)
        echo ""
        echo "Setting up advanced hooks configuration..."
        
        # Create backup if settings.json exists
        if [ -f ~/.claude/settings.json ]; then
            cp ~/.claude/settings.json ~/.claude/settings.json.backup
            echo "📋 Backed up existing settings to ~/.claude/settings.json.backup"
        fi
        
        # Create directory if it doesn't exist
        mkdir -p ~/.claude
        
        # Copy example configuration
        cp example-settings.json ~/.claude/settings.json
        echo "✅ Hooks configuration installed!"
        echo ""
        echo "Current configuration:"
        echo "- Input needed: Glass sound (bubble)"
        echo "- Task complete: Tink sound (ding)"
        echo ""
        echo "Edit ~/.claude/settings.json to customize sounds"
        ;;
    *)
        echo "Invalid choice. Please run the script again and choose 1 or 2."
        exit 1
        ;;
esac

echo ""
echo "🎉 Setup complete! Enjoy your Claude Code sound notifications!"