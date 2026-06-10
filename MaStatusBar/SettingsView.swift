//
//  SettingsView.swift
//  MaStatusBar
//
//  Created by andres paladines on 6/9/26.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("isFeatureEnabled") private var isFeatureEnabled = false
    @AppStorage("launchAtLogin") private var launchAtLogin = false
    @AppStorage("isAnimationEnabled") private var isAnimationEnabled = false

    @State private var gradientColors: [Color] = Color.storedGradientColors()
    private let stopLabels = ["Stop 1", "Stop 2", "Stop 3", "Stop 4", "Stop 5", "Stop 6", "Stop 7"]

    var body: some View {
        TabView {
            Form {
                Toggle("Enable core feature", isOn: $isFeatureEnabled)
                Toggle("Animate colors", isOn: $isAnimationEnabled)
                Toggle("Launch app at login", isOn: $launchAtLogin)

                Section("Gradient Colors") {
                    ForEach(0..<7, id: \.self) { i in
                        ColorPicker(stopLabels[i], selection: Binding(
                            get: { gradientColors[safe: i] ?? .purple },
                            set: { newColor in
                                guard i < gradientColors.count else { return }
                                gradientColors[i] = newColor
                                Color.saveGradientColors(gradientColors)
                            }
                        ))
                    }
                }
            }
            .padding()
            .tabItem {
                Label("General", systemImage: "gearshape")
            }

            Form {
                Text("Advanced configurations could go here.")
                    .foregroundStyle(.secondary)
            }
            .padding()
            .tabItem {
                Label("Advanced", systemImage: "slider.horizontal.3")
            }
        }
        .frame(width: 450, height: 450)
        .onReceive(NotificationCenter.default.publisher(for: NSApplication.didChangeScreenParametersNotification)) { _ in
            gradientColors = Color.storedGradientColors()
        }
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
