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
            ActionSettingsView(selectedActionSound: .constant(.default))
        case "Timer":
            TimerSettingsView(timerSettings: timerSettings)
        case "Profiles":
            ProfilesSettingsView()
        case "Theme":
            ProfilesSettingsView()
        default:
            RootSettingView(viewToDisplay: "")
        }
    }
}


struct SettingsVew: View {
    let settings: Array<Setting> = [
        Setting(title: "Action", color: .timerButtonStep, imageName: "square.and.arrow.up.circle"),
        Setting(title: "Timer", color: .timerButtonCancel, imageName: "slider.horizontal.2.arrow.trianglehead.counterclockwise"),
        Setting(title: "Theme", color: .green, imageName: "paintpalette.fill"),
        Setting(title: "Profiles", color: .blue, imageName: "person.crop.rectangle.stack.fill")
    ]
    
    var body: some View {
        NavigationSplitView {
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

struct ActionSettingsStruct {
    var actionSound = ActionSound_Enum.BEEP
    static let `default` = ActionSettingsStruct(actionSound: ActionSound_Enum.BEEP)
    
    enum ActionSound_Enum : Int,CaseIterable,Identifiable{
        case BEEP = 1057// BEEP
        case BOOP = 1050// BEEP
        
        // Convert to string to display in menus and pickers.
        var id: Int{rawValue}
        
        func stringValue() -> String {
            switch(self) {
            case .BEEP:
                return "BEEP"
            case .BOOP:
                return "BOOP"
            }
        }
    }
}

struct ActionSettingsView: View {
    @Binding var selectedActionSound: ActionSettingsStruct
    
    var body: some View {
        Text("Action Settings View")
        VStack {
            HStack{
                Picker("Action Sound Type:", selection: $selectedActionSound.actionSound) {
                    ForEach(ActionSettingsStruct.ActionSound_Enum.allCases) { sound in
                        Text("\(sound.stringValue())").tag(sound)
                    }
                }
            }
        }
    }
}

class TimerSettingsStruct: ObservableObject {
    @Published var settingsFPS: TimerSettingsFPS_enum = .GBA_FPS
    @Published var settingsConsole: Console_enum = .GBA
    
    static let `default` = TimerSettingsStruct()
    
    enum TimerSettingsFPS_enum: Double, CaseIterable {
        case GBA_FPS = 59.7275
        case NDS_SLOT1_FPS = 59.8261
        case NDS_SLOT2_FPS = 59.6555
        case CUSTOM = 60.00

        func framerate() -> Double {
            return 1000 / self.rawValue
        }
        
        func stringValue() -> String {
            switch self {
            case .GBA_FPS: return "GBA_FPS"
            case .NDS_SLOT1_FPS: return "NDS_SLOT1_FPS"
            case .NDS_SLOT2_FPS: return "NDS_SLOT2_FPS"
            case .CUSTOM: return "CUSTOM"
            }
        }
    }
    
    enum Console_enum: String, CaseIterable, Identifiable {
        case GBA = "GBA"
        case NDS_SLOT1 = "NDS - Slot 1"
        case NDS_SLOT2 = "NDS - Slot 2"
        case DSI = "DSI"
        case THREE_DS = "3DS"
        case CUSTOM = "Custom"
        
        var id: String { rawValue }
        
        func fps() -> Double {
            switch self {
            case .GBA: return TimerSettingsFPS_enum.GBA_FPS.rawValue
            case .NDS_SLOT2: return TimerSettingsFPS_enum.NDS_SLOT2_FPS.rawValue
            case .NDS_SLOT1, .DSI, .THREE_DS: return TimerSettingsFPS_enum.NDS_SLOT1_FPS.rawValue
            case .CUSTOM: return 60.0
            }
        }
    }
}

struct TimerSettingsView: View {
    @ObservedObject var timerSettings: TimerSettingsStruct
    
    var body: some View {
        VStack {
            HStack {
                Picker("Timer FPS:", selection: $timerSettings.settingsFPS) {
                    ForEach(TimerSettingsStruct.TimerSettingsFPS_enum.allCases, id: \.self) { fps in
                        Text(fps.stringValue()).tag(fps)
                    }
                }
                Text("FPS: \(timerSettings.settingsFPS.rawValue)")
            }
        }
    }
}

struct ProfilesSettingsView: View {
    var body: some View {
        Text("Action Settings View")
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
