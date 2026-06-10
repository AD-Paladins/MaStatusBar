# Design: Wire Feature Toggle

## Data Flow

```
@AppStorage("isFeatureEnabled")
         │
         ├──→ MenuBarExtra (reads directly, icon toggle)
         ├──→ SettingsView (reads/writes via @AppStorage)
         └──→ ContentView (reads, passes as @Binding)
                    │
                    └──→ AnimatedBarView ($isFeatureEnabled @Binding)
                              │
                              ├──→ .opacity(isFeatureEnabled ? 1 : 0)
                              └──→ onAppear gate: isAnimated && isFeatureEnabled
```

## Component Changes

### ContentView.swift

- Delete the unused `import Playgrounds`
- Replace `AnimatedBarView()` with `AnimatedBarView(isFeatureEnabled: $isFeatureEnabled)`
- Pass binding to the WindowGroup content

### AnimatedBarView.swift

**Both structs need the same changes:**

1. Replace `@State var isAnimated: Bool = false` with `@Binding var isFeatureEnabled: Bool`
2. Remove `@State private var offset/angle` — keep them as `@State` (internal animation state)
3. Gate the `onAppear` animation block: `if isFeatureEnabled { withAnimation(...) { ... } }`
4. Add `.opacity(isFeatureEnabled ? 1 : 0)` to the wrapper
5. Add `.animation(.easeInOut(duration: 0.3), value: isFeatureEnabled)` for fade

### SettingsView.swift

- No changes needed — already uses `@AppStorage("isFeatureEnabled")`

## Animation Lifecycle

### Start
1. User toggles ON → `isFeatureEnabled = true`
2. SwiftUI triggers opacity change → fade in (0 → 1 over 0.3s)
3. `onAppear` already fired, but the animation block runs each time `isFeatureEnabled` transitions
4. Animation starts from current state (no reset to 0)

### Stop
1. User toggles OFF → `isFeatureEnabled = false`
2. SwiftUI triggers opacity change → fade out (1 → 0 over 0.3s)
3. The animated offset/angle keeps its current position (no snap)
4. On re-enable, animation continues from where it left off

Problem: `withAnimation` blocks run once on `onAppear`. For animation to restart when toggling, we need either:
- Track the previous value and call `withAnimation` in a `.onChange(of: isFeatureEnabled)` block
- Or use SwiftUI's implicit animation via `.animation()` modifier

Best approach: use `.animation(.linear(duration: speed).repeatForever(...), value: isFeatureEnabled)` combined with `.onChange(of: isFeatureEnabled)` to reset/start the state animation.

Actually simpler: keep the `withAnimation` in `onAppear` but also add a `.task(id: isFeatureEnabled)` that re-triggers the animation:

```swift
.task(id: isFeatureEnabled) {
    guard isFeatureEnabled else { return }
    offset = -geo.size.width  // reset for smooth restart
    withAnimation(.linear(duration: 10).repeatForever(autoreverses: false)) {
        offset = -geo.size.width
    }
}
```

Wait, `offset = -geo.size.width` then animate to the same value does nothing. 

Better approach for the rainbow bar:
- Initial state: `offset = 0`
- Animation target: `offset = -geo.size.width` 
- On disable: cancel animation (state stays at current offset)
- On re-enable: reset `offset = 0` then animate to `-geo.size.width`

```swift
.task(id: isFeatureEnabled) {
    guard isFeatureEnabled else { return }
    offset = 0
    withAnimation(.linear(duration: 10).repeatForever(autoreverses: false)) {
        offset = -geo.size.width
    }
}
```

For the angular bar:
- Same pattern but with angle: `angle = 0` → `angle = 360`

## Edge Cases

| Case | Behavior |
|---|---|
| Launch with disabled | Bar opacity 0, no animation starts |
| Launch with enabled | Bar fades in on appear, animation starts |
| Rapid toggle off/on | `.task(id:)` cancels previous, starts fresh from 0 |
| Screen resize | GeometryReader handles layout, animation continues |
| Settings toggle matches menu toggle | Both write to same `@AppStorage`, always in sync |

## Files Changed

| File | Lines changed | Type |
|---|---|---|
| `MaStatusBar/ContentView.swift` | ~2 | Modify AnimatedBarView call |
| `MaStatusBar/AnimatedBarView.swift` | ~20 | Add @Binding, opacity gate, .task() animation control |

## No-dependency verification

- Uses only SwiftUI (`@AppStorage`, `@Binding`, `.opacity`, `.task`, `.animation`)
- No Combine, no third-party packages
- Metal `drawingGroup()` stays on the gradient layer — no changes needed
