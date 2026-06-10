# Tasks: Separate Visibility & Animation

## Review Workload Forecast

| Field | Value |
|-------|-------|
| Estimated changed lines | ~16 |
| 400-line budget risk | Low |
| Chained PRs recommended | No |
| Suggested split | Single PR |
| Delivery strategy | single-pr |
| Chain strategy | size-exception |

Decision needed before apply: Yes
Chained PRs recommended: No
Chain strategy: size-exception
400-line budget risk: Low

## Phase 1: Foundation — ContentView Storage

- [x] 1.1 Add `@AppStorage("isAnimationEnabled") private var isAnimationEnabled = false` to `MaStatusBar/ContentView.swift`
- [x] 1.2 Update `AnimatedBarView` call to pass both bindings: `AnimatedBarView(isFeatureEnabled: $isFeatureEnabled, isAnimationEnabled: $isAnimationEnabled)`
- [x] 1.3 Update preview at bottom to include second binding: `AnimatedBarView(isFeatureEnabled: .constant(true), isAnimationEnabled: .constant(true))`
- [x] 1.4 **Verify**: App compiles, existing toggle still works

## Phase 2: Core Implementation — AnimatedBarView Gating

- [x] 2.1 Add `@Binding var isAnimationEnabled: Bool` to `AnimatedBarView` struct
- [x] 2.2 Change `.task(id: isFeatureEnabled)` to `.task(id: "\(isFeatureEnabled)-\(isAnimationEnabled)")`
- [x] 2.3 Update guard: `guard isFeatureEnabled && isAnimationEnabled else { return }`
- [x] 2.4 Add `@Binding var isAnimationEnabled: Bool` to `AnimatedBarAngularView` for consistency
- [x] 2.5 Update `AnimatedBarAngularView` guard: `guard isFeatureEnabled && isAnimationEnabled else { return }`
- [x] 2.6 **Verify**: Animation stops when either toggle is OFF; restarts when both ON

## Phase 3: Settings — Second Toggle

- [x] 3.1 Add `@AppStorage("isAnimationEnabled") private var isAnimationEnabled = false` to `MaStatusBar/SettingsView.swift`
- [x] 3.2 Add second toggle: `Toggle("Animate colors", isOn: $isAnimationEnabled)`
- [x] 3.3 **Verify**: Settings window shows both toggles, each controls its behavior independently

## Phase 4: MenuBarExtra — Two Toggles

- [x] 4.1 Rename existing toggle label: `Toggle("Show Status Bar", isOn: $isFeatureEnabled)`
- [x] 4.2 Add second toggle: `Toggle("Start/Stop Animation", isOn: $isAnimationEnabled)`
- [x] 4.3 **Verify**: Menu bar shows both toggles, each works independently

## Verification Checklist

- [x] App builds successfully (xcodebuild succeeded)
- [ ] Animation ON, visibility OFF → bar invisible, animation runs silently
- [ ] Visibility ON, animation OFF → static gradient bar, no movement
- [ ] Both ON → full animated bar (original behavior)
- [ ] Both OFF → bar hidden, no animation
- [ ] Rapid toggling both → clean cancellation, no visual glitches
