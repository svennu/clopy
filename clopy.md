# Clopy – Current Implementation Specification

Status: Current code documentation • Target: macOS 13+ direct/non-sandboxed testing build • Automated tests: none

## 1) Summary

Clopy is a native macOS menu bar clipboard manager. It runs as an `LSUIElement` app with no Dock icon, monitors the general pasteboard while the app is running, and keeps text clips in memory only.

Users can:
- View captured text clips from the status bar menu.
- Select a clip from the status bar menu to copy it back to the general pasteboard for manual pasting.
- Press the configurable global hotkey, default Control-Option-V, to open the same status bar menu and select a clip for automatic paste.
- Star and unstar clips in memory.
- Delete one clip, or delete all non-starred clips after confirmation.
- Change or reset the global hotkey from the status bar menu.
- Quit from the status bar menu.

Clipboard contents and star state are not persisted. They are cleared when the app quits. Only hotkey preferences are persisted in `UserDefaults`.

## 2) Goals and Non-Goals

### Goals
- Provide a simple text-only clipboard helper for a single macOS session.
- Keep recent text clips available from a status bar menu, ordered with the newest clip first.
- Support a global hotkey that opens the clip menu and marks the next clip selection for automatic paste.
- Preserve starred clips when enforcing retention or deleting all clips.
- Avoid writing clipboard contents to disk.

### Non-Goals
- Rich content capture, including RTF, images, files, or other pasteboard types.
- Cloud sync, accounts, analytics, or background services outside the app process.
- Editing clip contents or adding clips manually through a custom editor.
- Search, tagging, custom ordering, or pinning beyond the in-memory star flag.
- Persisting clipboard history or star state across launches.


## 3) Users and Primary Use Cases

### Users
- macOS users who frequently reuse plain-text snippets during one desktop session.

### Primary Use Cases
1. Copy or otherwise place non-empty text on the general pasteboard while Clopy is running; Clopy captures the text into its in-memory list.
2. Choose a snippet from the status bar menu to copy it back to the pasteboard, then paste manually with Command-V.
3. Press the global hotkey, choose a snippet from the opened status menu, and let Clopy attempt to paste automatically at the current cursor location.
4. Star important snippets so retention and delete-all actions preserve them.
5. Delete a single snippet, or clear all non-starred snippets after confirmation.

## 4) Scope

### In Scope
- An AppKit `NSStatusItem` menu bar UI with an SF Symbol template icon named `doc.on.clipboard`.
- Text capture from `NSPasteboard.general` when the pasteboard `changeCount` changes and `.string` content is available.
- In-memory clip storage with a retention limit of 15 items, while preserving starred clips when the limit is enforced.
- Display of captured clips in newest-first order.
- Clip display text that replaces newlines and carriage returns with spaces, trims outer whitespace/newlines, and middle-truncates long text to 30 leading characters plus an ellipsis plus 20 trailing characters.
- A star prefix (`⭐ `) in display text for starred clips.
- Status menu clip selection that copies the clip to the general pasteboard.
- Hotkey-opened menu clip selection that copies the clip and then attempts automatic paste.
- Star, unstar, delete-one, delete-all-non-starred, change-hotkey, and quit menu actions.
- Runtime diagnostics through `OSLog` using the `com.clopy.app` subsystem.

### Out of Scope
- Any primary application window. The SwiftUI app exposes only an empty Settings scene.
- Clipboard history persistence.
- App Store sandbox behavior as an active implementation target; sandbox and clipboard entitlements are currently commented out in the entitlements file.
- Modifying historical documentation under `docs/` to describe current behavior.

## 5) User Experience

### App Shell
- The app is configured as a UIElement application with `LSUIElement = true`.
- The status bar button uses `NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)`.
- The status bar button uses the `doc.on.clipboard` SF Symbol as a template image and has the tooltip `Clopy - Clipboard Manager`.
- The app has no Dock icon and no main window.

### Status Menu Layout
The menu is rebuilt from the current in-memory clip list.

1. **Clip section**
   - If no clips exist, the menu shows a disabled `No clips` item.
   - Otherwise, each clip appears as one menu item, newest first, using `Clip.displayText`.
   - Selecting a clip calls `ClipboardManager.selectClip(_:autoPaste:)`.
