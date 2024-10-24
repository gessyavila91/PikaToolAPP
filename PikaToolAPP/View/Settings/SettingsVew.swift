//
//  SettingsVew.swift
//  PikaToolAPP
//
//  Created by Gessy Avila on 22/10/24.
//

import SwiftUI
import Foundation

struct Setting: Hashable {
    let title: String
    let color: Color
    let imageName: String
}

struct SettingImage: View {
    let color: Color
    let imageName: String
    
    var body: some View {
        Image(systemName: imageName)
            .resizable()
            .foregroundStyle(color)
            .frame(width: 25, height: 25)
    }
}

struct RootSettingView: View {
    let viewToDisplay: String
    @StateObject var timerSettings = TimerSettingsStruct.default
    
    var body: some View {
        switch viewToDisplay {
        case "Action":
            ActionSettingsView()
        case "Timer":
            TimerSettingsView(timerSettings: timerSettings)
        case "Profiles":
            ProfilesSettingsView(profileManager: ProfileManager())
        case "Theme":
            ActionSettingsView()
        default:
            RootSettingView(viewToDisplay: "")
        }
    }
}


struct SettingsVew: View {
    @State private var columnVisibility = NavigationSplitViewVisibility.automatic
    
    let settings: Array<Setting> = [
        Setting(title: "Action", color: .timerButtonStep, imageName: "square.and.arrow.up.circle"),
        Setting(title: "Timer", color: .timerButtonCancel, imageName: "slider.horizontal.2.arrow.trianglehead.counterclockwise"),
        Setting(title: "Theme", color: .timerButtonStart, imageName: "paintpalette.fill"),
        Setting(title: "Profiles", color: .timerButtonUpdate, imageName: "person.crop.rectangle.stack.fill")
    ]
    
    var body: some View {
        NavigationSplitView (columnVisibility: $columnVisibility){
            List {
                ForEach(settings, id: \.self) { setting in
                    NavigationLink(destination: RootSettingView(viewToDisplay: setting.title)) {
                        HStack {
                            SettingImage(color: setting.color, imageName: setting.imageName)
                            Text(setting.title)
                        }
                    }
                }
            }
            .navigationTitle("PikaSettings")
        } detail: {
            ContentUnavailableView("Select an element from the sidebar", systemImage: "doc.text.image.fill")
        }
    }
}

struct ThemeSettingsView: View {
    var body: some View {
        Text("Theme Settings View")
    }
}

#Preview {
    SettingsVew()
}
