//
//  ButtonStyle.swift
//  PikaToolAPP
//
//  Created by Gessy Avila on 20/10/24.
//

import Foundation
import SwiftUI

struct PauseButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 70, height: 70)
            .foregroundColor(Color("TimerButtonPause"))
            .background(Color("TimerButtonPause").opacity(0.3))
            .clipShape(Circle())
            .padding(.all, 3)
            .overlay(
                Circle()
                    .stroke(Color("TimerButtonPause").opacity(0.3), lineWidth: 2)
            )
    }
}

struct StartButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 70, height: 70)
            .foregroundColor(Color("TimerButtonStart"))
            .background(Color("TimerButtonStart").opacity(0.3))
            .clipShape(Circle())
            .padding(.all, 3)
            .overlay(
                Circle()
                    .stroke(Color("TimerButtonStart")
                        .opacity(0.3), lineWidth: 2)
            )
    }
}

struct CancelButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 70, height: 70)
            .foregroundColor(Color("TimerButtonCancel"))
            .background(Color("TimerButtonCancel").opacity(0.3))
            .clipShape(Circle())
            .padding(.all, 3)
            .overlay(
                Circle()
                    .stroke(Color("TimerButtonCancel").opacity(0.3), lineWidth: 2)
            )
    }
}

struct UpdateButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 70, height: 70)
            .foregroundColor(Color("TimerButtonUpdate"))
            .background(Color("TimerButtonUpdate").opacity(0.3))
            .clipShape(Circle())
            .padding(.all, 3)
            .overlay(
                Circle()
                    .stroke(Color("TimerButtonUpdate").opacity(0.3), lineWidth: 2)
            )
    }
}
