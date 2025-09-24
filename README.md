# Clopy

Minimal macOS menu bar clipboard manager built with specification-driven development. Captures text clips from ⌘C, provides instant access via status bar or global hotkey (⌃⌥V) with auto-paste. In-memory only, privacy-focused. macOS 13+, SwiftUI+AppKit.

See [clopy.md](clopy.md) for the complete specification.

## Features

- Captures text clips automatically when you copy (⌘C)
- Access clips via status bar menu or global hotkey (⌃⌥V)
- Auto-paste functionality with Accessibility permission
- In-memory only - no data persistence
- Native macOS design with light/dark mode support

## Requirements

- macOS 13.0+ (Ventura)
- Xcode 16.0+ for building

## Installation

### Download Release
1. Download the latest release from [Releases](../../releases)
2. Unzip and drag `Clopy.app` to Applications folder
3. Launch Clopy from Applications

### Build from Source
```bash
git clone https://github.com/yourusername/clopy.git
cd clopy
open Clopy.xcodeproj
```
Build and run in Xcode (⌘R)

## Setup

1. **Launch**: Clopy appears in menu bar (clipboard icon)
2. **Accessibility Permission**: For auto-paste, grant permission when prompted:
   - System Preferences → Privacy & Security → Accessibility → Add Clopy
3. **Usage**:
   - Copy text anywhere (⌘C) - automatically captured
   - Click menu bar icon to select clips (copies to clipboard)
   - Press ⌃⌥V to select clips with auto-paste
   - Configure hotkey via "Change Hotkey..." menu

## License

MIT License - see [LICENSE](LICENSE) file.
