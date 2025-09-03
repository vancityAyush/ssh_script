# SSH Script

This cross-platform shell script automates the process of generating and configuring SSH keys for Bitbucket, GitHub, or GitLab. The script is compatible with macOS, Linux, Windows (Git Bash/WSL), and provides comprehensive error handling and validation.

## Features

- ✅ **Cross-platform compatibility**: Works on macOS, Linux, Windows, and WSL
- ✅ **Input validation**: Validates email addresses, key names, and user choices
- ✅ **Smart clipboard handling**: Automatically copies SSH key to clipboard on all platforms
- ✅ **Automatic browser opening**: Opens SSH settings page for your chosen Git provider
- ✅ **SSH agent management**: Properly handles SSH agent across different platforms
- ✅ **Error handling**: Comprehensive error checking and user-friendly messages
- ✅ **SSH connection testing**: Built-in SSH key testing functionality
- ✅ **Modern key types**: Uses Ed25519 keys (GitHub/Bitbucket) and RSA-4096 (GitLab)

## Platform Support

| Platform | SSH Agent | Clipboard | Browser Opening | Status |
|----------|-----------|-----------|----------------|---------|
| **macOS** | ✅ | `pbcopy` | `open` | ✅ |
| **Linux** | ✅ | `xclip`, `xsel` | `xdg-open`, `sensible-browser` | ✅ |
| **Windows** | ✅ | `clip.exe`, `clip` | `start`, `cmd.exe` | ✅ |
| **WSL** | ✅ | `clip.exe`, `xclip` | `xdg-open` | ✅ |

## Quick Installation & Usage

### Option 1: Direct Download and Run
```bash
curl -O https://raw.githubusercontent.com/vancityAyush/ssh_script/main/ssh.sh
chmod +x ssh.sh
./ssh.sh
```

### Option 2: One-liner Download and Execute
```bash
curl -fsSL https://raw.githubusercontent.com/vancityAyush/ssh_script/main/ssh.sh | bash
```

### Option 3: Clone Repository
```bash
git clone https://github.com/vancityAyush/ssh_script.git
cd ssh_script
chmod +x ssh.sh
./ssh.sh
```

## How It Works

1. **Platform Detection**: Automatically detects your operating system (macOS, Linux, Windows, WSL)
2. **Provider Selection**: Choose between Bitbucket, GitHub, or GitLab
3. **Input Validation**: Validates email format and key naming
4. **Key Generation**: 
   - GitHub/Bitbucket: Ed25519 keys (modern, secure, fast)
   - GitLab: RSA-4096 keys (maximum compatibility)
5. **SSH Agent Setup**: Automatically starts SSH agent and adds your key
6. **Config Management**: Updates SSH config with host-specific settings
7. **Clipboard Integration**: Copies public key to clipboard automatically
8. **Browser Integration**: Opens SSH settings page for easy key addition
9. **Connection Testing**: Built-in SSH connection testing

## What Gets Created

- `~/.ssh/[keyname]` - Your private SSH key
- `~/.ssh/[keyname].pub` - Your public SSH key
- `~/.ssh/config` - SSH configuration (updated)

## Troubleshooting

### Permission Errors
```bash
# Make sure script is executable
chmod +x ssh.sh

# Check SSH directory permissions
ls -la ~/.ssh
```

### SSH Agent Issues
```bash
# Manually start SSH agent if needed
eval "$(ssh-agent -s)"

# List loaded keys
ssh-add -l
```

### Connection Testing
```bash
# Test specific connections
ssh -T git@github.com
ssh -T git@bitbucket.org  
ssh -T git@gitlab.com
```

## Requirements

- Bash shell (available on all supported platforms)
- SSH client (usually pre-installed)
- Git (for SSH testing)
- Internet connection (for downloading and testing)

## Changelog

### v2.0.0 - Cross-Platform Compatibility Update

**🚀 Major Improvements:**
- ✅ **Cross-platform compatibility**: Added full support for macOS, Linux, Windows, and WSL
- ✅ **Operating system detection**: Automatic platform detection for optimized behavior
- ✅ **Enhanced clipboard support**: Added `pbcopy` (macOS), `xsel` (Linux alternative), improved WSL handling
- ✅ **Better browser integration**: Platform-specific URL opening with fallbacks
- ✅ **Smart SSH agent management**: Improved SSH agent handling across all platforms

**🔧 Bug Fixes:**
- ✅ **Fixed Ed25519 key generation**: Removed invalid `-b 4096` flag for Ed25519 keys (Bitbucket)
- ✅ **Fixed curl recursion bug**: Removed problematic self-downloading section
- ✅ **Resolved all shellcheck warnings**: Improved script quality and reliability
- ✅ **Fixed directory navigation**: Added proper error handling for `cd` commands
- ✅ **Fixed SSH config writing**: Using `printf` instead of `echo` for better formatting

**🛡️ Security & Reliability:**
- ✅ **Input validation**: Email format validation, key name validation, choice validation
- ✅ **Error handling**: Comprehensive error checking throughout the script
- ✅ **Safe variable handling**: Properly quoted variables to prevent word splitting
- ✅ **Exit on errors**: Added `set -e` for fail-fast behavior

**📱 User Experience:**
- ✅ **Better user feedback**: Clear success/error messages with emojis
- ✅ **Improved SSH testing**: Better handling of SSH test exit codes
- ✅ **Enhanced documentation**: Comprehensive README with troubleshooting
- ✅ **Progress indicators**: Visual feedback for each step of the process
