//
//  ActionSettingsView.swift
//  PikaToolAPP
//
//  Created by Gessy Avila on 23/10/24.
//

import SwiftUI
import AudioToolbox

struct ActionSettingsStruct {
    var actionSound = ActionSound_Enum.TINK
    static let `default` = ActionSettingsStruct(actionSound: ActionSound_Enum.TINK)
    
    enum ActionSound_Enum : Int,CaseIterable,Identifiable{
        case NEW_MAIL = 1000
        case MAIL_SENT = 1001
        case VOICEMAIL = 1002
        case RECEIVEDMESSAGE = 1003
        case SENTMESSAGE = 1004
        case ALARM = 1005
        case LOW_POWER = 1006
        case SMS_RECEIVED1 = 1007
        case SMS_RECEIVED2 = 1008
        case SMS_RECEIVED3 = 1009
        case SMS_RECEIVED4 = 1010
        case SMS_RECEIVED1_2 = 1012
        case SMS_RECEIVED5 = 1013
        case SMS_RECEIVED6 = 1014
        case VOICEMAIL_2 = 1015
        case TWEET_SENT = 1016
        case ANTICIPATE = 1020
        case BLOOM = 1021
        case CALYPSO = 1022
        case CHOO_CHOO = 1023
        case DESCENT = 1024
        case FANFARE = 1025
        case LADDER = 1026
        case MINUET = 1027
        case NEWS_FLASH = 1028
        case NOIR = 1029
        case SHERWOOD_FOREST = 1030
        case SPELL = 1031
        case SUSPENSE = 1032
        case TELEGRAPH = 1033
        case TIPTOES = 1034
        case TYPEWRITERS = 1035
        case UPDATE = 1036
        case USSD = 1050
        case SIMTOOLKITCALLDROPPED = 1051
        case SIMTOOLKITGENERALBEEP = 1052
        case SIMTOOLKITNEGATIVEACK = 1053
        case SIMTOOLKITPOSITIVEACK = 1054
        case SIMTOOLKITSMS = 1055
        case TINK = 1057
        case CT_BUSY = 1070
        case CT_CONGESTION = 1071
        case CT_PATH_ACK = 1072
        case CT_ERROR = 1073
        case CT_CALL_WAITING = 1074
        case CT_KEYTONE2 = 1075
        case LOCK = 1100
        case UNLOCK = 1101
        case TINK2 = 1103
        case TOCK = 1104
        case TOCK2 = 1105
        case BEEP_BEEP = 1106
        case RINGERCHANGED = 1107
        case PHOTOSHUTTER = 1108
        case SHAKE = 1109
        case JBL_BEGIN = 1110
        case JBL_CONFIRM = 1111
        case JBL_CANCEL = 1112
        case BEGIN_RECORD = 1113
        case END_RECORD = 1114
        case JBL_AMBIGUOUS = 1115
        case JBL_NO_MATCH = 1116
        case BEGIN_VIDEO_RECORD = 1117
        case END_VIDEO_RECORD = 1118
        case VC_INVITATION_ACCEPTED = 1150
        case VC_RINGING = 1151
        case VC_ENDED = 1152
        case DTMF_STAR = 1210
        case DTMF_POUND = 1211
        case LONG_LOW_SHORT_HIGH = 1254
        case SHORT_DOUBLE_HIGH = 1255
        case SHORT_LOW_HIGH = 1256
        case SHORT_DOUBLE_LOW = 1257
        
        // Convert to string to display in menus and pickers.
        var id: Int{rawValue}
        
