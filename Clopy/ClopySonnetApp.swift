import SwiftUI
import AppKit
import OSLog

@main
struct ClopySonnetApp: App {
    @StateObject private var clipboardManager = ClipboardManager()
    @StateObject private var hotkeyManager = HotkeyManager()
    @StateObject private var statusBarManager: StatusBarManager

    private let logger = Logger(subsystem: "com.clopy.app", category: "App")

    init() {
        let clipboardManager = ClipboardManager()
        let hotkeyManager = HotkeyManager()
        let statusBarManager = StatusBarManager(clipboardManager: clipboardManager, hotkeyManager: hotkeyManager)

        self._clipboardManager = StateObject(wrappedValue: clipboardManager)
        self._hotkeyManager = StateObject(wrappedValue: hotkeyManager)
        self._statusBarManager = StateObject(wrappedValue: statusBarManager)

        logger.info("Clopy app initialized")
    }
    
    var body: some Scene {
        // We don't need a window scene since this is a menu bar app
        // The app runs entirely from the status bar
        Settings {
            EmptyView()
        }
    }
}
