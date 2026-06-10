# MaStatusBar

macOS app that renders a colorful animated bar across the top of the screen (menu bar area) with a companion `MenuBarExtra` for controls.

## What it does

- A borderless, transparent window pinned to the top of every Space, positioned below the system menu bar
- Two animated bar variants:
  - `AnimatedBarView` — horizontal scrolling rainbow (LinearGradient, 15 colors, moves left)
  - `AnimatedBarAngularView` — rotating angular gradient (purple → blue → cyan)
- A `MenuBarExtra` icon to toggle the feature on/off and open Settings
- Settings window with "General" and "Advanced" tabs via `SettingsLink`

## Current state

Functional but early. The animated bar renders, the menu icon exists, settings work. No persistence logic beyond `@AppStorage`, no launch-at-login implementation, no proper feature toggle wiring.

## Goals

1. Finish core feature: toggle should actually enable/disable the bar animation
2. Settings controls: show/hide status bar, start/stop animation, pick bar colors
3. Polish: smooth, seamless color animations (no sudden jump at cycle end)
4. Good macOS citizen: launch at login, proper Space behavior, accessibility
5. Settings panel with real options
6. Unit tests via XCTest for core animation and settings logic
