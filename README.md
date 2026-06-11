# Clopy

Minimal macOS menu bar clipboard manager. Captures text clips from ⌘C, provides instant access via the status bar or a global hotkey (⌃⌥V), and supports automatic paste. Clipboard contents remain in memory and are cleared when the app quits. Built for macOS 13+ with SwiftUI and AppKit.

📖 **Read the story**: [5 Hours, One LLM, and the Multi-Clipboard I Always Wanted](https://medium.com/@svenkirsime/5-hours-one-llm-and-the-multi-clipboard-i-always-wanted-0b2504bcd462) (also available in [docs/medium-post-10.2025/medium-post.md](docs/medium-post-10.2025/medium-post.md))

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
1. Download the latest DMG from [Releases](../../releases)
2. Open the DMG file and drag `Clopy.app` to Applications folder
3. Launch Clopy from Applications

**Security Note**: When first launching, macOS may show "Apple could not verify Clopy is free of malware" because this is an unsigned testing build. To run the app:
1. Go to **System Settings** → **Privacy & Security**
2. Click **"Open Anyway"** next to the Clopy warning
3. Confirm by clicking **"Open"** in the dialog

### Build from Source

#### Option 1: Xcode GUI
```bash
git clone https://github.com/svennu/clopy.git
cd clopy
open Clopy.xcodeproj
```
Build and run in Xcode (⌘R)

#### Option 2: Command Line Build
```bash
# Clone the repository
git clone https://github.com/svennu/clopy.git
cd clopy

# Build for local development (Debug)
xcodebuild -project Clopy.xcodeproj \
           -scheme Clopy \
           -configuration Debug \
           -derivedDataPath ./build \
           CODE_SIGNING_ALLOWED=NO \
           build

# Run the built app
open ./build/Build/Products/Debug/Clopy.app

# Or build for release (optimized)
xcodebuild -project Clopy.xcodeproj \
           -scheme Clopy \
           -configuration Release \
           -derivedDataPath ./build \
           build

# Install to Applications folder (optional)
cp -R ./build/Build/Products/Release/Clopy.app /Applications/
```

#### Option 3: Create Distributable Package
```bash
# Archive the project
xcodebuild -project Clopy.xcodeproj \
           -scheme Clopy \
           -configuration Release \
           -archivePath ./build/Clopy.xcarchive \
           archive

# Export as app bundle
xcodebuild -exportArchive \
           -archivePath ./build/Clopy.xcarchive \
           -exportPath ./build/export \
           -exportOptionsPlist ./ExportOptions.plist

# Create DMG for distribution
mkdir -p ./build/dmg-staging
cp -R ./build/export/Clopy.app ./build/dmg-staging/
hdiutil create -volname "Clopy" \
               -srcfolder ./build/dmg-staging \
               -ov -format UDZO \
               ./build/Clopy.dmg
```

#### Build Requirements
- **Xcode 16.0+** with Command Line Tools
- **macOS 13.0+** (Ventura) for building and running
- **Swift 5.9+** (included with Xcode)

#### Troubleshooting Build Issues
```bash
# Clean build folder
rm -rf ./build

# Reset Xcode derived data (if using Xcode)
rm -rf ~/Library/Developer/Xcode/DerivedData

# Verify Xcode command line tools
xcode-select --install

# Check available schemes
xcodebuild -project Clopy.xcodeproj -list

# Build with verbose output for debugging
xcodebuild -project Clopy.xcodeproj \
           -scheme Clopy \
           -configuration Debug \
           -derivedDataPath ./build \
           -verbose \
           build
```

## Setup

1. **Launch**: Clopy appears in menu bar (clipboard icon)
2. **Accessibility Permission**: For auto-paste, grant permission when prompted:
   - System Settings → Privacy & Security → Accessibility → Add Clopy
3. **Usage**:
   - Copy text anywhere (⌘C) - automatically captured
   - Click menu bar icon to select clips (copies to clipboard)
   - Press ⌃⌥V to select clips with auto-paste
   - Configure hotkey via "Change Hotkey..." menu

## Development Notes

**Current Status**: Testing phase with sandboxing disabled for auto-paste functionality evaluation.

- **Sandboxing**: Currently disabled in `Clopy.entitlements` for testing auto-paste features
- **Auto-paste**: Uses CGEvent keystroke simulation (requires Accessibility permission)
- **Fallback**: AppleScript keystroke simulation if CGEvent fails
- **Distribution**: Deciding between App Store (sandboxed) vs direct distribution (non-sandboxed)

**For Developers**:
- The app is fully functional for testing without sandbox restrictions
- See `clopy.md` for complete specification and implementation details
- See `AGENTS.md` for repository guidance used by Codex and other coding agents
- All core features implemented: clipboard monitoring, hotkey system, star management
- Comprehensive logging available via Console.app (filter: "com.clopy.app")

## License

No license file is currently included in this repository.
