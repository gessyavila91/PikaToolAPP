//
//  CircularProgressView.swift
//  PikaToolAPP
//
//  Created by Gessy Avila on 20/10/24.
//

import Foundation
import SwiftUI

struct CircularProgressView: View {
    @Binding var progress: Float
    @Binding var stepProgress: Float

    var body: some View {
        ZStack {
            // Primer círculo grande (gris)
            Circle()
                .stroke(lineWidth: 10.0)
                .opacity(0.4)
                .foregroundColor(Color("TimerButtonCancel"))

            // Segundo círculo (progreso general)
            Circle()
                .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 8.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color("TimerButtonStart"))
                .rotationEffect(Angle(degrees: 270))
                .animation(.linear(duration: 0.1), value: progress)

            // Tercer círculo (progreso de pasos, más pequeño)
            Circle()
                .trim(from: 0.0, to: CGFloat(min(stepProgress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 15.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color("TimerButtonStep"))
                .rotationEffect(Angle(degrees: 270))
                .animation(.linear(duration: 0.1), value: stepProgress)
                .scaleEffect(0.9) // Hacer el círculo más pequeño
        }
    }
}
