//
//  PikaTimerView.swift
//  PikaToolAPP
//
//  Created by Gessy Avila on 20/10/24.
//

import SwiftUI

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


    private func runPreTimer() {
        print("Iniciando preTimer")

        preTimerDS = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())
        preTimerDS?.schedule(deadline: .now(), repeating: .milliseconds(500))
        var stepCount = 0

        preTimerDS?.setEventHandler { [weak self] in
            guard let self else { return }
            
            DispatchQueue.main.async {
                self.stepProgress = Float((Float(stepCount) / Float(self.maxSteps)).rounded(toPlaces: 2))
            }

            if stepCount >= self.maxSteps {
                self.runMainTimer()
                self.preTimerDS?.cancel()
            }
            stepCount += 1
        }
        // Asegúrate de reanudar el temporizador
        print("Reanudando preTimer")
        preTimerDS?.resume()
    }
    
    private func runEndTimer(){
        var endStepCount = self.maxSteps
        
        endTimerDS = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())
        endTimerDS?.schedule(deadline: .now(), repeating: .milliseconds(500))

        endTimerDS?.setEventHandler { [weak self] in
            guard let self else { return }
            
            DispatchQueue.main.async {
                self.stepProgress = Float((Float(endStepCount) / Float(self.maxSteps)).rounded(toPlaces: 2))
            }

            if stepProgress <= 0 {
                self.endTimerDS?.cancel()
                self.stop()
            }
            endStepCount -= 1
            print("stepProgress: \(stepProgress)")
        }
        print("Reanudando EndTimer")
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
        self.millisecondsToCompletion = 0
        self.progress = 0.0
        self.stepProgress = 0.0
        
        completionDate = Date.now

        self.preTimer = 0
        self.targetFrame = 0
        self.calibracion = 0
        self.steps = 0
        self.maxSteps  = 6
    }
    func updateCompletionDate() {
        completionDate = Date.now.addingTimeInterval(Double(self.targetFrame))
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
