//
//  SettingsView.swift
//  MaStatusBar
//
//  Created by andres paladines on 6/9/26.
//

import ServiceManagement
import SwiftUI

struct SettingsView: View {
    @AppStorage("isFeatureEnabled") private var isFeatureEnabled = false
    @AppStorage("launchAtLogin") private var launchAtLogin = false
    @AppStorage("isAnimationEnabled") private var isAnimationEnabled = false
    @AppStorage("animationSpeed") private var animationSpeed: Double = 0.5
    @AppStorage("barStyle") private var barStyle: BarStyle = .linear
    @AppStorage(angularCenterStorageKey) private var angularCenterKey: String = "Top Leading"

    @State private var gradientColors: [Color] = Color.storedGradientColors()
    @State private var selectedPresetId: UUID?
    private let stopLabels = ["Stop 1", "Stop 2", "Stop 3", "Stop 4", "Stop 5", "Stop 6", "Stop 7"]

    var body: some View {
        TabView {
            Form {
                Toggle("Enable core feature", isOn: $isFeatureEnabled)
                Toggle("Animate colors", isOn: $isAnimationEnabled)

                VStack(alignment: .leading) {
                    Text("Animation speed: \(animationSpeed, specifier: "%.1f")")
                        .foregroundStyle(.secondary)
                    Slider(value: $animationSpeed, in: 0.1...3.0, step: 0.1)
                }

                Picker("Bar style", selection: $barStyle) {
                    Text("Rainbow").tag(BarStyle.linear)
                    Text("Angular").tag(BarStyle.angular)
                }

                if barStyle == .angular {
                    Picker("Gradient center", selection: $angularCenterKey) {
                        ForEach(angularCenterMap, id: \.0) { label, _ in
                            Text(label)
                        }
                    }
                }

                Toggle("Launch app at login", isOn: $launchAtLogin)
                    .onChange(of: launchAtLogin) { oldValue, newValue in
                        do {
                            if newValue {
                                try SMAppService.mainApp.register()
                            } else {
                                try SMAppService.mainApp.unregister()
                            }
                        } catch {
                            launchAtLogin = oldValue
                        }
                    }
            }
            .padding()
            .tabItem {
                Label("General", systemImage: "gearshape")
            }

            Form {
                Section("Presets") {
                    Picker("Color Scheme", selection: $selectedPresetId) {
                        Text("Custom").tag(nil as UUID?)
                        ForEach(gradientPresets) { preset in
                            Text(preset.name).tag(preset.id as UUID?)
                        }
                    }
                    .onChange(of: selectedPresetId) { _, newId in
                        guard let id = newId,
                              let preset = gradientPresets.first(where: { $0.id == id })
                        else { return }
                        gradientColors = preset.colors
                        Color.saveGradientColors(preset.colors)
                    }

                    Button("Reset to Defaults") {
                        Color.resetGradientColors()
                        gradientColors = defaultGradientColors
                        selectedPresetId = gradientPresets.first?.id
                    }
                }

                Section("Custom Colors") {
                    ForEach(0..<7, id: \.self) { i in
                        ColorPicker(stopLabels[i], selection: Binding(
                            get: { gradientColors[safe: i] ?? .purple },
                            set: { newColor in
                                guard i < gradientColors.count else { return }
                                gradientColors[i] = newColor
                                selectedPresetId = nil
                                Color.saveGradientColors(gradientColors)
                            }
                        ))
                    }
                }
            }
            .padding()
            .tabItem {
                Label("Advanced", systemImage: "slider.horizontal.3")
            }
        }
        .frame(width: 450, height: 500)
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
