# Design: Seamless Rainbow Scroll

## Problem

Current `AnimatedBarView` uses `withAnimation(.linear(duration: 10).repeatForever(autoreverses: false))` to animate `offset` from 0 to `-geo.size.width`. When `.repeatForever` resets offset back to 0, the visible content jumps because the gradient tile positions shift.

## Solution

Replace `withAnimation` + `.repeatForever` with a `Timer.publish`-driven offset that decrements each frame and wraps invisibly at tile boundaries.

```
onReceive(Timer.publish(every: 1/60, on: .main, in: .common)) { _ in
    guard isFeatureEnabled && isAnimationEnabled else { return }
    offset -= 0.5
    if offset <= -geo.size.width {
        offset += geo.size.width  // invisible wrap – gradient tiles continuously
    }
}
```

## Spec

### R2 modified: Rainbow bar scrolls seamlessly

- GIVEN the rainbow style is selected and animation is enabled
- THEN the gradient SHALL scroll continuously
- AND the scroll SHALL NOT exhibit visible jumps or resets

## Tasks

1. AnimatedBarView.swift — replace `.task(id:)` + `withAnimation` with `Timer.publish` approach
2. AnimatedBarAngularView.swift — no changes needed (angle wraps naturally)
3. Verify build + manual visual test for seamlessness
