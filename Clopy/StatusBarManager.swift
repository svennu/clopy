import AppKit
import SwiftUI
import Combine
import OSLog

/// Manages the status bar item and menu
class StatusBarManager: ObservableObject {
    private var statusItem: NSStatusItem?
    private let clipboardManager: ClipboardManager
    private let hotkeyManager: HotkeyManager
    private let logger = Logger(subsystem: "com.clopy.app", category: "StatusBarManager")
    private var cancellables = Set<AnyCancellable>()

    // Track menu selection context
    private var isHotkeyMenuActive: Bool = false
    
    init(clipboardManager: ClipboardManager, hotkeyManager: HotkeyManager) {
        self.clipboardManager = clipboardManager
        self.hotkeyManager = hotkeyManager
        setupStatusItem()

        // Set up hotkey callback
        hotkeyManager.onHotkeyPressed = { [weak self] in
            self?.openHotkeyMenu()
        }

        // Update menu when clips change
        clipboardManager.$clips
            .receive(on: DispatchQueue.main)
            .sink { [weak self] clips in
                self?.logger.info("Clips changed, updating menu. Count: \(clips.count)")
                self?.updateMenu()
            }.store(in: &cancellables)
    }
    
    deinit {
        statusItem = nil
    }
    
    /// Set up the status bar item
    private func setupStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        
        guard let statusItem = statusItem else {
            logger.error("Failed to create status item")
            return
        }
        
