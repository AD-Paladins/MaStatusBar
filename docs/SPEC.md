# MaStatusBar — Specification

## Purpose

A lightweight macOS utility that renders a colorful animated bar across the top of the screen, just below the system menu bar. It adds visual flair and provides a persistent status indicator accessible via the menu bar icon.

## Architecture Overview

### Components

- **StatusBar Window**: Borderless, transparent `NSWindow` pinned at `screen.maxY - 28pt`, full width, `ignoresMouseEvents = true`, level `.mainMenu`.
- **Animated Bar Views**: SwiftUI views rendered via Metal `drawingGroup()`. Two variants:
  - Rainbow Bar: Horizontal scrolling `LinearGradient` with 15 colors, offset animation.
  - Angular Bar: Rotating `AngularGradient` (purple → blue → cyan), angle animation.
- **MenuBarExtra**: SF Symbol icon in the system menu bar. Dropdown with toggle, Settings link, Quit.
- **Settings Window**: Tabbed panel (`General`, `Advanced`) via `SettingsLink`. Not a floating panel.

### Data Flow

```
User → MenuBarExtra toggle → @AppStorage("isFeatureEnabled")
                                   ↓
                        StatusBar window reads flag
                                   ↓
                        Animation starts/stops accordingly
                                   ↓
                        Settings reads/writes same store
```

## Requirements

### R1: Status Bar Rendering

The system SHALL render a full-width colored bar at the top of the screen, below the system menu bar area.

#### Scenario: Bar appears on launch

- GIVEN the app is launched
- THEN a bar SHALL be rendered across the full screen width
- AND the bar SHALL be 28pt tall, positioned at `screen.maxY - 28pt`

#### Scenario: Bar stays on all Spaces

- GIVEN the user switches Spaces or fullscreen apps
- THEN the bar SHALL remain visible on the current Space
- AND the bar SHALL NOT appear in the Mission Control / window switcher

### R2: Animation

The system SHALL support two animated bar styles: a scrolling rainbow gradient and a rotating angular gradient.

#### Scenario: Rainbow bar scrolls smoothly

- GIVEN the rainbow style is selected
- WHEN the feature is enabled
- THEN the gradient SHALL scroll horizontally without visible jumps or resets

#### Scenario: Angular bar rotates continuously

- GIVEN the angular style is selected
- WHEN the feature is enabled
- THEN the gradient SHALL rotate continuously without visible stutters

#### Scenario: Animation stops when disabled

- GIVEN the bar is visible and animating
- WHEN the user disables the feature
- THEN the animation SHALL stop
- AND the bar MAY remain visible or hide depending on the "show bar" setting

### R2.1: Animation Control

The system SHALL provide an independent toggle to start and stop bar animation, separate from bar visibility.

#### Scenario: Animation toggles independently

- GIVEN the bar is visible
- WHEN the user disables animation
- THEN the bar SHALL remain visible with a static gradient
- AND the animation SHALL stop

#### Scenario: Animation defaults to off

- GIVEN the app is launched for the first time
- THEN the animation SHALL be disabled by default
- AND the bar SHALL be static if visible

#### Scenario: Animation re-enables

- GIVEN animation is disabled and the bar is visible
- WHEN the user enables animation
- THEN the gradient SHALL start animating smoothly from its current position

### R3: Menu Bar Extra

The system SHALL provide a menu bar icon with controls.

#### Scenario: Icon shows feature status

- GIVEN the app is running
- THEN a menu bar icon SHALL be visible
- AND the icon SHALL reflect whether the feature is enabled (filled vs outline icon)

#### Scenario: Menu dropdown

- GIVEN the user clicks the menu bar icon
- THEN the dropdown SHALL show a toggle for the feature
- AND a "Settings..." option SHALL open the Settings window
- AND a "Quit" option SHALL terminate the app

### R4: Settings — General

The system SHALL provide a settings window where the user can control behavior.

#### Scenario: Show/hide bar

- GIVEN the user opens Settings → General
- THEN there SHALL be a toggle to show or hide the status bar entirely
- AND the bar SHALL appear/disappear immediately when toggled

#### Scenario: Start/stop animation

- GIVEN the user opens Settings → General
- THEN there SHALL be a toggle to start or stop the bar animation
- AND animation SHALL start/stop immediately
- AND this SHALL be independent of the bar visibility toggle

#### Scenario: Customize colors

- GIVEN the user opens Settings → General
- THEN there SHALL be color pickers to customize the bar's gradient colors
- AND changes SHALL apply immediately to the bar

#### Scenario: Animation speed

- GIVEN the user opens Settings → General
- THEN there SHALL be a slider or stepper to control animation speed
- AND the bar animation speed SHALL update in real-time

### R5: Launch at Login

The system SHOULD support launching automatically at user login.

#### Scenario: Toggle persists

- GIVEN the user enables "Launch at login" in Settings
- THEN the preference SHALL persist across app restarts
- AND the app SHALL launch automatically on next login

### R6: Performance

The system SHALL render animations at 60fps without significant CPU/GPU overhead.

#### Scenario: Smooth animation

- GIVEN the bar is animating
- THEN the animation SHALL run at 60fps
- AND the animation SHALL NOT introduce visible stutter or frame drops

## Constraints

- **macOS 14+** target. APIs like `SMAppService` require Sonoma.
- **No external dependencies.** Pure SwiftUI + AppKit. No Combine, no third-party packages.
- **`drawingGroup()`** for Metal off-screen rendering of gradients.
- **`@AppStorage`** for preference persistence. Lightweight, no CoreData.

## Open Questions

1. Single rainbow bar or toggle between rainbow / angular / others?
2. Default bar style on first launch?
3. Should the bar show by default on launch, or only after user enables it?
4. How many user-customizable colors? A fixed set (2–4) or arbitrary palette?
