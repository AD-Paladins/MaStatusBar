//
//  AnimatedBarView.swift
//  MyApp
//
//  Created by andres paladines on 6/9/26.
//

import Combine
import SwiftUI

struct AnimatedBarAngularView: View {
    @State private var angle: Double = 0
    @Binding var isFeatureEnabled: Bool
    @Binding var isAnimationEnabled: Bool
    
    var body: some View {
        Rectangle()
            .fill(
                AngularGradient(
                    colors: [.purple, .blue, .cyan, .purple],
                    center: .topLeading,
                    angle: .degrees(angle)
                )
            )
            .drawingGroup()
            .opacity(isFeatureEnabled ? 1 : 0)
            .animation(.easeInOut(duration: 0.3), value: isFeatureEnabled)
            .onAppear {
                guard isFeatureEnabled && isAnimationEnabled else { return }
                withAnimation(
                    .linear(duration: 8)
                    .repeatForever(autoreverses: false)
                ) {
                    angle = 360
                }
            }
    }
}

struct AnimatedBarView: View {
    @State private var offset: CGFloat = 0
    @Binding var isFeatureEnabled: Bool
    @Binding var isAnimationEnabled: Bool
    private let colors: [Color] = [
        .purple,
        .blue,
        .cyan,
        .green,
        .yellow,
        .orange,
        .red,
        .purple,

        // Repetición
        .blue,
        .cyan,
        .green,
        .yellow,
        .orange,
        .red,
        .purple
    ]

    var body: some View {
        GeometryReader { geo in
            let scrollSpeed: CGFloat = 0.5
            
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
