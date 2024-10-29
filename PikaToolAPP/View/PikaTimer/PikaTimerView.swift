//
//  PikaTimerView.swift
//  PikaToolAPP
//
//  Created by Gessy Avila on 20/10/24.
//

import SwiftUI
import AudioToolbox

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

struct PikaTimerView: View {
    @State var preTimer:Int = 3_000
    @State var targetFrame:Int = 10_000
    @State var calibration:Int = 0
    @State var frameHit:Int = 0
    
    @StateObject private var model = PikaTimerManager()
    @StateObject private var profileManager = ProfileManager()
    
    @State private var showProfileModal = false
    
    @AppStorage("selectedProfileId") private var selectedProfileIdString: String = UUID().uuidString
    @State private var selectedProfile: UserProfileModel = UserProfileModel(id: UUID(), profileName: "DefaultProfile")
    
    @State private var showProfileSelectionModal = false
    
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
                .frame(width: 360, height: 255)
                .padding(.all, 32)
                
                Text("Current Profile: \(selectedProfile.profileName)")
                                    .padding()
                
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
            .navigationTitle("PikaTimer")
            .navigationBarItems(trailing:HStack {
                Button("Select Profile") {
                    showProfileSelectionModal.toggle()
                }
                .sheet(isPresented: $showProfileSelectionModal) {
                    ProfileSelectionModal(isPresented: $showProfileSelectionModal, selectedProfile: $selectedProfile, profileManager: profileManager)
                }
            })
        }
    }
}

#Preview {
    PikaTimerView()
}
