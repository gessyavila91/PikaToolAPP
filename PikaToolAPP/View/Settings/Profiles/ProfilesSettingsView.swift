//
//  ProfilesSettingsView.swift
//  PikaToolAPP
//
//  Created by Gessy Avila on 23/10/24.
//

import Foundation
import SwiftUI

struct ProfilesSettingsView: View {
    @ObservedObject var profileManager: ProfileManager
    @State private var showModal = false
    @State private var selectedProfile: UserProfileModel? // El perfil que se va a editar

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
