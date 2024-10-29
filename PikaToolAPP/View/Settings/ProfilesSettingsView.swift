//
//  ProfilesSettingsView.swift
//  PikaToolAPP
//
//  Created by Gessy Avila on 23/10/24.
//

import Foundation
import SwiftUI

struct UserProfile: Identifiable, Codable {
    var id: UUID
    var profileName: String
    var preTimer:Int = 3_000
    var targetFrame:Int = 10_000
    var calibration:Int = 0
    var imageName:String = "poke"
    
    var frameHit:Int = 0
}


class ProfileManager: ObservableObject {
    @Published var profiles: [UserProfile] = []
    @AppStorage("storedProfilesData") private var storedProfilesData: Data?

    init() {
        loadProfilesFromAppStorage()
        if profiles.isEmpty {
            let defaultProfiles = [
                UserProfile(id: UUID(), profileName: "DefaultProfile"),
                UserProfile(id: UUID(), profileName: "SilentProfile")
            ]
            profiles.append(contentsOf: defaultProfiles)
        }
    }

    func saveProfilesToAppStorage() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(profiles) {
            storedProfilesData = encoded
        }
    }

    func loadProfilesFromAppStorage() {
        let decoder = JSONDecoder()
        if let storedData = storedProfilesData,
           let decodedProfiles = try? decoder.decode([UserProfile].self, from: storedData) {
            profiles = decodedProfiles
        }
    }

    func saveProfile(_ profile: UserProfile) {
        profiles.append(profile)
        saveProfilesToAppStorage()
    }
    
    // Nueva función para actualizar el perfil
    func updateProfile(id: UUID, newProfileName: String, newImageName: String, newPreTimer: Int, newTargetFrame: Int, newCalibration: Int) {
        if let index = profiles.firstIndex(where: { $0.id == id }) {
            profiles[index].profileName = newProfileName
            profiles[index].imageName = newImageName
            profiles[index].preTimer = newPreTimer
            profiles[index].targetFrame = newTargetFrame
            profiles[index].calibration = newCalibration
            saveProfilesToAppStorage()
        }
    }

    func deleteProfile(_ profile: UserProfile) {
        profiles.removeAll { $0.id == profile.id }
        saveProfilesToAppStorage()
    }
}


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


struct ProfilesSettingsView: View {
    @ObservedObject var profileManager: ProfileManager
    @State private var showModal = false
    @State private var selectedProfile: UserProfile? // El perfil que se va a editar

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.selectedProfile = nil // Para crear un nuevo perfil
                    self.showModal = true
                }) {
                    Text("Create New Profile")
                }
                .fullScreenCover(isPresented: $showModal) {
                    AddProfileModal(isPresented: $showModal, profileManager: profileManager, selectedProfile: selectedProfile)
                }
            }
            .padding()

            // Lista de perfiles con swipe y tap para editar
            List {
                ForEach(profileManager.profiles) { profile in
                    HStack {
                        Image(profile.imageName)
                        Text(profile.profileName)
                    }
                    .onTapGesture {
                        // Abrir para editar al tocar
                        selectedProfile = profile
                        showModal = true
                    }
                    // Aquí está el cambio, movemos las acciones swipe al bloque correcto
                    .swipeActions(edge: .trailing) {
                        Button("Edit") {
                            selectedProfile = profile
                            showModal = true
                        }.tint(.blue)
                    }
                }
                .onDelete(perform: deleteProfile)
            }
        }
    }
    
    // Función para eliminar perfiles
    func deleteProfile(at offsets: IndexSet) {
        for index in offsets {
            let profileToDelete = profileManager.profiles[index]
            profileManager.deleteProfile(profileToDelete)
        }
    }
}


#Preview {
    @State var showModal: Bool = true
    let previewProfileManager = ProfileManager() // Instancia simple

    AddProfileModal(isPresented: $showModal, profileManager: previewProfileManager)
}
#Preview {
    let previewProfileManager = ProfileManager() // Instancia simple

    ProfilesSettingsView(profileManager: previewProfileManager)
}
