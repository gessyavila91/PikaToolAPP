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
        saveProfilesToAppStorage()
    }

    func deleteProfile(_ profile: UserProfile) {
        profiles.removeAll { $0.id == profile.id }
        saveProfilesToAppStorage()
    }
}
class ProfileManagerBU: ObservableObject {
    @Published var profiles: [UserProfile] = []
    
    @AppStorage("storedProfiles") private var storedProfilesData: Data?

    init() {
        // Agregar perfiles predeterminados si no hay perfiles almacenados
        if profiles.isEmpty {
            let defaultProfiles = [
                UserProfile(id: UUID(), profileName: "DefaultProfile"),
                UserProfile(id: UUID(), profileName: "SilentProfile")
            ]
            profiles.append(contentsOf: defaultProfiles)
        }

        loadProfilesFromAppStorage()
    }

    func saveProfile(_ profile: UserProfile) {
        profiles.append(profile)
        saveProfilesToAppStorage()
    }

    func deleteProfile(_ profile: UserProfile) {
        profiles.removeAll { $0.id == profile.id }
        saveProfilesToAppStorage()
    }

    private func saveProfilesToAppStorage() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(profiles) {
            storedProfilesData = encoded
        }
    }

    private func loadProfilesFromAppStorage() {
        let decoder = JSONDecoder()
        if let storedData = storedProfilesData,
           let decodedProfiles = try? decoder.decode([UserProfile].self, from: storedData) {
            profiles = decodedProfiles
        }
    }
}


struct AddProfileModal: View {
    @Binding var isPresented: Bool
    
    @ObservedObject var profileManager: ProfileManager
    
    @State var profileName: String = "newProfile Name"
    @State var preTimer: Int = 3000
    @State var targetFrame: Int = 10_000
    @State var calibration: Int = 0
    @State var imageName: String = "poke"
    
    @State private var otherSetting: Bool = false
    @State private var selectedImage: String = "poke" // Cambiar según los nombres de tus imágenes
    let availableImages = ["poke", "dive", "dream"] // Lista de nombres de imágenes

    var body: some View {
        VStack {
            HStack{
                Text("Profile Name")
                TextField("Profile Name", text: $profileName)
                    .textFieldStyle(.roundedBorder)
                    .padding()
            }
            HStack{
                Text("Image Icon")
                Spacer()
                Picker("Select Image", selection: $selectedImage) {
                    ForEach(availableImages, id: \.self) { image in
                        HStack{
                            Image(image)
                            Text(image).tag(image)
                        }
                    }
                }
                .pickerStyle(.menu)
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
                    let newProfile = UserProfile(id: UUID(), profileName: profileName,imageName: selectedImage)
                    profileManager.saveProfile(newProfile)
                    isPresented = false // Cierra el modal
                }.buttonStyle(.bordered)
            }
        }
        .padding()
    }
}


struct ProfilesSettingsView: View {
    @ObservedObject var profileManager: ProfileManager
    @State private var showModal = false
    @State private var selectedProfile: UserProfile?
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.showModal = true
                }) {
                    Text("Create New Profile")
                }
                .fullScreenCover(isPresented: $showModal) {
                    AddProfileModal(isPresented: $showModal, profileManager: profileManager)
                }
            }
            .padding()

            // Lista de perfiles
            List(profileManager.profiles) { profile in
                HStack {
                    Image(profile.imageName) // Muestra el icono asociado
                    Spacer()
                    Text(profile.profileName)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedProfile = profile
                }
                .swipeActions {
                    Button(role: .destructive) {
                        profileManager.deleteProfile(profile)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                    Button {
                        selectedProfile = profile
                        showModal = true
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                }
            }
        }
        .sheet(item: $selectedProfile) { profile in
            // Modal para editar perfil
            AddProfileModal(isPresented: $showModal, profileManager: profileManager)
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
