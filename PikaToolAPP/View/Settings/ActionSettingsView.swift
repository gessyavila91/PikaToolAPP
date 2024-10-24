//
//  ActionSettingsView.swift
//  PikaToolAPP
//
//  Created by Gessy Avila on 23/10/24.
//

import SwiftUI

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

#Preview {
    ActionSettingsView(selectedActionSound: .constant(.default))
}
