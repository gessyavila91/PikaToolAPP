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
        // Agregar perfiles predeterminados si no hay perfiles almacenados
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
        saveProfilesToAppStorage()  // Guardar al AppStorage
    }

    func deleteProfile(_ profile: UserProfile) {
        profiles = profiles.filter { $0.id != profile.id }
        saveProfilesToAppStorage()  // Guardar cambios
    }
}

struct AddProfileModal: View {
    @Binding var isPresented: Bool
    
    @ObservedObject var profileManager = ProfileManager()
    
    @State var profileName: String = "newProfile Name"
    @State var preTimer: Int = 3000
    @State var targetFrame: Int = 10_000
    @State var calibration: Int = 0
    @State var imageName: String = "Poke"

    @State private var otherSetting: Bool = false
    
    var body: some View {
        VStack {
            HStack{
                Text("Profile Name")
                TextField("Profile Name", text: $profileName)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.numberPad)
                    .padding()
            }
            HStack{
                Text("Image Icon")
                TextField("Image Icon", text: $imageName)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.numberPad)
                    .padding()
            }
            HStack{
                Text("Pre Timer")
                TextField("Pre Timer", value: $preTimer, format: .number)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.numberPad)
                    .padding()
            }
            HStack{
                Text("Target Frame")
                TextField("Target Frame", value: $targetFrame, format: .number)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.numberPad)
                    .padding()
            }
            HStack{
                Text("Calibration")
                TextField("Calibration", value: $calibration, format: .number)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.numberPad)
                    .padding()
            }
            HStack{
                Button("Cancel") {
                    isPresented = false
                }.buttonStyle(.bordered)
                Spacer()
                Button("Save Profile") {
                    let newProfile = UserProfile(
                        id: UUID(),
                        profileName: profileName,
                        preTimer:preTimer,
                        targetFrame:targetFrame,
                        calibration:calibration,
                        imageName:imageName
                    )
                    profileManager.saveProfile(newProfile)
                    isPresented = false // Cierra el modal
                }.buttonStyle(.bordered)
            }
            
        }
        .padding()
    }
}

struct ProfilesSettingsView: View {
    // Se necesita que sea ObservedObject y no StateObject si se pasa desde fuera
    @ObservedObject var profileManager: ProfileManager
    @State private var showModal = false

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.showModal = true
                }) {
                    Text("CreateNewProfile")
                }
                .fullScreenCover(isPresented: $showModal) {
                    AddProfileModal(isPresented: $showModal)
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
    @Previewable @State var showModal:Bool = true
    return AddProfileModal(isPresented: $showModal)
}
#Preview {
    ProfilesSettingsView(profileManager: ProfileManager())
}
