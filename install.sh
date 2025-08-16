#!/bin/bash

# Claude Code Notifications Installer
# https://github.com/dongzhenye/claude-code-notifications

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CLAUDE_DIR="$HOME/.claude"
SETTINGS_FILE="$CLAUDE_DIR/settings.json"
BACKUP_SUFFIX=".backup.$(date +%Y%m%d_%H%M%S)"

# Default values
TIER=""
SKIP_CONFIRM=false
NO_BACKUP=false
PLATFORM=""

# Detect platform
detect_platform() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        PLATFORM="macos"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        PLATFORM="linux"
    elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
        PLATFORM="windows"
    else
        echo -e "${YELLOW}⚠ Unknown platform: $OSTYPE${NC}"
        PLATFORM="unknown"
    fi
}

# Print banner
print_banner() {
    echo
    echo "╭─────────────────────────────────────────╮"
    echo "│   Claude Code Notifications Installer   │"
    echo "│        Never miss a response!           │"
    echo "╰─────────────────────────────────────────╯"
    echo
}

# Print usage
print_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo
    echo "Options:"
    echo "  -t, --tier <tier>    Specify tier: minimal, recommended, custom"
    echo "  -y, --yes            Skip confirmation prompts"
    echo "  --no-backup          Don't backup existing configuration"
    echo "  -h, --help           Show this help message"
    echo
    echo "Examples:"
    echo "  $0                   # Interactive installation"
    echo "  $0 -t recommended -y # Quick recommended setup"
    echo "  $0 -t minimal        # Install minimal tier"
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -t|--tier)
            TIER="$2"
            shift 2
            ;;
        -y|--yes)
            SKIP_CONFIRM=true
            shift
            ;;
        --no-backup)
            NO_BACKUP=true
            shift
            ;;
        -h|--help)
            print_banner
            print_usage
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            print_usage
            exit 1
            ;;
    esac
done

# Check environment
check_environment() {
    echo "Detecting environment..."
    
    # Detect platform
    detect_platform
    echo -e "✓ Platform: ${GREEN}$PLATFORM${NC}"
    
    # Check Claude Code
    if command -v claude &> /dev/null; then
        echo -e "✓ Claude Code: ${GREEN}Found${NC}"
    else
        echo -e "${YELLOW}⚠ Claude Code: Not found in PATH${NC}"
        echo "  Please install Claude Code first:"
        echo "  https://docs.anthropic.com/claude-code/install"
    fi
    
    # Check existing config
    if [[ -f "$SETTINGS_FILE" ]]; then
        echo -e "${YELLOW}⚠ Existing config: $SETTINGS_FILE${NC}"
    else
        echo -e "✓ Config: ${GREEN}No existing configuration${NC}"
    fi
    
    echo
}

# Interactive tier selection
select_tier_interactive() {
    echo "Choose your notification style:"
    echo
    echo "1) Minimal     - Terminal bell only (5 seconds)"
    echo "2) Recommended - Different sounds for events ⭐"
    echo "3) Custom      - Pick your own features"
    echo "4) Exit"
    echo
    
    read -p "Enter choice [2]: " choice
    choice=${choice:-2}
    
    case $choice in
        1)
            TIER="minimal"
            ;;
        2)
            TIER="recommended"
            ;;
        3)
            TIER="custom"
            ;;
        4)
            echo "Installation cancelled"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid choice${NC}"
            select_tier_interactive
            ;;
    esac
}

# Handle backup
handle_backup() {
    if [[ -f "$SETTINGS_FILE" ]] && [[ "$NO_BACKUP" != true ]]; then
        local backup_file="${SETTINGS_FILE}${BACKUP_SUFFIX}"
        
        if [[ "$SKIP_CONFIRM" != true ]]; then
            echo "Found existing configuration:"
            echo "  $SETTINGS_FILE"
            echo
            echo "Options:"
            echo "1) Backup and proceed ✓"
            echo "2) Overwrite (no backup)"
            echo "3) Cancel"
            echo
            
            read -p "Your choice [1]: " choice
            choice=${choice:-1}
            
            case $choice in
                1)
                    cp "$SETTINGS_FILE" "$backup_file"
                    echo -e "${GREEN}✓ Backed up to: $backup_file${NC}"
                    ;;
                2)
                    echo -e "${YELLOW}⚠ Proceeding without backup${NC}"
                    ;;
                3)
                    echo "Installation cancelled"
                    exit 0
                    ;;
                *)
                    echo -e "${RED}Invalid choice${NC}"
                    handle_backup
                    ;;
            esac
        else
            cp "$SETTINGS_FILE" "$backup_file"
            echo -e "${GREEN}✓ Backed up to: $backup_file${NC}"
        fi
    fi
}

