# Design: Separate Visibility & Animation

## Data Flow

```
@AppStorage("isFeatureEnabled")     @AppStorage("isAnimationEnabled")
         │                                    │
         │            ┌───────────────────────┘
         │            │
         ├──→ MenuBarExtra (two toggles)
         ├──→ SettingsView (two toggles)
         └──→ ContentView (passes both as @Binding)
                    │
                    └──→ AnimatedBarView
                              ├──→ .opacity(isFeatureEnabled ? 1 : 0)
                              └──→ animation gate: isFeatureEnabled && isAnimationEnabled
```

## Component Changes

### ContentView.swift

- Add `@AppStorage("isAnimationEnabled") private var isAnimationEnabled = false`
- Change `AnimatedBarView(isFeatureEnabled: $isFeatureEnabled)` to `AnimatedBarView(isFeatureEnabled: $isFeatureEnabled, isAnimationEnabled: $isAnimationEnabled)`
- MenuBarExtra: rename existing toggle label to `Show Status Bar`, add second `Toggle("Start/Stop Animation", isOn: $isAnimationEnabled)`

### AnimatedBarView.swift

**AnimatedBarView (rainbow — the one in use):**
- Add `@Binding var isAnimationEnabled: Bool`
- Change `.task(id: isFeatureEnabled)` to `.task(id: "\(isFeatureEnabled)-\(isAnimationEnabled)")`
- Gate inside task: `guard isFeatureEnabled && isAnimationEnabled else { return }`
- Keep opacity gated on `isFeatureEnabled` only

**AnimatedBarAngularView (unused but keep consistent):**
- Add `@Binding var isAnimationEnabled: Bool`
- Change `onAppear` guard: `guard isFeatureEnabled && isAnimationEnabled else { return }`
- Keep opacity gated on `isFeatureEnabled` only

### SettingsView.swift

- Keep existing toggle for `isFeatureEnabled` with label `Show status bar`
- Add second toggle: `Toggle("Animate colors", isOn: $isAnimationEnabled)`

## Animation Gating Logic

```swift
.task(id: "\(isFeatureEnabled)-\(isAnimationEnabled)") {
    guard isFeatureEnabled && isAnimationEnabled else { return }
    offset = 0
    withAnimation(.linear(duration: 10).repeatForever(autoreverses: false)) {
        offset = -geo.size.width
    }
}
```

When either flag toggles off → SwiftUI cancels the task (animation stops, position preserved).
When both flags are true → task restarts, offset resets to 0, animation begins.

## Edge Cases

| Case | Behaviour |
|---|---|
| Animation ON, visibility OFF | Animation runs but opacity = 0 (invisible). On visibility ON → bar appears already animating |
| Visibility ON, animation OFF | Static gradient bar, no movement |
| Both ON | Full animated bar (same as before) |
| Both OFF | Bar hidden, no animation |
| Rapid toggling both | `.task(id:)` cancellation handles this cleanly — each toggle creates a new task id |

## Files Changed

| File | Lines changed | Type |
|---|---|---|
| `MaStatusBar/ContentView.swift` | ~6 | Add @AppStorage, pass binding, update MenuBarExtra |
| `MaStatusBar/AnimatedBarView.swift` | ~8 | Add @Binding, gate animation on both |
| `MaStatusBar/SettingsView.swift` | ~2 | Add second toggle |

## Dependencies

None. Pure SwiftUI + @AppStorage.
