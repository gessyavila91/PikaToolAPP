//
//  ProfilesSettingsView.swift
//  PikaToolAPP
//
//  Created by Gessy Avila on 23/10/24.
//

import Foundation
import SwiftUI

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
    let previewProfileManager = ProfileManager() // Instancia simple

    ProfilesSettingsView(profileManager: previewProfileManager)
}
