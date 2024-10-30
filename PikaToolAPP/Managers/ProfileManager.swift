//
//  ProfileManager.swift
//  PikaToolAPP
//
//  Created by Gessy Avila on 29/10/24.
//

import Foundation
import SwiftUI

class ProfileManager: ObservableObject {
    @Published var profiles: [UserProfileModel] = []
    @AppStorage("storedProfilesData") private var storedProfilesData: Data?

    init() {
        loadProfilesFromAppStorage()
        if profiles.isEmpty {
            let defaultProfiles = [
                UserProfileModel(id: UUID(), profileName: "DefaultProfile"),
                UserProfileModel(id: UUID(), profileName: "SilentProfile")
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
           let decodedProfiles = try? decoder.decode([UserProfileModel].self, from: storedData) {
            profiles = decodedProfiles
        }
    }

    func saveProfile(_ profile: UserProfileModel) {
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
    
    func getProfile(profileName: String) -> UserProfileModel?{
        if let index = profiles.firstIndex(where: { $0.profileName == profileName }) {
            print(profiles[index].profileName)
            return profiles[index]
        }else{
            return nil
        }
    }

    func deleteProfile(_ profile: UserProfileModel) {
        profiles.removeAll { $0.id == profile.id }
        saveProfilesToAppStorage()
    }
}