        // Set up the button
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "doc.on.clipboard", accessibilityDescription: "Clopy")
            button.image?.isTemplate = true
            button.toolTip = "Clopy - Clipboard Manager"
        }
        
        updateMenu()
        logger.info("Status bar item created")
    }
    
    /// Update the menu with current clips
    func updateMenu() {
        guard let statusItem = statusItem else {
            logger.error("StatusItem is nil, cannot update menu")
            return
        }

        logger.info("Updating menu with \(self.clipboardManager.clips.count) clips")

        let menu = NSMenu()

        // Section A: Clips
        if self.clipboardManager.clips.isEmpty {
            logger.info("No clips available, showing 'No clips' item")
            let noClipsItem = NSMenuItem(title: "No clips", action: nil, keyEquivalent: "")
            noClipsItem.isEnabled = false
            menu.addItem(noClipsItem)
        } else {
            logger.info("Adding \(self.clipboardManager.clips.count) clips to menu")
            for clip in self.clipboardManager.clips {
                let menuItem = NSMenuItem(title: clip.displayText, action: #selector(clipSelected(_:)), keyEquivalent: "")
                menuItem.target = self
                menuItem.representedObject = clip
                menu.addItem(menuItem)
                logger.debug("Added menu item: \(clip.displayText)")
            }
        }
        
        // Separator
        menu.addItem(NSMenuItem.separator())
        
        // Section B: Management
        if !clipboardManager.clips.isEmpty {
            // Star Clip submenu (only show if there are non-starred clips)
            let nonStarredClips = clipboardManager.clips.filter { !$0.isStarred }
            if !nonStarredClips.isEmpty {
                let starClipItem = NSMenuItem(title: "Star Clip", action: nil, keyEquivalent: "")
                let starSubmenu = NSMenu()

                for clip in nonStarredClips {
                    let starItem = NSMenuItem(title: clip.displayText, action: #selector(starClipSelected(_:)), keyEquivalent: "")
                    starItem.target = self
                    starItem.representedObject = clip
                    starSubmenu.addItem(starItem)
                }

                starClipItem.submenu = starSubmenu
                menu.addItem(starClipItem)
            }

            // Unstar Clip submenu (only show if there are starred clips)
            let starredClips = clipboardManager.clips.filter { $0.isStarred }
            if !starredClips.isEmpty {
                let unstarClipItem = NSMenuItem(title: "Unstar Clip", action: nil, keyEquivalent: "")
                let unstarSubmenu = NSMenu()

                for clip in starredClips {
                    let unstarItem = NSMenuItem(title: clip.displayText, action: #selector(unstarClipSelected(_:)), keyEquivalent: "")
                    unstarItem.target = self
                    unstarItem.representedObject = clip
                    unstarSubmenu.addItem(unstarItem)
                }

                unstarClipItem.submenu = unstarSubmenu
                menu.addItem(unstarClipItem)
            }

            // Delete Clip submenu
            let deleteClipItem = NSMenuItem(title: "Delete Clip", action: nil, keyEquivalent: "")
            let deleteSubmenu = NSMenu()

            for clip in clipboardManager.clips {
                let deleteItem = NSMenuItem(title: clip.displayText, action: #selector(deleteClipSelected(_:)), keyEquivalent: "")
                deleteItem.target = self
                deleteItem.representedObject = clip
                deleteSubmenu.addItem(deleteItem)
            }

            deleteClipItem.submenu = deleteSubmenu
            menu.addItem(deleteClipItem)

            // Delete All Clips
            let deleteAllItem = NSMenuItem(title: "Delete All Clips…", action: #selector(deleteAllClips), keyEquivalent: "")
            deleteAllItem.target = self
            menu.addItem(deleteAllItem)

            menu.addItem(NSMenuItem.separator())
        }
        
        // Change Hotkey
        let changeHotkeyItem = NSMenuItem(title: "Change Hotkey…", action: #selector(changeHotkey), keyEquivalent: "")
        changeHotkeyItem.target = self
        menu.addItem(changeHotkeyItem)

        menu.addItem(NSMenuItem.separator())
        
        // Quit
        let quitItem = NSMenuItem(title: "Quit", action: #selector(quit), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)
        
        statusItem.menu = menu
        logger.info("Menu updated and assigned to status item")
    }
    
    /// Open the menu programmatically (for hotkey) with auto-paste context
    func openHotkeyMenu() {
        isHotkeyMenuActive = true
        DispatchQueue.main.async { [weak self] in
            self?.statusItem?.button?.performClick(nil)
        }
    }

    /// Open the menu normally (status bar click) with copy-only context
    func openStatusBarMenu() {
        isHotkeyMenuActive = false
        // Normal menu opening happens automatically when user clicks status bar
    }
    
    // MARK: - Menu Actions
    
    @objc private func clipSelected(_ sender: NSMenuItem) {
        guard let clip = sender.representedObject as? Clip else { return }

        // Determine behavior based on menu context
        let shouldAutoPaste = isHotkeyMenuActive

        // Reset context after selection
        isHotkeyMenuActive = false

        // Use the new selectClip method with context-aware behavior
        clipboardManager.selectClip(clip, autoPaste: shouldAutoPaste)
    }
    
    @objc private func starClipSelected(_ sender: NSMenuItem) {
        guard let clip = sender.representedObject as? Clip else { return }
        clipboardManager.starClip(clip)
        updateMenu()
    }

    @objc private func unstarClipSelected(_ sender: NSMenuItem) {
        guard let clip = sender.representedObject as? Clip else { return }
        clipboardManager.unstarClip(clip)
        updateMenu()
    }

    @objc private func deleteClipSelected(_ sender: NSMenuItem) {
        guard let clip = sender.representedObject as? Clip else { return }
        clipboardManager.deleteClip(clip)
        updateMenu()
    }
    
    @objc private func deleteAllClips() {
        let alert = NSAlert()
        alert.messageText = "Delete All Clips"
        alert.informativeText = "Are you sure you want to delete all clips? This action cannot be undone."
        alert.alertStyle = .warning
        alert.addButton(withTitle: "Delete All")
        alert.addButton(withTitle: "Cancel")
        
        let response = alert.runModal()
        if response == .alertFirstButtonReturn {
            clipboardManager.deleteAllClips()
            updateMenu()
        }
    }
    
    @objc private func changeHotkey() {
        hotkeyManager.showHotkeyChangeDialog()
    }

    @objc private func quit() {
        NSApplication.shared.terminate(nil)
    }
}
