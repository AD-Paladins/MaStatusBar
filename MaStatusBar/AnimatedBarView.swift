//
//  AnimatedBarView.swift
//  MyApp
//
//  Created by andres paladines on 6/9/26.
//

import SwiftUI

//struct AnimatedBarView: View {
//    @State private var angle: Double = 0
//
//    var body: some View {
//        Rectangle()
//            .fill(
//                AngularGradient(
//                    colors: [.purple, .blue, .cyan, .purple],
//                    center: .center,
//                    angle: .degrees(angle)
//                )
//            )
//            .drawingGroup()
//            .onAppear {
//                withAnimation(
//                    .linear(duration: 8)
//                        .repeatForever(autoreverses: false)
//                ) {
//                    angle = 360
//                }
//            }
//    }
//}

struct AnimatedBarView: View {
    @State private var offset: CGFloat = 0

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
            LinearGradient(
                colors: colors,
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(width: geo.size.width * 2)
            .offset(x: offset)
            .clipped()
            .onAppear {
                withAnimation(
                    .linear(duration: 10)
                    .repeatForever(autoreverses: false)
                ) {
                    offset = -geo.size.width
                }
            }
        }
    }
}

#Preview {
    AnimatedBarView()
}
