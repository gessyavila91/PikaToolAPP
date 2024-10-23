//
//  SettingsVew.swift
//  PikaToolAPP
//
//  Created by Gessy Avila on 22/10/24.
//

import SwiftUI
import Foundation

struct SettingsVew: View {
    var body: some View {
        NavigationSplitView {
            List {
                NavigationLink("Action", destination: ActionSettingsView(
                    selectedActionSound: .constant(.default)
                ))
                NavigationLink("Timer", destination: TimerSettingsVew(
                    timerSettings: .constant(.default)
                ))
                Spacer()
                NavigationLink("Profiles", destination: ProfilesSettingsVew())
            }
            .navigationTitle("Sidebar")
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

struct TimerSettingsStruct {
    var settingsFPS = TimerSettingsFPS_enum.GBA_FPS
    var settingsConsole = Console_enum.GBA
    
    static let `default` = TimerSettingsStruct(
        settingsFPS: .GBA_FPS,
        settingsConsole: .GBA)
    
    enum TimerSettingsFPS_enum: Double, CaseIterable {
        case GBA_FPS = 59.7275
        case NDS_SLOT1_FPS = 59.8261
        case NDS_SLOT2_FPS = 59.6555

        func framerate() -> Double {
            1000 / self.rawValue
        }
        
        func stringValue() -> String {
            switch self {
            case .GBA_FPS: return "GBA_FPS"
            case .NDS_SLOT1_FPS: return "NDS_SLOT1_FPS"
            case .NDS_SLOT2_FPS: return "NDS_SLOT2_FPS"
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

struct TimerSettingsVew: View {
    @Binding var timerSettings: TimerSettingsStruct
    
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


struct ProfilesSettingsVew: View {
    var body: some View {
        Text("Action Settings View")
    }
}

#Preview {
    SettingsVew()
}
