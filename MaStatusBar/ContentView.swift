import SwiftUI

@main struct MaStatusBar: App {
    
    @AppStorage("isFeatureEnabled") private var isFeatureEnabled = false
    
    var body: some Scene {
        WindowGroup {
            AnimatedBarView(isFeatureEnabled: $isFeatureEnabled)
                .background(
                    WindowAccessor { window in
                        guard let window else { return }
                        
                        // Apariencia
                        window.level = .mainMenu
                        window.backgroundColor = .clear
                        window.isOpaque = false
                        window.hasShadow = false
                        window.styleMask = [.borderless]
                        
                        // Comportamiento
                        window.ignoresMouseEvents = true
                        window.isMovable = false
                        
                        window.collectionBehavior = [
                            .canJoinAllSpaces,
                            .stationary,
                            .ignoresCycle
                        ]
                        
                        if let screen = window.screen ?? NSScreen.main {
                            let screenFrame = screen.frame
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
                )
        }
        
        // 2. The Native Settings Window Scene
        Settings {
            SettingsView() // The view that will display inside the settings window
        }
        
        // 3. The Status Bar / Menu Bar Extra
        MenuBarExtra {
            Toggle("Feature Status", isOn: $isFeatureEnabled)
            // 4. The magic button that opens the Settings scene
            SettingsLink {
                Label("Settings...", systemImage: "gearshape")
            }
            // Optional: Add the standard keyboard shortcut (Cmd + ,)
            .keyboardShortcut(",")
            
            Divider()
            Button("Quit") { NSApplication.shared.terminate(nil) }
        } label: {
            Image(systemName: isFeatureEnabled ? "checkmark.circle.fill" : "circle")
        }
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
    AnimatedBarView(isFeatureEnabled: .constant(false))
}
