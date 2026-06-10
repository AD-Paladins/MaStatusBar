# Roadmap

## Done

- [x] Basic `@main` app with three SwiftUI scenes
- [x] Transparent full-width window pinned to top of screen
- [x] Two animated bar variants (scrolling rainbow + rotating angular)
- [x] `MenuBarExtra` with toggle and Settings link
- [x] Tabbed settings window (General / Advanced)
- [x] `@AppStorage` persistence for toggle & launch-at-login pref
- [x] `WindowAccessor` bridge for native NSWindow config
- [x] Metal `drawingGroup()` for gradient performance
- [x] Wire `isFeatureEnabled` to actually start/stop the bar animation
- [x] Animation should respect `isFeatureEnabled` (stop/start cleanly)

## In progress

- [ ] Choose default bar style and expose it in Settings
- [ ] Decide on single vs toggleable bar style

## To do

### Core
- [ ] Show/hide status bar entirely from Settings toggle
- [ ] Start/stop animation from Settings (independently of bar visibility)
- [ ] Add animation speed control in Settings
- [ ] Add bar style picker (scrolling rainbow / angular / solid color / custom)
- [ ] User-customizable colors via color pickers in Settings

### Launch at login
- [ ] Implement `SMAppService` (macOS 13+) or `SMLoginItem` for launch-at-login

### Polish
- [ ] Fix animation jump: scrolling rainbow snaps back when offset resets — make it seamless (infinite scroll via wrap-around or loop)
- [ ] Add fade-in/fade-out transitions when enabling/disabling
- [ ] Consider .5–1pt subtle border or shadow at the bottom edge
- [ ] System menu bar compatibility — ensure it never overlaps or looks off
- [ ] Multi-monitor support (currently only main screen)

### Settings
- [ ] Real color pickers (not just hardcoded arrays)
- [ ] "Reset to defaults" button
- [ ] Keyboard shortcut for settings
- [ ] About tab with version info

### Stability
- [ ] Handle screen resolution changes / display reconfiguration
- [ ] Graceful termination when menu bar extra is the only visible element
