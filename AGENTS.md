# MaStatusBar — Project context

Lee estos archivos al inicio de cada sesión para arrancar con contexto completo:

## Referencias obligatorias

- `docs/PROJECT.md` — qué hace la app, estado actual, objetivos
- `docs/ARCHITECTURE.md` — estructura, patrones, decisiones técnicas
- `docs/SPEC.md` — especificación general del proyecto (requisitos, escenarios)

## Stack

- macOS 14+ target
- SwiftUI + `NSViewRepresentable` bridge para config de ventana nativa
- Metal `drawingGroup()` para rendering de gradients animados
- `@AppStorage` para persistencia ligera
- `SMAppService` (cuando implementemos launch-at-login)

## Convenciones del proyecto

- Código en inglés (nombres, comentarios, UI copy)
- Sin `//` comentarios explicativos en código — que el código se explique solo
- Commits en conventional commits, en inglés
- Sin atribución AI en commits

## Archivos fuente

| Archivo | Rol |
|---|---|
| `MaStatusBar/ContentView.swift` | `@main` entry, scenes (WindowGroup, Settings, MenuBarExtra) |
| `MaStatusBar/AnimatedBarView.swift` | Dos variantes de barra animada |
| `MaStatusBar/SettingsView.swift` | Settings panel con tabs |