        func stringValue() -> String {
            switch(self) {
            case .NEW_MAIL: return "NEW_MAIL"
            case .MAIL_SENT: return "MAIL_SENT"
            case .VOICEMAIL: return "VOICEMAIL"
            case .RECEIVEDMESSAGE: return "RECEIVEDMESSAGE"
            case .SENTMESSAGE: return "SENTMESSAGE"
            case .ALARM: return "ALARM"
            case .LOW_POWER: return "LOW_POWER"
            case .SMS_RECEIVED1: return "SMS_RECEIVED1"
            case .SMS_RECEIVED2: return "SMS_RECEIVED2"
            case .SMS_RECEIVED3: return "SMS_RECEIVED3"
            case .SMS_RECEIVED4: return "SMS_RECEIVED4"
            case .SMS_RECEIVED1_2: return "SMS_RECEIVED1_2"
            case .SMS_RECEIVED5: return "SMS_RECEIVED5"
            case .SMS_RECEIVED6: return "SMS_RECEIVED6"
            case .VOICEMAIL_2: return "VOICEMAIL_2"
            case .TWEET_SENT: return "TWEET_SENT"
            case .ANTICIPATE: return "ANTICIPATE"
            case .BLOOM: return "BLOOM"
            case .CALYPSO: return "CALYPSO"
            case .CHOO_CHOO: return "CHOO_CHOO"
            case .DESCENT: return "DESCENT"
            case .FANFARE: return "FANFARE"
            case .LADDER: return "LADDER"
            case .MINUET: return "MINUET"
            case .NEWS_FLASH: return "NEWS_FLASH"
            case .NOIR: return "NOIR"
            case .SHERWOOD_FOREST: return "SHERWOOD_FOREST"
            case .SPELL: return "SPELL"
            case .SUSPENSE: return "SUSPENSE"
            case .TELEGRAPH: return "TELEGRAPH"
            case .TIPTOES: return "TIPTOES"
            case .TYPEWRITERS: return "TYPEWRITERS"
            case .UPDATE: return "UPDATE"
            case .USSD: return "USSD"
            case .SIMTOOLKITCALLDROPPED: return "SIMTOOLKITCALLDROPPED"
            case .SIMTOOLKITGENERALBEEP: return "SIMTOOLKITGENERALBEEP"
            case .SIMTOOLKITNEGATIVEACK: return "SIMTOOLKITNEGATIVEACK"
            case .SIMTOOLKITPOSITIVEACK: return "SIMTOOLKITPOSITIVEACK"
            case .SIMTOOLKITSMS: return "SIMTOOLKITSMS"
            case .TINK: return "TINK"
            case .CT_BUSY: return "CT_BUSY"
            case .CT_CONGESTION: return "CT_CONGESTION"
            case .CT_PATH_ACK: return "CT_PATH_ACK"
            case .CT_ERROR: return "CT_ERROR"
            case .CT_CALL_WAITING: return "CT_CALL_WAITING"
            case .CT_KEYTONE2: return "CT_KEYTONE2"
            case .LOCK: return "LOCK"
            case .UNLOCK: return "UNLOCK"
            case .TINK2: return "TINK2"
            case .TOCK: return "TOCK"
            case .TOCK2: return "TOCK2"
            case .BEEP_BEEP: return "BEEP_BEEP"
            case .RINGERCHANGED: return "RINGERCHANGED"
            case .PHOTOSHUTTER: return "PHOTOSHUTTER"
            case .SHAKE: return "SHAKE"
            case .JBL_BEGIN: return "JBL_BEGIN"
            case .JBL_CONFIRM: return "JBL_CONFIRM"
            case .JBL_CANCEL: return "JBL_CANCEL"
            case .BEGIN_RECORD: return "BEGIN_RECORD"
            case .END_RECORD: return "END_RECORD"
            case .JBL_AMBIGUOUS: return "JBL_AMBIGUOUS"
            case .JBL_NO_MATCH: return "JBL_NO_MATCH"
            case .BEGIN_VIDEO_RECORD: return "BEGIN_VIDEO_RECORD"
            case .END_VIDEO_RECORD: return "END_VIDEO_RECORD"
            case .VC_INVITATION_ACCEPTED: return "VC_INVITATION_ACCEPTED"
            case .VC_RINGING: return "VC_RINGING"
            case .VC_ENDED: return "VC_ENDED"
            case .DTMF_STAR: return "DTMF_STAR"
            case .DTMF_POUND: return "DTMF_POUND"
            case .LONG_LOW_SHORT_HIGH: return "LONG_LOW_SHORT_HIGH"
            case .SHORT_DOUBLE_HIGH: return "SHORT_DOUBLE_HIGH"
            case .SHORT_LOW_HIGH: return "SHORT_LOW_HIGH"
            case .SHORT_DOUBLE_LOW: return "SHORT_DOUBLE_LOW"
            }
        }
    }
}

struct ActionSettingsView: View {
    @AppStorage("selectedActionSound") private var selectedSoundId: Int = ActionSettingsStruct.ActionSound_Enum.TINK.rawValue
    
    @State private var selectedActionSound: ActionSettingsStruct.ActionSound_Enum = .TINK
    
    var body: some View {
        VStack {
            HStack{
                Text("Action Settings View")
                Picker("Action Sound Type:", selection: $selectedActionSound) {
                    ForEach(ActionSettingsStruct.ActionSound_Enum.allCases) { sound in
                        Text(sound.stringValue()).tag(sound)
                    }
                }
                .onChange(of: selectedActionSound) { newSound in
                    selectedSoundId = newSound.rawValue
                    playBeepSound(soundId: newSound.rawValue)
                }
            }
            
            Button("Play Selected Sound") {
                playBeepSound(soundId: selectedSoundId)
            }
        }
        .onAppear {
            if let sound = ActionSettingsStruct.ActionSound_Enum(rawValue: selectedSoundId) {
                selectedActionSound = sound
            }
        }
    }
    
    func playBeepSound(soundId: Int) {
        AudioServicesPlaySystemSound(SystemSoundID(soundId))
    }
}

#Preview {
    ActionSettingsView()
}
