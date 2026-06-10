//
//  AnimatedBarView.swift
//  MyApp
//
//  Created by andres paladines on 6/9/26.
//

import Combine
import SwiftUI

enum BarStyle: String, CaseIterable {
    case linear = "linear"
    case angular = "angular"
}

let angularCenterMap: [(String, UnitPoint)] = [
    ("Top Leading", .topLeading),
    ("Top", .top),
    ("Top Trailing", .topTrailing),
    ("Leading", .leading),
    ("Center", .center),
    ("Trailing", .trailing),
    ("Bottom Leading", .bottomLeading),
    ("Bottom", .bottom),
    ("Bottom Trailing", .bottomTrailing),
]

extension UnitPoint {
    static func fromStorageKey(_ key: String) -> UnitPoint {
        angularCenterMap.first(where: { $0.0 == key })?.1 ?? .topLeading
    }
}

let angularCenterStorageKey = "angularGradientCenter"

struct AnimatedBarAngularView: View {
    @State private var angle: Double = 0
    @Binding var isFeatureEnabled: Bool
    @Binding var isAnimationEnabled: Bool
    @AppStorage(gradientColorsKey) private var gradientColorsData: Data = Data()
    @AppStorage("animationSpeed") private var animationSpeed: Double = 0.5
    @AppStorage(angularCenterStorageKey) private var centerKey: String = "Top Leading"

    private var gradientColors: [Color] {
        guard !gradientColorsData.isEmpty,
              let hexes = try? JSONDecoder().decode([String].self, from: gradientColorsData),
              hexes.count == 7
        else { return defaultGradientColors }
        let base = hexes.compactMap { NSColor(hex: $0).map(Color.init) }
        guard base.count == 7 else { return defaultGradientColors }
        return [base[0], base[1], base[2], base[0]]
    }

    var body: some View {
        Rectangle()
            .fill(
                AngularGradient(
                    colors: gradientColors,
                    center: UnitPoint.fromStorageKey(centerKey),
                    angle: .degrees(angle)
                )
            )
            .opacity(isFeatureEnabled ? 1 : 0)
            .animation(.easeInOut(duration: 0.3), value: isFeatureEnabled)
            .onReceive(Timer.publish(every: 1/60, on: .main, in: .common).autoconnect()) { _ in
                guard isFeatureEnabled && isAnimationEnabled else { return }
                angle += animationSpeed * 1.5
                if angle >= 360 { angle -= 360 }
            }
    }
}

struct AnimatedBarView: View {
    @State private var offset: CGFloat = 0
    @Binding var isFeatureEnabled: Bool
    @Binding var isAnimationEnabled: Bool
    @AppStorage(gradientColorsKey) private var gradientColorsData: Data = Data()
    @AppStorage("animationSpeed") private var animationSpeed: Double = 0.5

    private var colors: [Color] {
        guard !gradientColorsData.isEmpty,
              let hexes = try? JSONDecoder().decode([String].self, from: gradientColorsData),
              hexes.count == 7
        else { return defaultGradientColors + [defaultGradientColors[0]] + defaultGradientColors.dropFirst() + [defaultGradientColors[0]] }
        let base = hexes.compactMap { NSColor(hex: $0).map(Color.init) }
        guard base.count == 7 else { return defaultGradientColors + [defaultGradientColors[0]] + defaultGradientColors.dropFirst() + [defaultGradientColors[0]] }
        return base + [base[0]] + base.dropFirst() + [base[0]]
    }

    var body: some View {
        GeometryReader { geo in
            let scrollSpeed: CGFloat = CGFloat(animationSpeed)
            
            LinearGradient(
                colors: colors,
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(width: geo.size.width * 2)
            .offset(x: offset)
            .drawingGroup()
            .onReceive(Timer.publish(every: 1/60, on: .main, in: .common).autoconnect()) { _ in
                guard isFeatureEnabled && isAnimationEnabled else { return }
                offset -= scrollSpeed
                if offset <= -geo.size.width {
                    offset += geo.size.width
                }
            }
            .opacity(isFeatureEnabled ? 1 : 0)
            .animation(.easeInOut(duration: 0.3), value: isFeatureEnabled)
        }
    }
}

#Preview {
    AnimatedBarView(isFeatureEnabled: .constant(true), isAnimationEnabled: .constant(true))
}
