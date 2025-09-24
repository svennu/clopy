import Foundation
import AppKit
import Carbon
import OSLog

/// Manages global hotkey registration and handling
class HotkeyManager: ObservableObject {
    private var hotKeyRef: EventHotKeyRef?
    private let hotkeyID: EventHotKeyID = EventHotKeyID(signature: OSType(0x434C4F50), id: 1) // 'CLOP'
    private let logger = Logger(subsystem: "com.clopy.app", category: "HotkeyManager")
    
    // Default hotkey: Control + Option + V
    private let defaultKeyCode: UInt32 = 9 // V key
    private let defaultModifiers: UInt32 = UInt32(controlKey | optionKey)
    
    var onHotkeyPressed: (() -> Void)?
    
    init() {
        registerHotkey()
        installEventHandler()
    }
    
    deinit {
        unregisterHotkey()
    }
    
    /// Register the global hotkey
    private func registerHotkey() {
        let keyCode = UserDefaults.standard.object(forKey: "HotkeyKeyCode") as? UInt32 ?? defaultKeyCode
        let modifiers = UserDefaults.standard.object(forKey: "HotkeyModifiers") as? UInt32 ?? defaultModifiers
        
        let status = RegisterEventHotKey(keyCode, modifiers, hotkeyID, GetApplicationEventTarget(), 0, &hotKeyRef)
        
        if status == noErr {
            logger.info("Hotkey registered successfully")
        } else {
            logger.error("Failed to register hotkey: \(status)")
            showHotkeyRegistrationError()
        }
    }
    
    /// Unregister the global hotkey
    private func unregisterHotkey() {
        if let hotKeyRef = hotKeyRef {
            UnregisterEventHotKey(hotKeyRef)
            self.hotKeyRef = nil
            logger.info("Hotkey unregistered")
        }
    }
    
    /// Install the Carbon event handler
    private func installEventHandler() {
        var eventType = EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: OSType(kEventHotKeyPressed))
        
