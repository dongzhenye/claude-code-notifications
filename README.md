# Claude Code Notifications

🔔 **Never miss Claude's response!** Notification solutions for Claude Code - from terminal bells to desktop alerts.

> Working in another window? Get notified when Claude responds. Choose the complexity that fits your workflow.

## 🎯 Choose Your Notification Style

<table align="center">
<tr>
<td align="center" width="33%" style="padding: 20px;">

### 🔔 **Minimal**

**Built into Claude Code**

<br>

✅ **5-second setup**  
✅ Works everywhere  
❌ Same sound for all  

<br>

**[Get started →](#minimal-tier)**

</td>
<td align="center" width="33%" style="padding: 20px; border: 2px solid #ffd700;">

### ⭐ **Recommended**

**Author's daily choice**

<br>

✅ Only 2 key events  
✅ Hand-picked best sounds  
✅ No notification fatigue  
❌ Audio only  

<br>

**🏆 BEST FOR MOST**

**[Get started →](#recommended-tier)**

</td>
<td align="center" width="33%" style="padding: 20px;">

### 🚀 **Custom**

**Desktop notifications & more**

<br>

✅ Desktop notifications  
✅ Push notifications  
✅ Total flexibility  
❌ 5+ minute setup  

<br>

**[Get started →](#custom-tier)**

</td>
</tr>
</table>

## Why Use This?

Working with Claude Code often involves waiting for responses. Without notifications, you might:
- Miss when Claude needs your input
- Not notice when tasks complete
- Waste time constantly checking back

## Minimal Tier

**Zero configuration, maximum simplicity:**

```bash
claude config set --global preferredNotifChannel terminal_bell
```

That's it! You'll hear a beep when Claude needs attention.

✅ Works everywhere  
✅ Zero configuration  
⚠️ Same sound for all events  
⚠️ May need terminal sound enabled on macOS  

## Recommended Tier ⭐

**Smart notifications without the fatigue:**

### Option 1: Automatic Setup
```bash
# Download and run installer
curl -sSL https://raw.githubusercontent.com/dongzhenye/claude-code-notifications/main/install.sh | bash

# Or clone and run locally
git clone https://github.com/dongzhenye/claude-code-notifications.git
cd claude-code-notifications
./install.sh
```

### Option 2: Manual Setup
Copy the appropriate configuration to `~/.claude/settings.json`:

- **macOS**: [recommended/recommended.macos.json](recommended/recommended.macos.json)
- **Linux**: [recommended/recommended.linux.json](recommended/recommended.linux.json)  
- **Windows**: [recommended/recommended.windows.json](recommended/recommended.windows.json)

### What You Get
- 🔔 **Glass sound** when Claude needs input (gentle alert)
- ✅ **Tink sound** when Claude completes a response (subtle confirmation)
- 🎯 Carefully chosen sounds to avoid fatigue
- 🖥️ Platform-optimized configurations

### Sound Philosophy
- **High-frequency events** (completion) → Gentle sounds (Tink)
- **Low-frequency events** (needs input) → Noticeable sounds (Glass)

## Custom Tier

**For users who want full control:**

### Examples

#### System Notifications (macOS)
Want visual notifications? Check out [custom/system-notify.macos.sh](custom/system-notify.macos.sh)

```json
{
  "hooks": {
    "Notification": [{
      "hooks": [{
        "type": "command",
        "command": "~/claude-code-notifications/custom/system-notify.macos.sh notification"
      }]
    }]
  }
}
```

#### Your Own Scripts
Create any notification behavior you want:
- Webhook notifications
- Multi-channel alerts
- Conditional logic
- Integration with other tools

## Testing Sounds

### macOS
```bash
# Test recommended sounds
afplay /System/Library/Sounds/Glass.aiff
afplay /System/Library/Sounds/Tink.aiff

# Explore all system sounds
for sound in Basso Blow Bottle Frog Funk Glass Hero Morse Ping Pop Purr Sosumi Submarine Tink; do 
  echo "Playing $sound:" && afplay "/System/Library/Sounds/$sound.aiff" && sleep 1
done
```

### Linux
```bash
# Test with PulseAudio
paplay /usr/share/sounds/freedesktop/stereo/message.oga

# Test with ALSA
aplay /usr/share/sounds/freedesktop/stereo/complete.oga

# List available sounds
ls /usr/share/sounds/
```

### Windows
```powershell
# Test system sounds
[System.Media.SystemSounds]::Asterisk.Play()
[System.Media.SystemSounds]::Exclamation.Play()

# List available WAV files
dir C:\Windows\Media\*.wav
```

## Troubleshooting

### Multiple sounds playing?
1. Clear terminal bell: `claude config set --global preferredNotifChannel none`
2. Check `~/.claude/settings.json` for duplicate configurations

### No sounds?
1. Check system volume
2. Test commands directly in terminal
3. Verify file paths exist

### Settings not working?
- Changes take effect immediately
- Check JSON syntax
- Ensure editing `~/.claude/settings.json`

## Event Types

Claude Code supports these notification events:

- **Notification**: When Claude needs your input or permission
- **Stop**: When Claude finishes responding

## Contributing

Found a great notification setup? Have ideas for improvements? Contributions welcome!

## Author

Created by [Zhenye Dong](https://github.com/dongzhenye)

If this helps your productivity, please give it a ⭐ on GitHub!