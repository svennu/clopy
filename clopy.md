# Clopy – macOS Menu Bar Clipboard Selector (Specification)

Status: Testing Non-Sandboxed v2.2 • Owner: You • Target: Direct distribution (testing) • No tests required

## 1) Summary
A minimal macOS menu bar app that keeps an in-memory list of text clips captured when the user performs the system Copy (Cmd+C) while the app is running. From the status bar icon (and a keyboard shortcut), the user can:
- View all captured clips (text only)
- Open the list via a configurable global shortcut (default Control–Option–V) to quickly choose a clip; selection automatically pastes the content at the current cursor location (requires Accessibility permission). The list opens anchored to the status bar icon for easy keyboard selection.
- Star clips to prevent them from being automatically removed when new clips are added
- Delete a specific clip
- Delete all clips

No other features are included. Clips are not persisted to disk; they are cleared when the app quits.

## 2) Goals and Non‑Goals
- Goals
  - Text-only clipboard helper: clips are captured via the system Copy command (Cmd+C) and stored in memory
  - Fast, reliable way to choose from recently copied snippets and automatically paste them at cursor location; selection is presented via a configurable global shortcut (default Control–Option–V).
  - Simple UI entirely from the status bar menu; no main window
  - App Store‑suitable architecture
- Non‑Goals
  - Rich content types (RFT/RTF, images, files) — text only
  - Cloud sync, accounts, analytics
  - Editing clips’ content or adding via custom editors (clips are sourced from Cmd+C; only deletion is supported)
  - Rich text formatting, images, or files (text only)
  - Cloud sync, accounts, analytics
  - Editing clips' content or adding via custom editors

## 3) Scope
- In scope
  - Menu bar status item with menu listing all current in‑memory clips (most recent first)
  - Text only
  - Selecting a clip from status bar menu writes its content to the general pasteboard (public.utf8-plain-text) for manual pasting
  - Selecting a clip from hotkey menu automatically pastes the content at the current cursor location
  - Star/unstar clips to prevent automatic removal when new clips are added (in-memory only)
  - “Delete Clip” and “Delete All Clips…” management actions accessible from the status menu
  - Global keyboard shortcut to present the list for quick selection (see UX)
- Out of scope
  - Any windows beyond system dialogs/alerts for confirmations or an optional popover anchored to the status item
  - Search, tagging, reordering, or pinning beyond starring
  - Persistence to disk or any background services

## 4) Users and Primary Use Cases
- Users: macOS users who frequently reuse text snippets during a session
- Use cases
  1) Copy text in any app (Cmd+C); Clopy automatically captures it into the in‑memory list
  2) Choose a snippet from the menu bar (copies to pasteboard for manual Cmd+V) or hotkey menu (auto-pastes at cursor)
  3) Star important snippets to prevent them from being automatically removed
  4) Clean up the list by deleting a snippet
  5) Clear all snippets when no longer needed

## 5) UX Requirements
- App runs as a background status bar app (no Dock icon, no app menu). App is idendified and accessf from an icon in the status bar.
  - LSUIElement = 1
- Status bar icon is a template image/SF Symbol (monochrome) with proper light/dark mode support
- Menu layout
  - Section A: one menu item per clip (most recent first)
    - Display: show a clipped/trimmed version of the text (single‑line, middle‑truncated with ellipsis). Example: first 30 chars + … + last 20 chars; collapse newlines to spaces
    - Starred clips show with ⭐ prefix in their display text
    - Selecting a clip from status bar menu: sets its content (string) to NSPasteboard.general; user then pastes with Cmd+V
  - Separator
  - Section B: Management
    - "Star Clip" submenu listing non-starred clips; selecting stars the clip immediately
    - "Unstar Clip" submenu listing starred clips; selecting unstars the clip immediately
    - “Delete Clip” submenu listing each clip by its trimmed display; selecting deletes immediately (no confirmation), menu refreshes automatically
    - “Delete All Clips…” item triggers confirmation alert (Yes/Cancel)
  - Final separator (optional) and “Quit”
- Confirmations
  - “Delete All Clips…” requires confirmation
  - Single delete has no confirmation
- Keyboard shortcut
  - Provide a configurable global hotkey (default: Control‑Option‑V) that opens the status menu listing the current clips for keyboard navigation and selection; selecting a clip from hotkey menu automatically pastes it at cursor location (menu is opened programmatically via statusItem.button?.performClick(nil))
  - Changeable via a “Change Hotkey…” item in the status menu that opens a small capture popover; persisted in UserDefaults

