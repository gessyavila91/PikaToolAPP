//
//  PikaTimerView.swift
//  PikaToolAPP
//
//  Created by Gessy Avila on 20/10/24.
//

import SwiftUI
import AudioToolbox

extension Float {
    func rounded(toPlaces places: Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }
}

class PikaTimer: ObservableObject {
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


    // Function to run the Pre-Timer, which counts up from 0 to maxSteps
    private func runPreTimer() {
        print("Starting preTimer")
        
        // Create the timer source for the preTimer using a global queue
        preTimerDS = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())
        
        // Schedule the timer to fire every 500 milliseconds
        preTimerDS?.schedule(deadline: .now(), repeating: .milliseconds(500))
        var stepCount = 0  // Counter for tracking the steps of the preTimer

        // Event handler for the timer, triggered at each interval
        preTimerDS?.setEventHandler { [weak self] in
            guard let self else { return }

            // Update the UI and step progress on the main thread
            DispatchQueue.main.async {
                self.stepProgress = Float((Float(stepCount) / Float(self.maxSteps)).rounded(toPlaces: 2))
                stepCount += 1  // Increment the step count
                
                // Play a beep sound for every step after the first one
                if stepCount > 1 {
                    self.playBeepSound()
                }
            }

            // If the stepCount reaches maxSteps, start the main timer and cancel the preTimer
            if stepCount == self.maxSteps {
                self.runMainTimer()
                self.preTimerDS?.cancel()
            }
        }

        // Resume the preTimer to start the countdown
        print("Resuming preTimer")
        preTimerDS?.resume()
    }

    // Function to run the End-Timer, which counts up from 0 to maxSteps, similar to the preTimer
    private func runEndTimer(){
        print("Starting EndTimer")
        
        // Reset step progress on the main thread when the endTimer starts
        DispatchQueue.main.async {
            self.stepProgress = 0
        }

        // Create the timer source for the endTimer using a global queue
        endTimerDS = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())
        
        // Schedule the timer to fire every 500 milliseconds
        endTimerDS?.schedule(deadline: .now(), repeating: .milliseconds(500))
        var endStepCount = 0  // Counter for tracking the steps of the endTimer

        // Event handler for the timer, triggered at each interval
        endTimerDS?.setEventHandler { [weak self] in
            guard let self else { return }

            // Update the UI and step progress on the main thread
            DispatchQueue.main.async {
                self.stepProgress = Float((Float(endStepCount) / Float(self.maxSteps)).rounded(toPlaces: 2))
                endStepCount += 1  // Increment the step count
                
                // Play a beep sound for every step after the first one
                if endStepCount > 1 {
                    self.playBeepSound()
                }
            }

            // If the endStepCount reaches maxSteps, stop the endTimer and reset the state
            if endStepCount == self.maxSteps {
                self.endTimerDS?.cancel()
                self.stop()
            }
        }

        // Resume the endTimer to start the countdown
        print("Resuming EndTimer")
        endTimerDS?.resume()
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
        AudioServicesPlaySystemSound(1057)  // ID de sonido de beep
    }
}



struct PikaTimerView: View {
    @State var preTimer:Int = 3_000
    @State var targetFrame:Int = 10_000
    @State var calibration:Int = 0
    @State var frameHit:Int = 0
    
    @StateObject private var model = PikaTimer()
    
    var body: some View {
        
        VStack{
            ZStack {
                withAnimation {
                    CircularProgressView(
                        progress: $model.progress,
                        stepProgress: $model.stepProgress)
                }

                VStack {
                    Text(model.millisecondsToCompletion.asTimestamp)
                        .font(.largeTitle)
                        .monospaced()
                    HStack {
                        Image(systemName: "bell.fill")
                        Text(model.completionDate, format: .dateTime.hour().minute())
                    }
                }
            }
            .frame(width: 360, height: 255)
            .padding(.all, 32)
            
            List{
                HStack{
                    Text("Pre timer")
                    Spacer()
                    TextField("Pre Timer", value: $preTimer,format: .number)
                }
                HStack{
                    Text("Target Frame")
                    Spacer()
                    TextField("Target Frame", value: $targetFrame,format: .number)
                }
                HStack{
                    Text("Calibration")
                    Spacer()
                    TextField("Calibration", value: $calibration,format: .number)
                }
                Spacer()
                HStack{
                    Text("Frame Hit")
                    Spacer()
                    TextField("Frame Hit", value: $frameHit,format: .number)
                }
            }
            HStack {
                Button("Update") {
                    print("btn_update")
                }
                .buttonStyle(UpdateButtonStyle())
                
                Spacer()

                Button("Start") {
                    print("Start")
                    model.updateCompletionDate()
                    model.start(preTimer: preTimer, targetFrame: targetFrame, calibracion: calibration, steps: 6, maxSteps: 6)
                }
                .buttonStyle(StartButtonStyle())
                
                Spacer()
                
                Button("Cancel") {
                    print("Cancel")
                    model.stop()
                }
                .buttonStyle(CancelButtonStyle())

            }
            .padding(.horizontal, 32)
        }
    }
}

#Preview {
    PikaTimerView()
}