        InstallEventHandler(GetApplicationEventTarget(), { (nextHandler, theEvent, userData) -> OSStatus in
            var hotKeyID = EventHotKeyID()
            GetEventParameter(theEvent, OSType(kEventParamDirectObject), OSType(typeEventHotKeyID), nil, MemoryLayout<EventHotKeyID>.size, nil, &hotKeyID)
            
            if let manager = Unmanaged<HotkeyManager>.fromOpaque(userData!).takeUnretainedValue() as HotkeyManager? {
                if hotKeyID.signature == manager.hotkeyID.signature && hotKeyID.id == manager.hotkeyID.id {
                    DispatchQueue.main.async {
                        manager.onHotkeyPressed?()
                    }
                }
            }
            
            return noErr
        }, 1, &eventType, Unmanaged.passUnretained(self).toOpaque(), nil)
    }
    
    /// Show hotkey change dialog
    func showHotkeyChangeDialog() {
        let alert = NSAlert()
        alert.messageText = "Change Hotkey"
        let currentHotkeyString = getCurrentHotkeyDisplayString()
        alert.informativeText = "Press the new key combination you want to use for opening Clopy.\n\nCurrent: \(currentHotkeyString)"
        alert.alertStyle = .informational
        alert.addButton(withTitle: "Cancel")
        alert.addButton(withTitle: "Reset to Default")
        
        // Create a custom view for key capture
        let containerView = NSView(frame: NSRect(x: 0, y: 0, width: 300, height: 60))
        let textField = NSTextField(frame: NSRect(x: 10, y: 20, width: 280, height: 22))
        textField.stringValue = "Press new key combination..."
        textField.isEditable = false
        textField.isBordered = true
        textField.backgroundColor = NSColor.controlBackgroundColor
        containerView.addSubview(textField)
        
        alert.accessoryView = containerView
        
        // Set up key monitoring
        var keyMonitor: Any?
        var capturedKeyCode: UInt32?
        var capturedModifiers: UInt32?

        keyMonitor = NSEvent.addLocalMonitorForEvents(matching: [.keyDown, .flagsChanged]) { [weak self] event in
            guard let self = self else { return event }

            if event.type == .keyDown && !event.modifierFlags.intersection([.control, .option, .command, .shift]).isEmpty {
                let keyCode = event.keyCode
                let modifiers = event.modifierFlags.intersection([.control, .option, .command, .shift])

                textField.stringValue = self.formatKeyCombo(keyCode: UInt32(keyCode), modifiers: modifiers)

                // Store the captured values
                capturedKeyCode = UInt32(keyCode)
                capturedModifiers = self.convertModifiers(modifiers)

                // Close the dialog after a short delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if let monitor = keyMonitor {
                        NSEvent.removeMonitor(monitor)
                        keyMonitor = nil
                    }
                    NSApp.stopModal()
                }

                return nil // Consume the event
            }
            return event
        }

        let response = alert.runModal()

        // Clean up monitor if still active
        if let monitor = keyMonitor {
            NSEvent.removeMonitor(monitor)
        }

        // Apply the captured hotkey if one was set
        if let keyCode = capturedKeyCode, let modifiers = capturedModifiers {
            updateHotkey(keyCode: keyCode, modifiers: modifiers)
        }
        
        if response == .alertSecondButtonReturn {
            // Reset to default
            updateHotkey(keyCode: defaultKeyCode, modifiers: defaultModifiers)
        }
    }
    
    /// Update the hotkey with new values
    private func updateHotkey(keyCode: UInt32, modifiers: UInt32) {
        unregisterHotkey()
        
        UserDefaults.standard.set(keyCode, forKey: "HotkeyKeyCode")
        UserDefaults.standard.set(modifiers, forKey: "HotkeyModifiers")
        
        registerHotkey()
    }
    
    /// Convert NSEvent modifiers to Carbon modifiers
    private func convertModifiers(_ modifiers: NSEvent.ModifierFlags) -> UInt32 {
        var carbonModifiers: UInt32 = 0
        
        if modifiers.contains(.control) {
            carbonModifiers |= UInt32(controlKey)
        }
        if modifiers.contains(.option) {
            carbonModifiers |= UInt32(optionKey)
        }
        if modifiers.contains(.command) {
            carbonModifiers |= UInt32(cmdKey)
        }
        if modifiers.contains(.shift) {
            carbonModifiers |= UInt32(shiftKey)
        }
        
        return carbonModifiers
    }
    
    /// Format key combination for display
    private func formatKeyCombo(keyCode: UInt32, modifiers: NSEvent.ModifierFlags) -> String {
        var result = ""
        
        if modifiers.contains(.control) { result += "⌃" }
        if modifiers.contains(.option) { result += "⌥" }
        if modifiers.contains(.command) { result += "⌘" }
        if modifiers.contains(.shift) { result += "⇧" }
        
        // Convert key code to character
        let keyChar = self.keyCodeToString(keyCode)
        result += keyChar
        
        return result
    }
    
    /// Convert key code to string representation
    private func keyCodeToString(_ keyCode: UInt32) -> String {
        let keyMap: [UInt32: String] = [
            0: "A", 1: "S", 2: "D", 3: "F", 4: "H", 5: "G", 6: "Z", 7: "X", 8: "C", 9: "V",
            11: "B", 12: "Q", 13: "W", 14: "E", 15: "R", 16: "Y", 17: "T", 18: "1", 19: "2",
            20: "3", 21: "4", 22: "6", 23: "5", 24: "=", 25: "9", 26: "7", 27: "-", 28: "8",
            29: "0", 30: "]", 31: "O", 32: "U", 33: "[", 34: "I", 35: "P", 37: "L", 38: "J",
            39: "'", 40: "K", 41: ";", 42: "\\", 43: ",", 44: "/", 45: "N", 46: "M", 47: ".",
            50: "`", 65: ".", 67: "*", 69: "+", 71: "⌧", 75: "/", 76: "↩", 78: "-", 81: "=",
            82: "0", 83: "1", 84: "2", 85: "3", 86: "4", 87: "5", 88: "6", 89: "7", 91: "8",
            92: "9", 96: "F5", 97: "F6", 98: "F7", 99: "F3", 100: "F8", 101: "F9", 103: "F11",
            109: "F10", 111: "F12", 113: "F13", 114: "Help", 115: "Home", 116: "⇞", 117: "⌦",
            118: "F4", 119: "End", 120: "F2", 121: "⇟", 122: "F1", 123: "←", 124: "→", 125: "↓", 126: "↑"
        ]
        
        return keyMap[keyCode] ?? "?"
    }
    
    /// Get current hotkey as display string
    private func getCurrentHotkeyDisplayString() -> String {
        let keyCode = UserDefaults.standard.object(forKey: "HotkeyKeyCode") as? UInt32 ?? defaultKeyCode
        let modifiers = UserDefaults.standard.object(forKey: "HotkeyModifiers") as? UInt32 ?? defaultModifiers

        var modifierString = ""
        if modifiers & UInt32(controlKey) != 0 { modifierString += "⌃" }
        if modifiers & UInt32(optionKey) != 0 { modifierString += "⌥" }
        if modifiers & UInt32(shiftKey) != 0 { modifierString += "⇧" }
        if modifiers & UInt32(cmdKey) != 0 { modifierString += "⌘" }

        // Convert keyCode to character (simplified mapping)
        let keyString: String
        switch keyCode {
        case 9: keyString = "V"
        case 0: keyString = "A"
        case 11: keyString = "B"
        case 8: keyString = "C"
        case 2: keyString = "D"
        case 14: keyString = "E"
        case 3: keyString = "F"
        case 5: keyString = "G"
        case 4: keyString = "H"
        case 34: keyString = "I"
        case 38: keyString = "J"
        case 40: keyString = "K"
        case 37: keyString = "L"
        case 46: keyString = "M"
        case 45: keyString = "N"
        case 31: keyString = "O"
        case 35: keyString = "P"
        case 12: keyString = "Q"
        case 15: keyString = "R"
        case 1: keyString = "S"
        case 17: keyString = "T"
        case 32: keyString = "U"
        case 7: keyString = "W"
        case 16: keyString = "X"
        case 6: keyString = "Y"
        case 13: keyString = "Z"
        case 36: keyString = "Return"
        case 49: keyString = "Space"
        case 53: keyString = "Escape"
        default: keyString = "Key\(keyCode)"
        }

        return modifierString + keyString
    }

    /// Show error when hotkey registration fails
    private func showHotkeyRegistrationError() {
        DispatchQueue.main.async {
            let alert = NSAlert()
            alert.messageText = "Hotkey Registration Failed"
            alert.informativeText = "Could not register the global hotkey. Another application might be using the same key combination."
            alert.alertStyle = .warning
            alert.addButton(withTitle: "OK")
            alert.runModal()
        }
    }
}