## 6) Functional Requirements
1) Clipboard monitoring
   - Track NSPasteboard.general.changeCount; when it increments, read public.utf8-plain-text
   - If text exists, append it to the head of the in‑memory list
   - Dedup strategy: if the new text matches any existing item in the list, do not add another entry (no reordering)
   - Retention: maximum item count is internally configurable (default 15); drop oldest non-starred clips beyond the limit (FILO), starred clips are preserved
2) Listing clips
   - Menu shows current clips ordered by recency (most recent first)
   - Display string is derived (trimmed, single‑line, middle‑truncated)
3) Selecting a clip
   - From status bar menu: Writes plain string to NSPasteboard.general with type public.utf8-plain-text; user uses Cmd+V in the target app
   - From hotkey menu: Automatically pastes the content at the current cursor location using CGEvent keystroke simulation (falls back to AppleScript if permission not granted)
4) Star/unstar clips
   - Available via "Star Clip" and "Unstar Clip" submenus
   - Starred clips are preserved when new clips are added and the limit is reached
   - Updates in‑memory list and refreshes the menu immediately
   - Starred clips display with ⭐ prefix
5) Delete a specific clip
   - Available via “Delete Clip” submenu
   - Updates in‑memory list and refreshes the menu immediately
6) Delete all clips
   - Confirmation required
   - Clears in‑memory list and menu
7) Persistence
   - None; all data is in‑memory only and cleared on quit
   - Star state is also in-memory only and not persisted
8) Keyboard shortcut behavior
   - Register a global hotkey (RegisterEventHotKey or modern equivalent)
   - On trigger, programmatically open the status item’s menu (statusItem.button?.performClick(nil)) or show a minimal popover anchored to the status item
9) App lifecycle
   - Launch: create status item and menu; register hotkey; start pasteboard monitoring timer
   - Quit from menu; no data is saved

## 7) Data Model
- Clip (in‑memory)
  - id: UUID (string)
  - content: string (required)
  - createdAt: Date (for ordering)
  - isStarred: Bool (default false, prevents automatic removal)

## 8) Technical Specification
- Platform: macOS 13+ (Ventura) using SwiftUI MenuBarExtra, or AppKit NSStatusItem if preferred
- Language/Framework: Swift 5.9+, SwiftUI for structure; AppKit for NSPasteboard, NSStatusItem/NSMenu, and hotkey registration
- IDE/Build: Xcode 16.0+ (tested with 17.0)
- App Type: UIElement (agent) status bar app (LSUIElement = 1)
- Pasteboard: NSPasteboard.general, type public.utf8-plain-text only; monitor changeCount with a lightweight timer (e.g., 0.5–1.0s)
- Persistence: None (in‑memory session only)
- Icon: Template PDF or SF Symbol (e.g., "doc.on.clipboard")
- Signing/Sandbox: **TEMPORARILY DISABLED** for testing auto-paste functionality; may require Accessibility permission for CGEvent keystroke simulation
- Hotkey: RegisterEventHotKey‑based global shortcut (Control‑Option‑V) to open the menu; keyboard navigation within menu supported by macOS

## 9) App Store Considerations
- Uses public APIs (NSStatusItem, NSPasteboard, RegisterEventHotKey, CGEvent for keystroke simulation)
- Requires Accessibility permission for auto-paste functionality when using hotkey menu
- No private APIs, no analytics/tracking, no persistence of user content to disk
- Category: Productivity

## 10) Error Handling
- Pasteboard read failure: ignore and continue monitoring
- Hotkey registration failure: show minimal alert and continue without hotkey
- Any unexpected error: log (OSLog) and fail gracefully without crashing

## 11) Localization & Accessibility
- Localization: English only (initial)
- Accessibility: Menu items have clear, readable titles; supports light/dark mode; VoiceOver reads menu entries (trimmed content)

## 12) Acceptance Criteria
- Status bar icon appears on launch; no Dock icon
- Copying text in any app (Cmd+C) causes the text to appear at the top of Clopy’s menu list within ~1s
- Selecting a clip from status bar menu sets pasteboard content; user can paste it into TextEdit successfully with Cmd+V
- Selecting a clip from hotkey menu automatically pastes it at the current cursor location
- Deleting one clip removes it from the menu immediately
- “Delete All Clips…” clears the menu after confirmation
- Configurable global hotkey (default Control‑Option‑V) opens the list for keyboard selection
- Duplicate copies of an existing clip are ignored (no new entry and no reordering)
- The list never exceeds the configured max items (default 15)
- App remains within scope (no extra features)

## 13) Open Questions
- Max items: internally configurable; default 15
- Duplicates: if copied text already exists in memory, do not add another entry (no reordering)
- Hotkey: configurable via “Change Hotkey…” in the status menu; default Control‑Option‑V

