import Foundation
import AppKit
import ApplicationServices
import OSLog

/// Manages clipboard monitoring and clip storage
class ClipboardManager: ObservableObject {
    @Published var clips: [Clip] = []

    private var lastChangeCount: Int = 0
    private var timer: Timer?
    private let maxItems: Int = 15
    private let logger = Logger(subsystem: "com.clopy.app", category: "ClipboardManager")

    init() {
        // Start with current clipboard count to avoid capturing existing content
        lastChangeCount = NSPasteboard.general.changeCount
        startMonitoring()
    }
    
    deinit {
        stopMonitoring()
    }
    
    /// Start monitoring the clipboard for changes
    func startMonitoring() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            self?.checkClipboard()
        }
        logger.info("Started clipboard monitoring")
    }

    /// Stop monitoring the clipboard
    func stopMonitoring() {
        timer?.invalidate()
        timer = nil
        logger.info("Stopped clipboard monitoring")
    }
    
    /// Check if clipboard has changed and capture new content
    private func checkClipboard() {
        let currentChangeCount = NSPasteboard.general.changeCount

        guard currentChangeCount != lastChangeCount else { return }

        logger.info("Clipboard change detected: \(self.lastChangeCount) → \(currentChangeCount)")
        lastChangeCount = currentChangeCount
        
        guard let string = NSPasteboard.general.string(forType: .string),
              !string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            logger.info("No valid string content found in clipboard")
            return
        }
        
        addClip(content: string)
    }
    
    /// Add a new clip to the collection
    private func addClip(content: String) {
        let newClip = Clip(content: content)

        // Check for duplicates - don't add if content already exists
        guard !clips.contains(where: { $0.content == content }) else {
            logger.debug("Duplicate clip ignored: \(content.prefix(50))")
            return
        }

        // Ensure UI updates happen on the main thread
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            // Add to the beginning of the array (most recent first)
            self.clips.insert(newClip, at: 0)

            // Maintain maximum item count, but preserve starred clips
            if self.clips.count > self.maxItems {
                // Find the oldest non-starred clip to remove
                if let indexToRemove = self.clips.lastIndex(where: { !$0.isStarred }) {
                    let removedClip = self.clips.remove(at: indexToRemove)
                    self.logger.info("Removed oldest non-starred clip to maintain limit: \(removedClip.content.prefix(50))")
                } else {
                    // All clips are starred, allow exceeding the limit
                    self.logger.info("All clips are starred, allowing to exceed limit. Current count: \(self.clips.count)")
                }
            }

            self.logger.info("Added new clip: \(content.prefix(50))")
        }
    }
    
    /// Copy a clip's content to the clipboard
    func copyClip(_ clip: Clip) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()

        let success = pasteboard.setString(clip.content, forType: .string)

        if success {
            // Update our change count to avoid re-capturing this content
            lastChangeCount = pasteboard.changeCount
            logger.info("Successfully copied clip to pasteboard: \(clip.content.prefix(50))")
        } else {
            logger.error("Failed to copy clip to pasteboard: \(clip.content.prefix(50))")
        }
    }
    
    /// Delete a specific clip
    func deleteClip(_ clip: Clip) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.clips.removeAll { $0.id == clip.id }
            self.logger.info("Deleted clip: \(clip.content.prefix(50))")
        }
    }

    /// Delete all clips
    func deleteAllClips() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.clips.removeAll()
            self.logger.info("Deleted all clips")
        }
    }

    /// Star a specific clip
    func starClip(_ clip: Clip) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if let index = self.clips.firstIndex(where: { $0.id == clip.id }) {
                self.clips[index].isStarred = true
                self.logger.info("Starred clip: \(clip.content.prefix(50))")
            }
        }
    }

    /// Unstar a specific clip
    func unstarClip(_ clip: Clip) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if let index = self.clips.firstIndex(where: { $0.id == clip.id }) {
                self.clips[index].isStarred = false
                self.logger.info("Unstarred clip: \(clip.content.prefix(50))")
            }
        }
    }

    /// Copy a clip and optionally auto-paste it
    func selectClip(_ clip: Clip, autoPaste: Bool = false) {
        // First copy to pasteboard
        copyClip(clip)

        // If auto-paste is requested, try different approaches
        if autoPaste {
            logger.info("automatically pasting...")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.attemptAutoPaste()
            }
        } else {
            logger.info("not automatically pasting")
        }
    }

    /// Attempt auto-paste using the best available method
    private func attemptAutoPaste() {
        logger.info("Attempting auto-paste...")

        // Try CGEvent approach if we have Accessibility permission
        if hasAccessibilityPermission() {
            logger.info("Using CGEvent approach")
            simulatePaste()
            return
        }

        // Try AppleScript approach as fallback
        logger.info("Trying AppleScript approach...")
        if tryAppleScriptPaste() {
            return
        }

        // Request permission and show notification as final fallback
        logger.info("Auto-paste failed, requesting permission and showing notification")
        requestAccessibilityPermissionForPaste()
        showPasteNotification()
    }

    /// Try to paste using AppleScript
    private func tryAppleScriptPaste() -> Bool {
        let script = """
        tell application "System Events"
            keystroke "v" using command down
        end tell
        """

        var error: NSDictionary?
        if let scriptObject = NSAppleScript(source: script) {
            scriptObject.executeAndReturnError(&error)
            if error == nil {
                logger.info("AppleScript paste executed successfully")
                return true
            } else {
                logger.warning("AppleScript paste failed: \(error?.description ?? "unknown error")")
            }
        }

        return false
    }

    /// Show a notification to guide user to paste manually
    private func showPasteNotification() {
        DispatchQueue.main.async {
            let notification = NSUserNotification()
            notification.title = "Clopy"
            notification.informativeText = "Clip copied! Press ⌘V to paste"
            notification.soundName = NSUserNotificationDefaultSoundName

            NSUserNotificationCenter.default.deliver(notification)
            self.logger.info("Showed paste notification to user")
        }
    }

    /// Check if Accessibility permission is available
    private func hasAccessibilityPermission() -> Bool {
        return AXIsProcessTrusted()
    }

    /// Request Accessibility permission for paste functionality
    private func requestAccessibilityPermissionForPaste() {
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue(): true] as CFDictionary
        let hasPermission = AXIsProcessTrustedWithOptions(options)

        if hasPermission {
            logger.info("Accessibility permission granted, retrying paste")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.simulatePaste()
            }
        } else {
            logger.info("Accessibility permission not granted")
        }
    }



    /// Simulate Cmd+V keystroke to paste content (requires Accessibility permission)
    private func simulatePaste() {
        guard hasAccessibilityPermission() else {
            logger.warning("Cannot simulate paste: no Accessibility permission")
            return
        }

        // Create Cmd+V key events (virtual key 9 = 'V')
        guard let cmdVDown = CGEvent(keyboardEventSource: nil, virtualKey: 9, keyDown: true),
              let cmdVUp = CGEvent(keyboardEventSource: nil, virtualKey: 9, keyDown: false) else {
            logger.error("Failed to create keyboard events")
            return
        }

        // Set Command modifier flag
        cmdVDown.flags = .maskCommand
        cmdVUp.flags = .maskCommand

        // Post the events
        cmdVDown.post(tap: .cghidEventTap)
        cmdVUp.post(tap: .cghidEventTap)

        logger.info("Successfully simulated Cmd+V paste using CGEvent")
    }
}
