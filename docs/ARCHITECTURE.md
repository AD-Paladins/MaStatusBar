# Architecture

## Files

| File | Role |
|---|---|
| `ContentView.swift` | `@main` entry, `App` conformance. Hosts `WindowGroup` (the bar), `Settings` scene, and `MenuBarExtra`. |
| `AnimatedBarView.swift` | Two views: `AnimatedBarView` (scrolling rainbow) and `AnimatedBarAngularView` (spinning angular gradient). Both use `drawingGroup()` for Metal rendering. |
| `SettingsView.swift` | Tab-based settings (`General` / `Advanced`). Reads/writes via `@AppStorage`. |

## Key patterns

- **`WindowAccessor`**: `NSViewRepresentable` bridge to configure the underlying `NSWindow` (level, transparency, frame, mouse events, collection behavior).
- **Scene triple**: One `.windowed` app that uses three SwiftUI scenes — `WindowGroup` for the bar, `Settings` for preferences, `MenuBarExtra` for the status icon.
- **Animations**: `withAnimation(.linear(duration: 8-10).repeatForever)` + `.offset` or `.angle` state changes.

## Window config

- `level: .mainMenu` — sits just below the system menu bar
- `ignoresMouseEvents = true` — click-through
- `collectionBehavior: [.canJoinAllSpaces, .stationary, .ignoresCycle]` — follows user across Spaces
- Frame: full screen width, 28pt tall, pinned to `screenFrame.maxY - 28`

## Decisions & tradeoffs

- **`drawingGroup()`**: Bakes the gradient into a Metal off-screen buffer — essential for performance with full-width animated gradients.
- **`@AppStorage` over `@State`**: Persists toggle state. The `isFeatureEnabled` flag controls bar visibility with a 0.3s easeInOut fade and gates the animation loop via `.task(id:)` (rainbow) / `guard` (angular).
- **`SettingsLink` over manual window**: Cleaner SwiftUI-native path. Relies on the `Settings` scene being present.
