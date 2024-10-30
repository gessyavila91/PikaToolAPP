//
//  PikaTimerView.swift
//  PikaToolAPP
//
//  Created by Gessy Avila on 20/10/24.
//

import SwiftUI
import AudioToolbox

struct PikaTimerView: View {
    @State var preTimer:Int = 3_000
    @State var targetFrame:Int = 10_000
    @State var calibration:Int = 0
    @State var frameHit:Int = 0
    
    @StateObject private var model = PikaTimerManager()
    
    @AppStorage("selectedProfileId") private var selectedProfileIdString: String = UUID().uuidString
    @State private var selectedProfile: UserProfileModel = UserProfileModel(id: UUID(), profileName: "DefaultProfile")
    
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    withAnimation {
                        CircularProgressView(
                            progress: $model.progress,
                            stepProgress: $model.stepProgress)
                    }
                    
                    VStack {
                        Text(model.millisecondsToCompletion.asTimestamp)
                            .font(.largeTitle)
                            .monospaced()
                        HStack {
                            Image(systemName: "bell.fill")
                            Text(model.completionDate, format: .dateTime.hour().minute())
                        }
                    }
                }
                .frame(width: 360, height: 200)
                
                HStack{
                    Image(selectedProfile.imageName)
                    Text("Current Profile: \(selectedProfile.profileName)")
                }
                
                List{
                    HStack{
                        Text("Pre timer")
                        Spacer()
                        TextField("Pre Timer", value: $preTimer,format: .number)
                    }
                    HStack{
                        Text("Target Frame")
                        Spacer()
                        TextField("Target Frame", value: $targetFrame,format: .number)
                    }
                    HStack{
                        Text("Calibration")
                        Spacer()
                        TextField("Calibration", value: $calibration,format: .number)
                    }
                    Spacer()
                    HStack{
                        Text("Frame Hit")
                        Spacer()
                        TextField("Frame Hit", value: $frameHit,format: .number)
                    }
                }
                .scrollDisabled(true)
                
                HStack {
                    Button("Update") {
                        print("btn_update")
                    }
                    .buttonStyle(UpdateButtonStyle())
                    
                    Spacer()
                    
                    Button("Start") {
                        print("Start")
                        model.updateCompletionDate()
                        model.start(preTimer: preTimer, targetFrame: targetFrame, calibracion: calibration, steps: 6, maxSteps: 6)
                    }
                    .buttonStyle(StartButtonStyle())
                    
                    Spacer()
                    
                    Button("Cancel") {
                        print("Cancel")
                        model.stop()
                    }
                    .buttonStyle(CancelButtonStyle())
                    
                }
                .padding(.horizontal, 32)
            }
            .toolbar{
                ToolbarItem{
                    ProfileContextualMenuView()
                }
            }
        }
    }
}

struct ProfileContextualMenuView: View{
    @State private var showProfileModal = false
    @State private var showProfileSelectionModal = false
    @State private var selectedProfile: UserProfileModel = UserProfileModel(id: UUID(), profileName: "DefaultProfile")
    @StateObject private var profileManager = ProfileManager()
    
    var body: some View{
        Menu{
            Button {
            } label: {
                Label("SelectProfile", systemImage: "person.2.crop.square.stack")
                Button("Select Profile") {
                    showProfileSelectionModal.toggle()
                }
                .sheet(isPresented: $showProfileSelectionModal) {
                    ProfileSelectionModal(isPresented: $showProfileSelectionModal, selectedProfile: $selectedProfile, profileManager: profileManager)
                }
            }
            Button {
            } label: {
                Label("Update Current Pofile", systemImage: "person.crop.circle.badge.checkmark")
            }
            Button {
            } label: {
                Label("Create new Profile with current Settings", systemImage: "person.crop.circle.badge.plus")
            }
        }
        label: {
            Label("SelectProfile",systemImage: "folder.fill.badge.person.crop")
        }
    }
}

struct ProfileSelectionModal: View {
    @Binding var isPresented: Bool
    @Binding var selectedProfile: UserProfileModel
    
    @ObservedObject var profileManager = ProfileManager()
    
    var body: some View {
        VStack{
            List {
                ForEach(profileManager.profiles) { profile in
                    Button(profile.profileName) {
                        selectedProfile = profile
                        isPresented = false
                    }
                }
            }
        }
        .padding(.all)
    }
}

#Preview {
    PikaTimerView()
}
