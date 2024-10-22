//
//  PikaTimerView.swift
//  PikaToolAPP
//
//  Created by Gessy Avila on 20/10/24.
//

import SwiftUI

class PikaTimer: ObservableObject {
    @Published var millisecondsToCompletion: Int = 0
    @Published var progress: Float = 0.0
    @Published var stepProgress: Float = 0.0

    private var timer: DispatchSourceTimer?
    private var preTimer: Int = 0
    private var targetFrame: Int = 0
    private var calibracion: Int = 0
    private var steps: Int = 0
    private var maxSteps: Int = 10

    func start(preTimer: Int, targetFrame: Int, calibracion: Int, steps: Int, maxSteps: Int) {
        stop() // Cancelar el temporizador previo si existe
        
        self.preTimer = preTimer
        self.targetFrame = targetFrame
        self.calibracion = calibracion
        self.steps = steps
        self.maxSteps = maxSteps

        self.millisecondsToCompletion = targetFrame + calibracion
        runPreTimer()
    }


    private func runPreTimer() {
        print("Iniciando preTimer")

        timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())
        timer?.schedule(deadline: .now(), repeating: .milliseconds(500))
        var stepCount = 0

        timer?.setEventHandler { [weak self] in
            guard let self else { return }

            stepCount += 1
            DispatchQueue.main.async {
                self.stepProgress = Float(stepCount) / Float(self.maxSteps)
            }

            // Imprimir el progreso de los steps
            print("Step Progress: \(self.stepProgress)")

            if stepCount >= self.maxSteps {
                print("StepCount ha alcanzado el máximo: \(self.maxSteps)")
                self.timer?.cancel()
                print("PreTimer completado, iniciando Main Timer")
                self.runMainTimer()
            }
        }

        // Asegúrate de reanudar el temporizador
        print("Reanudando preTimer")
        timer?.resume()
    }

    private func runMainTimer() {
        print("Iniciando Main Timer")

        let totalTargetTime = targetFrame + calibracion
        let startTime = DispatchTime.now()

        timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())
        timer?.schedule(deadline: .now(), repeating: .milliseconds(1))

        timer?.setEventHandler { [weak self] in
            guard let self else { return }

            let elapsed = DispatchTime.now().uptimeNanoseconds - startTime.uptimeNanoseconds
            let elapsedMs = Int(elapsed / 1_000_000)

            DispatchQueue.main.async {
                self.millisecondsToCompletion = max(0, totalTargetTime - elapsedMs)
                self.progress = Float(self.millisecondsToCompletion) / Float(totalTargetTime)
            }

            // Imprimir los milisegundos restantes
            print("Milliseconds to completion: \(self.millisecondsToCompletion)")
            print("Progreso general: \(self.progress)")

            if self.millisecondsToCompletion <= 0 {
                print("Main Timer completado, reiniciando PreTimer")
                self.timer?.cancel()
                // self.runPreTimer()
            }
        }

        // Asegúrate de reanudar el temporizador
        print("Reanudando Main Timer")
        timer?.resume()
    }
    func stop() {
        timer?.cancel()
    }
}



struct PikaTimerView: View {
    @State var preTimer:Int = 3000
    @State var targetFrame:Int = 4500
    @State var calibration:Int = 0
    @State var frameHit:Int = 0
    
    @StateObject private var modelTimer = TimerViewModel()
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
                    HStack {
                        Image(systemName: "bell.fill")
                        Text(modelTimer.completionDate, format: .dateTime.hour().minute())
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