2. **Separator**
3. **Management section** shown only when clips exist
   - `Star Clip` submenu, shown only when at least one clip is not starred.
   - `Unstar Clip` submenu, shown only when at least one clip is starred.
   - `Delete Clip` submenu, listing every clip. Selecting an item deletes immediately without confirmation.
   - `Delete All Clips…`, which actually deletes only non-starred clips after confirmation.
   - Separator.
4. **Always-visible actions**
   - `Change Hotkey…`.
   - Separator.
   - `Quit` with key equivalent `q`.

### Delete All Behavior
- If there are no clips, the action does nothing.
- If every clip is starred, an informational alert titled `All Clips Are Starred` is shown and no clip is deleted.
- Otherwise, a warning alert titled `Delete All Non-Starred Clips` asks for confirmation.
- Confirming deletes non-starred clips and preserves starred clips.

### Hotkey Behavior
- The default global hotkey is Control-Option-V.
- The hotkey is registered with Carbon `RegisterEventHotKey`.
- Pressing the hotkey calls the status item button's `performClick(nil)` on the main queue and sets an internal hotkey-menu flag.
- When a clip is selected while that flag is set, Clopy copies the clip and attempts automatic paste, then clears the flag.
- `Change Hotkey…` opens an `NSAlert` with an accessory view for key capture, not a popover.
- Captured hotkeys and reset-to-default values are stored in `UserDefaults` under `HotkeyKeyCode` and `HotkeyModifiers`.
- Hotkey registration failure is logged and shown with an alert titled `Hotkey Registration Failed`.

### Localization and Accessibility
- User-facing strings are currently English only.
- Menu items use readable text labels derived from clip content or fixed action titles.
- Automatic paste through CGEvent requires macOS Accessibility trust; Clopy checks trust and requests a system prompt through Accessibility APIs when needed.
- The status bar icon includes the accessibility description `Clopy`.

## 6) Functional Behavior

### Clipboard Monitoring
- `ClipboardManager` records the pasteboard's current `changeCount` at launch so existing pasteboard content is not captured immediately.
- Monitoring starts during `ClipboardManager` initialization.
- A repeating `Timer` checks `NSPasteboard.general.changeCount` every 0.5 seconds.
- When `changeCount` changes, the manager reads `NSPasteboard.general.string(forType: .string)`.
- Empty or whitespace-only strings are ignored.
- Non-empty strings are added to the beginning of the in-memory clip list unless another clip already has exactly the same `content` string.
- Duplicate text is ignored without moving the existing clip.

### Retention
- `maxItems` is currently a private constant set to 15.
- When adding a clip makes the list exceed 15 items, Clopy removes the oldest non-starred clip.
- If every clip is starred, Clopy allows the list to exceed 15 items rather than removing a starred clip.

### Selecting and Copying Clips
- Clip selection always first clears `NSPasteboard.general` and writes the clip content using `.string`.
- After a successful copy, `lastChangeCount` is updated to the pasteboard's new `changeCount` so Clopy does not immediately re-capture the selected clip.
- If `autoPaste` is false, no paste keystroke is attempted.
- If `autoPaste` is true, Clopy schedules automatic paste after a 0.1 second delay.

### Automatic Paste Attempt Order
1. If Accessibility permission is already trusted (`AXIsProcessTrusted()`), Clopy simulates Command-V with `CGEvent` keyboard events posted to `.cghidEventTap`.
2. If Accessibility permission is not already trusted, Clopy tries AppleScript through `System Events` to send Command-V.
3. If AppleScript fails, Clopy calls `AXIsProcessTrustedWithOptions` with the prompt option and delivers a user notification that says `Clip copied! Press ⌘V to paste`.
4. If permission is granted during that prompt check, Clopy retries the CGEvent paste after 0.5 seconds.

### Star and Delete Actions
- `starClip(_:)` and `unstarClip(_:)` update the matching clip's in-memory `isStarred` flag by `id`.
- `deleteClip(_:)` removes clips matching the selected clip `id`.
- `deleteAllClips()` removes only clips where `isStarred == false`.

## 7) Data Model