## 14) Delivery Notes for Developer
- Create a new Xcode project (App, SwiftUI). Set LSUIElement = 1 in Info.plist
- Implement status item and NSMenu (or MenuBarExtra) bound to in‑memory model
- Implement pasteboard monitor (timer + changeCount) and in‑memory FIFO store with configurable maxItems (default 15)
- Implement RegisterEventHotKey reading the shortcut from UserDefaults; provide a minimal “Change Hotkey…” capture popover and persist updates
- Keep code minimal; no tests required as per scope

## 15) Implementation Status ✅
- ✅ Max items: implemented with configurable default 15
- ✅ Duplicates: implemented - existing text is not re-added (no reordering)
- ✅ Hotkey: implemented - configurable via "Change Hotkey…" in status menu; default Control‑Option‑V
- ✅ All core features implemented and functional
- ✅ App builds successfully and runs as menu bar app
- ✅ Clipboard monitoring, clip management, and hotkey system working

## 16) Implementation Complete ✅
- ✅ **FIXED**: Added missing `com.apple.security.device.clipboard` entitlement to enable pasteboard write access in App Sandbox
- ✅ **FIXED**: Improved error handling in ClipboardManager with success/failure logging
- ✅ **IMPLEMENTED**: Auto-paste functionality for hotkey menu selections
- ✅ **IMPLEMENTED**: Accessibility permission request and handling with user-friendly dialogs
- ✅ **IMPLEMENTED**: CGEvent-based keystroke simulation for Cmd+V
- ✅ **IMPLEMENTED**: Dual behavior - status bar menu (copy only) vs hotkey menu (auto-paste)
- ✅ **IMPLEMENTED**: Comprehensive fallback system with notifications

## 17) Final Technical Implementation
**Auto-Paste System:**
- **Primary Method**: CGEvent keystroke simulation (requires Accessibility permission)
- **Fallback Method**: AppleScript keystroke simulation (limited compatibility)
- **Final Fallback**: User notification with manual paste instruction
- **Permission Handling**: Automatic permission request with System Preferences integration

**Dual Menu Behavior:**
- **Status Bar Menu**: Click clip → Copy to pasteboard → User presses Cmd+V manually
- **Hotkey Menu**: Control+Option+V → Select clip → **Automatic paste at cursor location**

**User Experience:**
- First-time auto-paste triggers Accessibility permission request
- Clear guidance to System Preferences → Privacy & Security → Accessibility
- Graceful degradation if permission denied
- Comprehensive logging for debugging

## 18) App Store Considerations Updated
- ✅ Uses only public APIs (NSStatusItem, NSPasteboard, RegisterEventHotKey, CGEvent, AXIsProcessTrusted)
- ✅ Requires Accessibility permission for auto-paste (clearly documented)
- ✅ Graceful fallback when permission denied
- ✅ No private APIs, no analytics/tracking, no persistence of user content to disk
- ✅ Category: Productivity
- ⚠️ **Note**: App Store review may require explanation of Accessibility permission usage

## 19) Testing Phase - Sandboxing Disabled 🧪
**Current Status: Testing auto-paste functionality without sandbox restrictions**

The application is **fully functional for testing**:
- ✅ Clipboard monitoring across different applications
- ✅ Hotkey registration and menu opening
- ✅ Clip management and deletion
- ✅ **Auto-paste functionality testing** (without sandbox restrictions)
- 🧪 **Testing if CGEvent/AppleScript works better without sandboxing**
- 🧪 **Evaluating Accessibility permission requirements**

## 20) Star Feature Implementation ⭐
**Status: Implemented**

**Feature Overview:**
- Users can star clips to prevent them from being automatically removed when new clips are added
- Starred clips display with ⭐ prefix in the menu
- Star state is in-memory only and not persisted to disk
- Starred clips are preserved even when the 15-item limit is reached

**Implementation Details:**
- Added `isStarred: Bool` property to `Clip` struct
- Modified removal logic to only remove non-starred clips when at capacity
- Added "Star Clip" and "Unstar Clip" submenus in the status bar menu
- Updated `displayText` to show ⭐ prefix for starred clips
- If all clips are starred, the app allows exceeding the 15-item limit temporarily

**User Experience:**
- Star/unstar actions are available via submenus (similar to "Delete Clip")
- Starred clips remain in chronological order (most recent first)
- Visual distinction with ⭐ prefix makes starred clips easy to identify
- No confirmation required for starring/unstarring (immediate action)

## 21) Next Steps After Testing
**If auto-paste works without sandboxing:**
- Document the trade-offs (security vs functionality)
- Decide between sandboxed (App Store) vs non-sandboxed (direct distribution)
- Update final specification based on test results

**If auto-paste still doesn't work:**
- Investigate alternative approaches (menu bar integration, different APIs)
- Consider simplified UX (copy + notification approach)
- Re-evaluate auto-paste feasibility on macOS




