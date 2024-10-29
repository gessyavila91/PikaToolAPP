//
//  PikaTimerManager.swift
//  PikaToolAPP
//
//  Created by Gessy Avila on 29/10/24.
//

import Foundation
import SwiftUI
import AudioToolbox

class PikaTimerManager: ObservableObject {
    @AppStorage("selectedActionSound") private var selectedSoundId: Int = ActionSettingsStruct.ActionSound_Enum.TINK.rawValue
    
    @Published var millisecondsToCompletion: Int = 0
    @Published var progress: Float = 0.0
    @Published var stepProgress: Float = 0.0
    
    @Published var completionDate = Date.now
    
    private var preTimerDS: DispatchSourceTimer?
    private var mainTimerDS: DispatchSourceTimer?
    private var endTimerDS: DispatchSourceTimer?
    
    private var preTimer: Int = 0
    private var targetFrame: Int = 0
    private var calibracion: Int = 0
    private var steps: Int = 0
    private var maxSteps: Int = 6
    
    enum PikaTimerState {
        case active
        case resumed
        case cancelled
    }
    
    func start(preTimer: Int, targetFrame: Int, calibracion: Int, steps: Int, maxSteps: Int) {
        stop()
        
        self.preTimer = preTimer
        self.targetFrame = targetFrame
        self.calibracion = calibracion
        self.steps = steps
        self.maxSteps = maxSteps
        
        self.millisecondsToCompletion = targetFrame + calibracion
        updateCompletionDate()
        runPreTimer()
    }
    
    // Function to run a timer that counts steps up to maxSteps
    private func runTimer(isPreTimer: Bool) {
        let timerType = isPreTimer ? "preTimer" : "endTimer"
        print("Starting \(timerType)")
        
        // Reset step progress on the main thread when the timer starts
        DispatchQueue.main.async {
            self.stepProgress = 0
        }
        
        let timerSource = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())
        timerSource.schedule(deadline: .now(), repeating: .milliseconds(500))
        var stepCount = 0
        
        timerSource.setEventHandler { [weak self] in
            guard let self else { return }
            
            DispatchQueue.main.async {
                self.stepProgress = Float((Float(stepCount) / Float(self.maxSteps)).rounded(toPlaces: 2))
                stepCount += 1
                
                if stepCount > 1 {
                    self.playBeepSound()
                }
            }
            
            // If maxSteps is reached, either start main timer or stop
            if stepCount == self.maxSteps {
                timerSource.cancel()
                isPreTimer ? self.runMainTimer() : self.stop()
            }
        }
        
        print("Resuming \(timerType)")
        timerSource.resume()
        
        // Assign the created timer source to the corresponding variable
        if isPreTimer {
            preTimerDS = timerSource
        } else {
            endTimerDS = timerSource
        }
    }
    
    // Wrapper functions for running the preTimer and endTimer
    private func runPreTimer() {
        runTimer(isPreTimer: true)
    }
    
    private func runEndTimer() {
        runTimer(isPreTimer: false)
    }
    
    
    private func runMainTimer() {
        let totalTargetTime = targetFrame + calibracion
        let startTime = DispatchTime.now()
        
        var endTimerFlag = false
        
        mainTimerDS = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())
        mainTimerDS?.schedule(deadline: .now(), repeating: .milliseconds(1))
        
        mainTimerDS?.setEventHandler { [weak self] in
            guard let self else { return }
            
            let elapsed = DispatchTime.now().uptimeNanoseconds - startTime.uptimeNanoseconds
            let elapsedMs = Int(elapsed / 1_000_000)
            
            DispatchQueue.main.async {
                self.millisecondsToCompletion = max(0, totalTargetTime - elapsedMs)
                
                if abs(self.progress - Float(self.millisecondsToCompletion) / Float(totalTargetTime)) > 0.001 {
                    self.progress = Float((Float(self.millisecondsToCompletion) / Float(totalTargetTime)).rounded(toPlaces: 2))
                }
            }
            
            if (self.millisecondsToCompletion <= (self.maxSteps*500) && !endTimerFlag) {
                print("Main Timer terminando: \(self.millisecondsToCompletion) iniciando endTimer")
                endTimerFlag = true
                runEndTimer()
            }
        }
        
        // Asegúrate de reanudar el temporizador
        print("Reanudando Main Timer")
        mainTimerDS?.resume()
    }
    func stop() {
        preTimerDS?.cancel()
        mainTimerDS?.cancel()
        endTimerDS?.cancel()
        
    }
    func updateCompletionDate() {
        completionDate = Date.now.addingTimeInterval(Double(self.targetFrame))
    }
    func playBeepSound() {
        AudioServicesPlaySystemSound(SystemSoundID(selectedSoundId))
    }
}