`Clip` is an in-memory Swift struct with:
- `id: UUID`
- `content: String`
- `createdAt: Date`
- `isStarred: Bool`, defaulting to `false`

`Clip` conforms to `Identifiable` and `Equatable`. Equality compares only `content`, although duplicate checks in the clipboard manager also compare `content` directly.

## 8) Technical Implementation

- Platform: macOS 13.0+.
- App lifecycle: SwiftUI `App` with AppKit managers and an empty Settings scene.
- UI: AppKit `NSStatusItem`, `NSMenu`, `NSMenuItem`, and `NSAlert`.
- Clipboard APIs: `NSPasteboard.general`, `.string`, and `changeCount` polling.
- Hotkey APIs: Carbon `RegisterEventHotKey`, `UnregisterEventHotKey`, and `InstallEventHandler`.
- Automatic paste APIs: Accessibility trust checks, `CGEvent`, `NSAppleScript`, and `NSUserNotification` fallback guidance.
- Logging: `OSLog` `Logger` with subsystem `com.clopy.app` and categories `App`, `ClipboardManager`, `StatusBarManager`, and `HotkeyManager`.
- Signing and sandboxing: the project references `Clopy.entitlements`, but its sandbox and clipboard entitlement keys are commented out, leaving no active entitlements.
- Bundle configuration: `Info.plist` sets `LSUIElement` to true and uses `AppIcon` as the bundle icon file.
- Swift project setting: `SWIFT_VERSION` is currently `5.0` in the Xcode project.

## 9) Distribution, Sandboxing, and App Store Considerations

- The current project configuration points at `Clopy.entitlements`, but active sandbox entitlement keys are absent because the sandbox-related keys are commented out.
- Current documentation and repository guidance treat the build as a direct/non-sandboxed testing build while automatic paste behavior is evaluated.
- The implementation uses public AppKit, Pasteboard, Carbon hotkey, Accessibility, CGEvent, AppleScript, and notification APIs.
- App Store suitability is not guaranteed by the current code because sandboxing is not active and automatic paste depends on Accessibility permission and OS review constraints.

## 10) Build and Validation Reality

- The repository currently has no automated test target.
- The expected project-inspection command is `xcodebuild -project Clopy.xcodeproj -list`.
- The expected unsigned Debug build command is:

```bash
xcodebuild -project Clopy.xcodeproj \
  -scheme Clopy \
  -configuration Debug \
  -derivedDataPath /tmp/clopy-derived-data \
  CODE_SIGNING_ALLOWED=NO \
  build
```

- Clipboard monitoring, global hotkeys, Accessibility permission, and automatic paste require manual validation in a real macOS desktop session.

## 11) Error Handling and Limitations

- Pasteboard read failures or missing string content are ignored and logged.
- Pasteboard write success and failure are logged.
- Hotkey registration failures are logged and shown to the user with an alert.
- The app relies on OS-level Accessibility, AppleScript, and notification behavior for automatic-paste fallback paths.
- Automatic paste requires a real macOS desktop session to validate.
- Clipboard monitoring, global hotkeys, Accessibility permission prompts, and paste simulation are not covered by automated tests in this repository.

## 12) Acceptance Criteria Matching the Current Code

- On launch, the app creates a menu bar status item and does not create a main window.
- Existing pasteboard content is not captured immediately on launch.
- Copying non-empty text in another app while Clopy is running adds it to the top of the menu within the 0.5-second polling interval.
- Copying text that exactly matches an existing clip does not add another clip and does not reorder the existing clip.
- Selecting a clip from a normal status bar interaction copies that clip to `NSPasteboard.general` for manual paste.
- Selecting a clip after opening the menu with the global hotkey copies the clip and attempts automatic paste.
- Starred clips show a `⭐ ` prefix and are preserved when retention is enforced.
- A single clip can be deleted immediately from the `Delete Clip` submenu.
- `Delete All Clips…` deletes only non-starred clips after confirmation and preserves starred clips.
- If all clips are starred, `Delete All Clips…` shows an informational alert and deletes nothing.
- The clip list normally keeps at most 15 items, but can exceed 15 when all retained clips are starred.
- The global hotkey can be changed or reset through `Change Hotkey…`, and those preferences persist in `UserDefaults`.
