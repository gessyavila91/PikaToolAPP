import XCTest
@testable import PikaToolAPP

class ProfileManagerTests: XCTestCase {
    var profileManager: ProfileManager!
    
    override func setUp() {
        super.setUp()
        profileManager = ProfileManager()
    }
    
    override func tearDown() {
        profileManager = nil
        super.tearDown()
    }
    
    
    func testSaveProfileAddsProfile() {
        let newProfile = UserProfileModel(id: UUID(), profileName: "TestProfile")
        profileManager.saveProfile(newProfile)
        XCTAssertTrue(profileManager.profiles.contains { $0.id == newProfile.id })
    }
    
    func testFindProfileByName() {
        let profileName = "FetchProfile"
        let newProfile = UserProfileModel(profileName: profileName)
        profileManager.saveProfile(newProfile)
        let fetchProfile = profileManager.getProfile(profileName: profileName)
        
        XCTAssertEqual(fetchProfile?.profileName, profileName)
    }
    
    func testUpdateProfileModifiesExistingProfile() {
        let existingProfile = profileManager.profiles[0]
        let updatedName = "UpdatedProfileName"
        
        profileManager.updateProfile(id: existingProfile.id, newProfileName: updatedName, newImageName: "updatedImage", newPreTimer: 1000, newTargetFrame: 2000, newCalibration: 100)
        
        if let updatedProfile = profileManager.profiles.first(where: { $0.id == existingProfile.id }) {
            XCTAssertEqual(updatedProfile.profileName, updatedName)
            XCTAssertEqual(updatedProfile.imageName, "updatedImage")
            XCTAssertEqual(updatedProfile.preTimer, 1000)
            XCTAssertEqual(updatedProfile.targetFrame, 2000)
            XCTAssertEqual(updatedProfile.calibration, 100)
        } else {
            XCTFail("El perfil no se actualizó correctamente")
        }
    }
    
    func testDeleteProfileRemovesProfile() {
        let profileToDelete = profileManager.profiles[0]
        profileManager.deleteProfile(profileToDelete)
        
        XCTAssertFalse(profileManager.profiles.contains { $0.id == profileToDelete.id })
    }
    

}
