import SwiftUI
import Playgrounds

@main struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            AnimatedBarView()
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
    }
}

// Un helper clásico para acceder al NSWindow nativo desde SwiftUI
struct WindowAccessor: NSViewRepresentable {
    let callback: (NSWindow?) -> Void

    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async {
            callback(view.window)
        }
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {}
}


#Preview {
    AnimatedBarView()
}

#Playground {
    _ = 1 + 2
}
