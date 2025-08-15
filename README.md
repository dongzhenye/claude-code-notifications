# Claude Code Notifications

Your one-stop solution for Claude Code notifications. From simple terminal bells to rich system notifications - never miss a response while working in other windows! This comprehensive notification toolkit helps you stay productive with customizable alerts.

## Table of Contents

- [Why Use This?](#why-use-this)
- [Quick Start (1 Command)](#quick-start-1-command)
- [Advanced: Different Sounds for Different Events](#advanced-different-sounds-for-different-events)
  - [1. Create Configuration](#1-create-configuration)
  - [2. Event Types](#2-event-types)
- [Sound Selection Guide](#sound-selection-guide)
  - [My Recommendations](#my-recommendations)
  - [Selection Principles](#selection-principles)
  - [Other Good Options](#other-good-options)
- [Test Sounds](#test-sounds)
- [Cross-Platform Examples](#cross-platform-examples)
  - [macOS](#macos)
  - [Linux](#linux)
  - [Windows](#windows)
- [Troubleshooting](#troubleshooting)
- [Resources](#resources)

## Why Use This?

Working with Claude Code often involves waiting for responses or providing input at various stages. Without sound notifications, you might:

- Miss when Claude needs your permission to proceed
- Not notice when a long-running task completes
- Waste time checking back when you could be notified instantly
- Lose focus switching between windows unnecessarily

With Claude Code sound notifications, you can:
- Work in other applications and get alerted when needed
- Know immediately when tasks complete
- Distinguish between different types of events with custom sounds
- Maintain your workflow without constant visual monitoring

## Quick Start (1 Command)

```bash
claude config set --global preferredNotifChannel terminal_bell
```

This enables a simple beep when tasks complete. Great for getting started, but:
- macOS may require additional terminal sound settings
- Limited support on Windows WSL
- Only one sound for all events

## Advanced: Different Sounds for Different Events

Want better control? Use Hooks to configure different sounds for different scenarios.

### 1. Create Configuration

Edit `~/.claude/settings.json`:

```json
{
  "hooks": {
    "Notification": [{
      "hooks": [{
        "type": "command",
        "command": "afplay /System/Library/Sounds/Glass.aiff"
      }]
    }],
    "Stop": [{
      "hooks": [{
        "type": "command",
        "command": "afplay /System/Library/Sounds/Tink.aiff"
      }]
    }]
  }
}
```

**Note**: The `model` field is optional. Only include it if you have a specific model preference configured.

### 2. Event Types

- **Notification**: When Claude needs your input or permission (low frequency)
- **Stop**: When Claude finishes responding (high frequency)

## Sound Selection Guide

### My Recommendations

- **Need Input**: Glass (bubble sound)
  - Noticeable enough to grab attention
  - Since it triggers rarely, a slightly more prominent sound is acceptable

- **Task Complete**: Tink (ding)  
  - Single syllable, brief and non-intrusive
  - Since it triggers after every response, must avoid auditory fatigue

### Selection Principles

1. **High-frequency events need gentle sounds**: Task completion happens often, so Tink's single note works well
2. **Low-frequency events can be more prominent**: Input requests are rare, so Glass can be more attention-grabbing
3. **Avoid lengthy sounds**: Funk, Submarine, etc. can cause listening fatigue

### Other Good Options

Based on personal preference, you might also try:
- Morse - Ultra-brief, great for high-frequency events
- Hero - Pleasant but might be too bold
- Purr - Soft but might not be noticeable enough

## Test Sounds

### macOS

```bash
# Test single sound
afplay /System/Library/Sounds/Tink.aiff

# Test all available sounds
for sound in Basso Blow Bottle Frog Funk Glass Hero Morse Ping Pop Purr Sosumi Submarine Tink; do 
  echo "Playing $sound:" && afplay "/System/Library/Sounds/$sound.aiff" && sleep 1
done
```

## Cross-Platform Examples

### macOS

```json
{
  "hooks": {
    "Notification": [{
      "hooks": [{
        "type": "command",
        "command": "afplay /System/Library/Sounds/Glass.aiff"
      }]
    }],
    "Stop": [{
      "hooks": [{
        "type": "command",
        "command": "afplay /System/Library/Sounds/Tink.aiff"
      }]
    }]
  }
}
```

### Linux

Using ALSA (aplay):
```json
{
  "hooks": {
    "Notification": [{
      "hooks": [{
        "type": "command",
        "command": "aplay /usr/share/sounds/freedesktop/stereo/message.oga"
      }]
    }],
    "Stop": [{
      "hooks": [{
        "type": "command",
        "command": "aplay /usr/share/sounds/freedesktop/stereo/complete.oga"
      }]
    }]
  }
}
```

Using PulseAudio (paplay):
```json
{
  "hooks": {
    "Notification": [{
      "hooks": [{
        "type": "command",
        "command": "paplay /usr/share/sounds/ubuntu/stereo/message.ogg"
      }]
    }],
    "Stop": [{
      "hooks": [{
        "type": "command",
        "command": "paplay /usr/share/sounds/ubuntu/stereo/dialog-information.ogg"
      }]
    }]
  }
}
```

Test Linux sounds:
```bash
# List available system sounds
ls /usr/share/sounds/

# Test a sound with aplay
aplay /usr/share/sounds/freedesktop/stereo/complete.oga

# Test a sound with paplay
paplay /usr/share/sounds/ubuntu/stereo/message.ogg
```

### Windows

Using PowerShell system sounds:
```json
{
  "hooks": {
    "Notification": [{
      "hooks": [{
        "type": "command",
        "command": "powershell.exe -c \"[System.Media.SystemSounds]::Exclamation.Play()\""
      }]
    }],
    "Stop": [{
      "hooks": [{
        "type": "command",
        "command": "powershell.exe -c \"[System.Media.SystemSounds]::Asterisk.Play()\""
      }]
    }]
  }
}
```

Using custom WAV files:
```json
{
  "hooks": {
    "Notification": [{
      "hooks": [{
        "type": "command",
        "command": "powershell.exe -c \"(New-Object Media.SoundPlayer 'C:\\Windows\\Media\\chimes.wav').PlaySync()\""
      }]
    }],
    "Stop": [{
      "hooks": [{
        "type": "command",
        "command": "powershell.exe -c \"(New-Object Media.SoundPlayer 'C:\\Windows\\Media\\ding.wav').PlaySync()\""
      }]
    }]
  }
}
```

Test Windows sounds:
```bash
# Test system sounds
powershell.exe -c "[System.Media.SystemSounds]::Asterisk.Play()"
powershell.exe -c "[System.Media.SystemSounds]::Exclamation.Play()"
powershell.exe -c "[System.Media.SystemSounds]::Hand.Play()"
powershell.exe -c "[System.Media.SystemSounds]::Question.Play()"

# List available WAV files
dir C:\Windows\Media\*.wav

# Test a specific WAV file
powershell.exe -c "(New-Object Media.SoundPlayer 'C:\Windows\Media\chimes.wav').PlaySync()"
```

## Troubleshooting

### Hearing multiple sounds?

1. Clear terminal bell setting: `claude config set --global preferredNotifChannel none`
2. Check for notifications from other apps
3. Ensure your `~/.claude/settings.json` has proper JSON syntax

### No sounds playing?

1. Check your system volume is not muted
2. Verify the sound file paths exist on your system
3. Test the command directly in your terminal
4. Ensure Claude Code has permission to execute commands

### Settings not taking effect?

- Settings take effect immediately, no restart needed
- Check for syntax errors in your JSON configuration
- Make sure you're editing the correct settings file (`~/.claude/settings.json`)

## Resources

- [Claude Code Official Documentation](https://docs.anthropic.com/en/docs/build-with-claude/claude-for-developers)
- [Claude Code CLI GitHub Repository](https://github.com/anthropics/claude-cli)
- [Anthropic Developer Documentation](https://docs.anthropic.com/)

---

💡 **Pro Tip**: Combine Claude Code sound notifications with your operating system's Do Not Disturb mode for focused work sessions where only Claude can alert you.

## Author

Created by [Zhenye Dong](https://github.com/dongzhenye) ([@dongzhenye](mailto:dongzhenye@gmail.com))

If you find this helpful, please give it a ⭐ on GitHub!