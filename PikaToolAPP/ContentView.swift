//
//  ContentView.swift
//  PikaToolAPP
//
//  Created by Gessy Avila on 17/10/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("PikaTimer", systemImage: "stopwatch") {
                PikaTimerView()
            }
        }
    }
}

#Preview {
    ContentView()
}