# Install minimal tier
install_minimal() {
    echo -e "${BLUE}Installing Minimal tier...${NC}"
    echo
    echo "Run this command to enable terminal bell:"
    echo
    echo -e "${GREEN}claude config set --global preferredNotifChannel terminal_bell${NC}"
    echo
    echo "That's it! You'll hear a beep when Claude needs attention."
}

# Install recommended tier
install_recommended() {
    echo -e "${BLUE}Installing Recommended tier...${NC}"
    
    # Ensure .claude directory exists
    mkdir -p "$CLAUDE_DIR"
    
    # Select appropriate config file
    local config_file="$SCRIPT_DIR/recommended/recommended.$PLATFORM.json"
    
    if [[ ! -f "$config_file" ]]; then
        echo -e "${RED}Error: Configuration file not found: $config_file${NC}"
        echo "Please ensure you're running from the project directory"
        exit 1
    fi
    
    # Copy configuration
    cp "$config_file" "$SETTINGS_FILE"
    echo -e "${GREEN}✓ Configuration installed${NC}"
    echo
    echo "Configuration file: $SETTINGS_FILE"
    echo "Platform: $PLATFORM"
    echo
    echo "You'll hear:"
    echo "  • Glass sound when Claude needs input"
    echo "  • Tink sound when Claude completes a response"
}

# Install custom tier
install_custom() {
    echo -e "${BLUE}Custom tier setup${NC}"
    echo
    echo "Available examples:"
    echo "1) macOS system notifications (visual + sound)"
    echo "2) Manual configuration (I'll set it up myself)"
    echo
    
    read -p "Your choice [2]: " choice
    choice=${choice:-2}
    
    case $choice in
        1)
            echo
            echo "To use macOS system notifications, add this to your ~/.claude/settings.json:"
            echo
            cat << 'EOF'
{
  "hooks": {
    "Notification": [{
      "hooks": [{
        "type": "command",
        "command": "~/claude-code-notifications/custom/system-notify.macos.sh notification 'Claude Code' 'Needs your input'"
      }]
    }],
    "Stop": [{
      "hooks": [{
        "type": "command",
        "command": "~/claude-code-notifications/custom/system-notify.macos.sh stop 'Claude Code' 'Task completed'"
      }]
    }]
  }
}
EOF
            echo
            echo "Make sure the script is executable:"
            echo "  chmod +x $SCRIPT_DIR/custom/system-notify.macos.sh"
            ;;
        2)
            echo
            echo "Create or edit: ~/.claude/settings.json"
            echo "See examples in: $SCRIPT_DIR/custom/"
            echo "Documentation: https://github.com/dongzhenye/claude-code-notifications"
            ;;
    esac
}

# Show installation summary
show_summary() {
    echo
    echo "════════════════════════════════════════"
    echo -e "${GREEN}✅ Installation complete!${NC}"
    echo "════════════════════════════════════════"
    echo
    echo "Tier: $TIER"
    if [[ "$TIER" != "minimal" ]]; then
        echo "Config: $SETTINGS_FILE"
    fi
    if [[ -n "$backup_file" ]]; then
        echo "Backup: $backup_file"
    fi
    echo
    echo "Test your setup:"
    echo "  1. Run any Claude Code command"
    echo "  2. You should hear notifications at different events"
    echo
    echo "Need help? Visit:"
    echo "  https://github.com/dongzhenye/claude-code-notifications"
}

# Main installation flow
main() {
    print_banner
    check_environment
    
    # Select tier if not provided
    if [[ -z "$TIER" ]]; then
        if [[ "$SKIP_CONFIRM" == true ]]; then
            TIER="recommended"
            echo "Using default tier: recommended"
        else
            select_tier_interactive
        fi
    fi
    
    # Validate tier
    if [[ "$TIER" != "minimal" ]] && [[ "$TIER" != "recommended" ]] && [[ "$TIER" != "custom" ]]; then
        echo -e "${RED}Error: Invalid tier '$TIER'${NC}"
        echo "Valid tiers: minimal, recommended, custom"
        exit 1
    fi
    
    # Confirm installation
    if [[ "$SKIP_CONFIRM" != true ]] && [[ "$TIER" != "minimal" ]]; then
        echo
        echo "Ready to install:"
        echo "  Tier: $TIER"
        echo "  Platform: $PLATFORM"
        echo
        read -p "Proceed? [Y/n]: " confirm
        confirm=${confirm:-Y}
        
        if [[ "$confirm" != [Yy]* ]]; then
            echo "Installation cancelled"
            exit 0
        fi
    fi
    
    # Handle backup for non-minimal tiers
    if [[ "$TIER" != "minimal" ]]; then
        handle_backup
    fi
    
    # Install based on tier
    case $TIER in
        minimal)
            install_minimal
            ;;
        recommended)
            install_recommended
            ;;
        custom)
            install_custom
            ;;
    esac
    
    # Show summary
    if [[ "$TIER" != "minimal" ]]; then
        show_summary
    fi
}

# Run main function
main