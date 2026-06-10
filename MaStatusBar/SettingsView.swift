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

    var body: some View {
        TabView {
            // General Tab
            Form {
                Toggle("Enable core feature", isOn: $isFeatureEnabled)
                Toggle("Animate colors", isOn: $isAnimationEnabled)
                Toggle("Launch app at login", isOn: $launchAtLogin)
            }
            .padding()
            .tabItem {
                Label("General", systemImage: "gearshape")
            }
            
            // Advanced Tab (Example)
            Form {
                Text("Advanced configurations could go here.")
                    .foregroundStyle(.secondary)
            }
            .padding()
            .tabItem {
                Label("Advanced", systemImage: "slider.horizontal.3")
            }
        }
        .frame(width: 450, height: 250) // Fixes the window to a nice standard size
    }
}
