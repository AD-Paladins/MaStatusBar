import AppKit
import SwiftUI

extension NSColor {
    var hexString: String {
        guard let rgb = usingColorSpace(.sRGB) else { return "#000000" }
        let r = Int(rgb.redComponent * 255)
        let g = Int(rgb.greenComponent * 255)
        let b = Int(rgb.blueComponent * 255)
        return String(format: "#%02X%02X%02X", r, g, b)
    }

    convenience init?(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        guard hex.count == 6 || hex.count == 8 else { return nil }
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b, a: UInt64
        if hex.count == 8 {
            (r, g, b, a) = ((int >> 24) & 0xFF, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        } else {
            (r, g, b, a) = ((int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF, 255)
        }
        self.init(srgbRed: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

struct CodableColor: RawRepresentable, Equatable {
    let color: Color

    init(_ color: Color) {
        self.color = color
    }

    init?(rawValue: String) {
        guard let nsColor = NSColor(hex: rawValue) else { return nil }
        self.color = Color(nsColor: nsColor)
    }

    var rawValue: String {
        NSColor(color).hexString
    }
}

let defaultGradientColors: [Color] = [
    .purple, .blue, .cyan, .green, .yellow, .orange, .red
]

let gradientColorsKey = "gradientColors"

struct ColorPreset: Identifiable {
    let id = UUID()
    let name: String
    let colors: [Color]
}

let gradientPresets: [ColorPreset] = [
    ColorPreset(name: "Rainbow", colors: defaultGradientColors),
    ColorPreset(name: "Ocean", colors: [
        Color(red: 0, green: 0.5, blue: 0.5),
        .blue,
        Color(red: 0.1, green: 0.3, blue: 0.7),
        .cyan,
        Color(red: 0, green: 0.8, blue: 0.8),
        Color(red: 0, green: 0.4, blue: 0.6),
        .indigo
    ]),
    ColorPreset(name: "Sunset", colors: [
        .red,
        .orange,
        .yellow,
        .pink,
        .purple,
        Color(red: 0.8, green: 0.2, blue: 0.5),
        Color(red: 0.6, green: 0, blue: 0.6)
    ]),
    ColorPreset(name: "Forest", colors: [
        Color(red: 0.1, green: 0.5, blue: 0.1),
        .mint,
        Color(red: 0.2, green: 0.6, blue: 0.2),
        Color(red: 0.3, green: 0.7, blue: 0.2),
        .teal,
        Color(red: 0, green: 0.4, blue: 0.3),
        Color(red: 0.1, green: 0.3, blue: 0.1)
    ]),
    ColorPreset(name: "Neon", colors: [
        Color(red: 1, green: 0, blue: 1),
        Color(red: 1, green: 0, blue: 0.5),
        Color(red: 1, green: 0.4, blue: 0),
        .yellow,
        Color(red: 0, green: 1, blue: 0),
        Color(red: 0, green: 0.5, blue: 1),
        Color(red: 0.3, green: 0, blue: 0.8)
    ]),
    ColorPreset(name: "Monochrome", colors: [
        Color(red: 0.15, green: 0.15, blue: 0.15),
        Color(red: 0.35, green: 0.35, blue: 0.35),
        Color(red: 0.55, green: 0.55, blue: 0.55),
        Color(red: 0.7, green: 0.7, blue: 0.7),
        Color(red: 0.55, green: 0.55, blue: 0.55),
        Color(red: 0.35, green: 0.35, blue: 0.35),
        Color(red: 0.15, green: 0.15, blue: 0.15)
    ]),
]

extension Color {
    static func storedGradientColors() -> [Color] {
        guard let data = UserDefaults.standard.data(forKey: gradientColorsKey),
              let hexes = try? JSONDecoder().decode([String].self, from: data),
              !hexes.isEmpty
        else { return defaultGradientColors }
        let colors = hexes.compactMap { NSColor(hex: $0).map(Color.init) }
        return colors.count == 7 ? colors : defaultGradientColors
    }

    static func saveGradientColors(_ colors: [Color]) {
        let hexes = colors.map { NSColor($0).hexString }
        let data = (try? JSONEncoder().encode(hexes)) ?? Data()
        UserDefaults.standard.set(data, forKey: gradientColorsKey)
    }

    static func resetGradientColors() {
        UserDefaults.standard.removeObject(forKey: gradientColorsKey)
    }
}
