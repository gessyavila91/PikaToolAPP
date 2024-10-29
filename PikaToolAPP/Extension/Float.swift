//
//  Float.swift
//  PikaToolAPP
//
//  Created by Gessy Avila on 29/10/24.
//

import Foundation

extension Float {
    func rounded(toPlaces places: Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }
}
