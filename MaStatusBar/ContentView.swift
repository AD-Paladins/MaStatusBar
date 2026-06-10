import Combine
import ServiceManagement
import SwiftUI

@main struct MaStatusBar: App {
    
    @AppStorage("isFeatureEnabled") private var isFeatureEnabled = true
    @AppStorage("isAnimationEnabled") private var isAnimationEnabled = false
    @State private var statusWindow: NSWindow?

    init() {
        let isRegistered = SMAppService.mainApp.status == .enabled
        UserDefaults.standard.set(isRegistered, forKey: "launchAtLogin")
    }
    
    var body: some Scene {
        WindowGroup {
            AnimatedBarView(isFeatureEnabled: $isFeatureEnabled, isAnimationEnabled: $isAnimationEnabled)
                .background(
                    WindowAccessor { window in
                        statusWindow = window
                        configureStatusBar(window)
                    }
                )
                .onReceive(
                    NotificationCenter.default.publisher(for: NSApplication.didChangeScreenParametersNotification)
                ) { _ in
                    configureStatusBar(statusWindow)
                }
        }
        
        // 2. The Native Settings Window Scene
        Settings {
            SettingsView()
        }
        
        // 3. The Status Bar / Menu Bar Extra
        MenuBarExtra {
            Toggle("Show Status Bar", isOn: $isFeatureEnabled)
            Toggle("Start/Stop Animation", isOn: $isAnimationEnabled)
            SettingsLink {
                Label("Settings...", systemImage: "gearshape")
            }
            .keyboardShortcut(",")
            
            Divider()
            Button("Quit") { NSApplication.shared.terminate(nil) }
        } label: {
            Image(systemName: isFeatureEnabled ? "checkmark.circle.fill" : "circle")
        }
    }
    
    private func configureStatusBar(_ window: NSWindow?) {
        guard let window else { return }
        
        window.level = .mainMenu
        window.backgroundColor = .clear
        window.isOpaque = false
        window.hasShadow = false
        window.styleMask = [.borderless]
        window.ignoresMouseEvents = true
        window.isMovable = false
        
        window.collectionBehavior = [
            .canJoinAllSpaces,
            .stationary,
            .ignoresCycle
        ]
        
        positionBarOnScreen(window)
    }
    
    private func positionBarOnScreen(_ window: NSWindow) {
        guard let screenFrame = (window.screen ?? NSScreen.main)?.frame else { return }
        let barHeight: CGFloat = 28
        window.setFrame(
            NSRect(
                x: screenFrame.minX,
                y: screenFrame.maxY - barHeight,
                width: screenFrame.width,
                height: barHeight
            ),
            display: true
        )
    }
}

// Un helper clásico para acceder al NSWindow nativo desde SwiftUI
struct WindowAccessor: NSViewRepresentable {
    let callback: (NSWindow?) -> Void

    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        Task { @MainActor in
            callback(view.window)
        }
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {}
}


#Preview {
    AnimatedBarView(isFeatureEnabled: .constant(false), isAnimationEnabled: .constant(false))
}
