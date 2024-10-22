//
//  Int+Extension.swift
//  PikaToolAPP
//
//  Created by Gessy Avila on 20/10/24.
//

import Foundation

extension Int {
    var asTimestamp: String {
        // Dividimos el valor total de milisegundos
        let hour = self / 3600000               // 1 hora = 3600000 milisegundos
        let minute = (self / 60000) % 60        // 1 minuto = 60000 milisegundos
        let second = (self / 1000) % 60         // 1 segundo = 1000 milisegundos
        let miliSecond = self % 1000            // El resto son los milisegundos

        // Formateamos la salida en horas, minutos, segundos y milisegundos
        return String(format: "%02i:%02i:%02i.%03i", hour, minute, second, miliSecond)
    }
}

