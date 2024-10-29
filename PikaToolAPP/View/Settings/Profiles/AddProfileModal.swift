//
//  AddProfileModal.swift
//  PikaToolAPP
//
//  Created by Gessy Avila on 29/10/24.
//

import SwiftUI

struct AddProfileModal: View {
    @Binding var isPresented: Bool
    @ObservedObject var profileManager: ProfileManager
    @State var selectedProfile: UserProfile? // El perfil que se está editando
    
    @State var profileName: String = "New Profile Name"
    @State var preTimer: Int = 3000
    @State var targetFrame: Int = 10_000
    @State var calibration: Int = 0
    @State var imageName: String = "poke"
    
    @State private var selectedImage: String = "poke"
    let availableImages = ["beast","dusk","gigaton","hisuian-great","jet","lure","nest","poke","safari","ultra","cherish","fast","great","hisuian-heavy","leaden","luxury","net","premier","sport","wing","dive","feather","heal","hisuian-poke","level","master","origin","quick","strange"]
    
    var body: some View {
        VStack {
            HStack {
                Text("Profile Name")
                Spacer()
                TextField("Profile Name", text: $profileName)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 200)
                    .padding()
            }
            
            HStack {
                Text("Image Icon")
                Spacer()
                Picker("Select Image", selection: $selectedImage) {
                    ForEach(availableImages, id: \.self) { image in
                        HStack {
                            Image(image)
                            Text(image).tag(image)
                        }
                    }
                }
                .pickerStyle(.menu)
                .padding()
            }
            
            HStack {
                Text("Pre Timer")
                Spacer()
                TextField("Pre Timer", value: $preTimer, format: .number)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.numberPad)
                    .frame(width: 200)
                    .padding()
            }
            
            HStack {
                Text("Target Frame")
                Spacer()
                TextField("Target Frame", value: $targetFrame, format: .number)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.numberPad)
                    .frame(width: 200)
                    .padding()
            }
            
            HStack {
                Text("Calibration")
                Spacer()
                TextField("Calibration", value: $calibration, format: .number)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 200)
                    .keyboardType(.numberPad)
                    .padding()
            }
            
            HStack {
                Button("Cancel") {
                    isPresented = false
                }
                .buttonStyle(.bordered)
                .tint(.pink)
                Spacer()
                Button("Save Profile") {
                    if let selectedProfile = selectedProfile {
                        // Actualizar el perfil existente
                        profileManager.updateProfile(id: selectedProfile.id, newProfileName: profileName, newImageName: selectedImage, newPreTimer: preTimer, newTargetFrame: targetFrame, newCalibration: calibration)
                    } else {
                        // Crear un nuevo perfil
                        let newProfile = UserProfile(id: UUID(), profileName: profileName, preTimer: preTimer,targetFrame: targetFrame,calibration: calibration,imageName: selectedImage)
                        profileManager.saveProfile(newProfile)
                    }
                    isPresented = false // Cerrar modal
                }
                .buttonStyle(.bordered)
                .tint(.green)
            }
        }
        .padding()
        .onAppear {
            if let selectedProfile = selectedProfile {
                // Cargar datos del perfil seleccionado en los campos
                profileName = selectedProfile.profileName
                selectedImage = selectedProfile.imageName
                preTimer = selectedProfile.preTimer
                targetFrame = selectedProfile.targetFrame
                calibration = selectedProfile.calibration
            }
        }
    }
}

#Preview {
    @State var showModal: Bool = true
    let previewProfileManager = ProfileManager() // Instancia simple

    AddProfileModal(isPresented: $showModal, profileManager: previewProfileManager)
}
