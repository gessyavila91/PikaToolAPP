//
//  UserProfileModel.swift
//  PikaToolAPP
//
//  Created by Gessy Avila on 29/10/24.
//

import Foundation

struct UserProfileModel: Identifiable, Codable {
    var id: UUID
    var profileName: String
    var preTimer:Int = 3_000
    var targetFrame:Int = 10_000
    var calibration:Int = 0
    var imageName:String = "poke"
    
    var frameHit:Int = 0
}
