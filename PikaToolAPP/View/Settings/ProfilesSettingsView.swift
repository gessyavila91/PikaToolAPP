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
    var soundSetting: Int
    var otherSetting: Bool
}

import SwiftUI

class ProfileManager: ObservableObject {
    @Published var profiles: [UserProfile] = []

    @AppStorage("storedProfilesData") private var storedProfilesData: Data?

    init() {
        loadProfilesFromAppStorage()
        
        // Agregar perfiles predeterminados si no hay perfiles almacenados
        if profiles.isEmpty {
            let defaultProfiles = [
                UserProfile(id: UUID(), profileName: "DefaultProfile", soundSetting: 1000, otherSetting: true),
                UserProfile(id: UUID(), profileName: "SilentProfile", soundSetting: 0, otherSetting: false)
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
        saveProfilesToAppStorage()  // Guardar al AppStorage
    }

    func deleteProfile(_ profile: UserProfile) {
        profiles = profiles.filter { $0.id != profile.id }
        saveProfilesToAppStorage()  // Guardar cambios
    }
}




struct CreateProfileModal: View {
    @ObservedObject var profileManager: ProfileManager
    @State private var profileName: String = ""
    @State private var soundSetting: Int = 1000
    @State private var otherSetting: Bool = false

    var body: some View {
        VStack {
            TextField("Profile Name", text: $profileName)
                .padding()

            Picker("Sound Setting", selection: $soundSetting) {
                Text("Option 1").tag(1000)
                Text("Option 2").tag(1001)
            }
            .padding()

            Toggle("Other Setting", isOn: $otherSetting)
                .padding()

            Button("Save") {
                let newProfile = UserProfile(id: UUID(), profileName: profileName, soundSetting: soundSetting, otherSetting: otherSetting)
                profileManager.saveProfile(newProfile)
            }
        }
    }
}

struct AddProfileModal: View {
    @Binding var isPresented: Bool
    @Binding var profiles: [UserProfile]
    @State private var newProfileName: String = ""
    
    var body: some View {
        VStack {
            TextField("Enter Profile Name", text: $newProfileName)
            Button("Save Profile") {
                let newProfile = UserProfile(id: UUID(), profileName: newProfileName, soundSetting: 1000, otherSetting: true)
                profiles.append(newProfile)
                isPresented = false // Cierra el modal
            }
            Button("Cancel") {
                isPresented = false
            }
        }
        .padding()
    }
}

struct ProfilesSettingsView: View {
    @ObservedObject var profileManager: ProfileManager  // Se necesita que sea ObservedObject y no StateObject si se pasa desde fuera
    @State private var newProfileName: String = ""

    var body: some View {
        VStack {
            HStack {
                TextField("New Profile Name", text: $newProfileName)
                Button("Add Profile") {
                    let newProfile = UserProfile(id: UUID(), profileName: newProfileName, soundSetting: 1000, otherSetting: true)
                    profileManager.saveProfile(newProfile)
                }
            }
            .padding()

            // Lista de perfiles
            List(profileManager.profiles) { profile in
                Text(profile.profileName)
            }
        }
    }
}

#Preview {
    ProfilesSettingsView(profileManager: ProfileManager())
}
