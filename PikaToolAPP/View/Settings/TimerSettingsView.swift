//
//  TimerSettingsView.swift
//  PikaToolAPP
//
//  Created by Gessy Avila on 23/10/24.
//

import SwiftUI

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

#Preview {
    let timerSettings = TimerSettingsStruct.default
    TimerSettingsView(timerSettings: timerSettings)
}
