# Clopy Agent Instructions

## Project Overview

Clopy is a native macOS 13+ menu bar clipboard manager written in Swift. It stores
text clips in memory, exposes them through an `NSStatusItem` menu, and supports a
configurable global hotkey with optional automatic paste.

The product specification in [clopy.md](clopy.md) defines expected behavior and
scope. Keep implementation changes consistent with it, and update the specification
when product behavior intentionally changes.

## Repository Map

| Area | Location |
|---|---|
| Product overview and setup | [README.md](README.md) |
| Specification and acceptance criteria | [clopy.md](clopy.md) |
| Swift source | [Clopy/](Clopy/) |
| Xcode project | [Clopy.xcodeproj](Clopy.xcodeproj/) |
| Historical article material | [docs/](docs/) |
| Built release artifact | [builds/](builds/) |

## Build And Validation

Run commands from the repository root.

```bash
# Inspect targets and schemes
xcodebuild -project Clopy.xcodeproj -list

# Compile without requiring a local signing identity
xcodebuild -project Clopy.xcodeproj \
  -scheme Clopy \
  -configuration Debug \
  -derivedDataPath /tmp/clopy-derived-data \
  CODE_SIGNING_ALLOWED=NO \
  build
```

There is currently no automated test target. For behavior changes, build the app and
manually verify the affected flow on macOS. Clipboard monitoring, global hotkeys,
Accessibility permission, and automatic paste require a real desktop session.

## Architecture

- `ClopyApp.swift`: application entry point and object wiring.
- `ClipboardManager.swift`: pasteboard polling, in-memory retention, clip actions,
  and automatic paste.
- `StatusBarManager.swift`: status item, menus, selection mode, and management UI.
- `HotkeyManager.swift`: Carbon global hotkey registration and shortcut editing.
- `Clip.swift`: in-memory clip model and menu display formatting.
- `Info.plist`: menu bar application configuration (`LSUIElement`).
- `Clopy.entitlements`: intentionally empty while direct, non-sandboxed distribution
  is being evaluated.

## Implementation Rules

- Preserve the app's text-only, in-memory privacy model unless requirements change.
- Keep AppKit and Carbon integrations focused; use SwiftUI only where it simplifies
  application lifecycle or UI.
- Perform UI and `@Published` state updates on the main thread.
- Avoid persistence of clipboard contents. Only hotkey preferences use `UserDefaults`.
- Preserve starred clips when enforcing the retention limit or deleting all clips.
- Avoid unrelated changes to the Xcode project file and generated build artifacts.
- Do not modify historical files under `docs/` to describe current implementation.
- Use `OSLog` with the existing `com.clopy.app` subsystem for runtime diagnostics.

## Change Checklist

1. Read the relevant source and matching sections of `clopy.md`.
2. Keep edits narrowly scoped and update documentation when commands or behavior change.
3. Run the Debug build above.
4. Report manual validation that remains necessary because no automated tests exist.
