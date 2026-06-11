# MaStatusBar

A lightweight macOS utility that renders a colorful animated bar across the top of your screen, just below the system menu bar. Add visual flair to your macOS experience with smooth, seamless gradient animations.

**macOS 14+ • SwiftUI + Metal • 100% Swift**

---

## ✨ Features

- **Full-Width Animated Bar** — A 28pt tall borderless bar pinned below the system menu bar, on every Space
- **Two Animation Styles**
  - Rainbow Bar: Horizontally scrolling gradient with 15 vibrant colors
  - Angular Bar: Rotating gradient (purple → blue → cyan)
- **Independent Controls** — Toggle bar visibility and animation separately
- **Menu Bar Extra** — Quick access icon in the system menu bar for controls and settings
- **Settings Panel** — Customize bar behavior with a tabbed preferences window
- **Smooth Rendering** — Metal `drawingGroup()` for high-performance gradient animations at 60fps
- **Persistent State** — Your preferences automatically save and restore

---

## 🚀 Getting Started

### Requirements

- macOS 14 (Sonoma) or later
- Xcode 15+

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/AD-Paladins/MaStatusBar.git
   cd MaStatusBar
   ```

2. Open the project:
   ```bash
   open MaStatusBar.xcodeproj
   ```

3. Build and run:
   - Select the `MaStatusBar` scheme
   - Press `Cmd+R` or click the Play button

### First Launch

- The animated bar appears at the top of your screen
- Click the menu bar icon (top right, below the system menu) to access controls
- Open **Settings** to customize behavior

---

## 🎛️ Usage

### Menu Bar Extra

Click the menu bar icon to:
- **Toggle** the feature on/off
- **Open Settings** to customize behavior
- **Quit** the app

### Settings

#### General Tab
- **Show Status Bar** — Display or hide the bar entirely
- **Animate** — Start/stop bar animation (independent of visibility)
- **Bar Style** — Choose between Rainbow or Angular gradient

#### Advanced Tab
- Fine-tune animation speed, colors, and performance settings

### Launch at Login (Planned)

A future update will add automatic app launch on user login via `SMAppService`.

---

## ���️ Architecture

### Project Structure

| File | Purpose |
|------|---------|
| `ContentView.swift` | App entry point (`@main`). Manages three SwiftUI scenes: the status bar window, settings panel, and menu bar extra. |
| `AnimatedBarView.swift` | Two animated bar implementations: `AnimatedBarView` (rainbow) and `AnimatedBarAngularView` (angular). Both use Metal rendering for performance. |
| `SettingsView.swift` | Tabbed settings interface. Controls persist via `@AppStorage`. |

### Key Design Decisions

**Window Configuration**
- Level: `.mainMenu` — positioned just below the system menu bar
- Click-through: `ignoresMouseEvents = true`
- Multi-Space support: `collectionBehavior: [.canJoinAllSpaces, .stationary, .ignoresCycle]`
- Frame: Full screen width × 28pt, pinned to `screenFrame.maxY - 28`

**Rendering**
- Metal `drawingGroup()` bakes gradients into off-screen buffers for performance
- Animations use `withAnimation(.linear(duration: 8-10).repeatForever)` with state-driven offset/angle changes

**State Management**
- `@AppStorage` for lightweight persistence (no CoreData)
- `isFeatureEnabled` — controls bar visibility with smooth fade (0.3s easeInOut)
- `isAnimationEnabled` — controls animation independently (default: off)

---

## 📋 Roadmap

### In Progress
- [ ] Complete core feature toggle wiring (bar shows/hides correctly)
- [ ] Real-time settings controls for colors and animation speed
- [ ] Smooth, seamless color cycle animations

### Upcoming
- [ ] Launch at login support (`SMAppService`)
- [ ] Advanced color customization
- [ ] Animation presets
- [ ] Unit tests (XCTest) for animation and settings logic
- [ ] Accessibility improvements

---

## 🔧 Development

### Building from Source

```bash
xcodebuild build -scheme MaStatusBar
```

### Running Tests

```bash
xcodebuild test -scheme MaStatusBar
```

(XCTest target coming soon)

### Code Style

- All code in English
- Conventional commits (English, no AI attribution)
- Self-documenting code — minimal inline comments

---

## 📝 License

MIT License — See [LICENSE](LICENSE) for details.

---

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/your-feature`)
3. Commit using conventional commits (`feat:`, `fix:`, `docs:`, etc.)
4. Push and open a pull request

---

## 🐛 Reporting Issues

Found a bug or have a feature request? Open an [issue](https://github.com/AD-Paladins/MaStatusBar/issues) with:
- macOS version
- Steps to reproduce
- Expected vs. actual behavior
- Screenshots (if applicable)

---

## 📖 Documentation

- **[PROJECT.md](docs/PROJECT.md)** — Project overview and goals
- **[ARCHITECTURE.md](docs/ARCHITECTURE.md)** — Technical design and patterns
- **[SPEC.md](docs/SPEC.md)** — Detailed specification and requirements

---

**Made with ❤️ on macOS**
