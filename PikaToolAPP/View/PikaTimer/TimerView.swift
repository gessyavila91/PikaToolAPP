//
//  TimerView.swift
//  PikaToolAPP
//
//  Created by Gessy Avila on 20/10/24.
//

import SwiftUI
import AVFoundation

final class TimerViewModel: ObservableObject {
    // Represents the different states the timer can be in
    enum TimerState {
        case active
        // case paused
        case resumed
        case cancelled
    }

    // MARK: Private Properties
    private var timer = Timer()
    private var totalTimeForCurrentSelection: Int {
        (selectedHoursAmount * 3600000) + (selectedMinutesAmount * 60000) + (selectedSecondsAmount * 1000)
    }
    
    // MARK: Public Properties
    @Published var selectedHoursAmount = 0
    @Published var selectedMinutesAmount = 2
    @Published var selectedSecondsAmount = 1
    @Published var selectedMiliSedondsAmount = 999
    
    @Published var state: TimerState = .cancelled {
        didSet {
            switch state {
            case .cancelled:
                timer.invalidate()
                millisecondsToCompletion = 0
                progress = 0
                stepProgress = 0
                stepCount = 0
                
            case .active:
                startTimer()

                millisecondsToCompletion = totalTimeForCurrentSelection
                progress = 1.0
                stepProgress = 1.0

                updateCompletionDate()
//            case .paused:
//                timer.invalidate()
            case .resumed:
                startTimer()
                updateCompletionDate()
            }
        }
    }

    // Powers the ProgressView
    @Published var millisecondsToCompletion = 0
    @Published var progress: Float = 0.0
    @Published var completionDate = Date.now

    let hoursRange = 0...23
    let minutesRange = 0...59
    let secondsRange = 0...59
    let miliSecondsRange = 0...999

    // MARK: config properties
    @Published var preTimerms = 300
    @Published var stepInterval = 500
    @Published var stepProgress: Float = 0.0
    @Published var stepTimer = 500
    @Published var maxStepCount = 6
    @Published var stepCount = 0
        
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true, block: { [weak self] _ in
            guard let self else { return }

            // Restar 50 ms por cada iteración
            self.millisecondsToCompletion -= 1
            if millisecondsToCompletion % 50 == 0 { // Actualizar UI cada 50 ms
                DispatchQueue.main.async {
                    self.progress = Float(self.millisecondsToCompletion) / Float(self.totalTimeForCurrentSelection)
                    self.stepProgress = Float(self.stepTimer) / Float(self.stepInterval)
                }
            }
            
            if self.millisecondsToCompletion < 0 {
                self.state = .cancelled
            }

            // Calcular el progreso del paso basado en 500 ms
            if self.stepTimer <= 0 && (self.stepCount <= self.maxStepCount) {
                self.stepTimer = 500 // Resetear el temporizador de paso a 500 ms
                self.stepCount += 1  // Incrementar el contador de pasos
            } else if self.stepCount < self.maxStepCount {
                self.stepTimer -= 1 // Restar 50 ms por iteración
            }
            
            print("Progress: \(progress)")
            print("stepProgress: \(stepProgress)")
            print("StepCount: \(stepCount)")
        })
    }


    private func updateCompletionDate() {
        completionDate = Date.now.addingTimeInterval(Double(millisecondsToCompletion))
    }
}

struct TimerView: View {
    @StateObject private var model = TimerViewModel()

var timerControls: some View {
    HStack {
        Button("Cancel") {
            model.state = .cancelled
        }
        .buttonStyle(CancelButtonStyle())

        Spacer()

        switch model.state {
        case .cancelled:
            Button("Start") {
//                model.state = .active
                
            }
            .buttonStyle(StartButtonStyle())
//        case .paused:
//            Button("Resume") {
//                model.state = .resumed
//            }
//            .buttonStyle(PauseButtonStyle())
        case .active, .resumed:
            Button("Pause") {
                model.state = .active
            }
            .buttonStyle(PauseButtonStyle())
        }
    }
    .padding(.horizontal, 32)
}

var timePickerControl: some View {
    HStack() {
        TimePickerView(title: "hours", range: model.hoursRange, binding: $model.selectedHoursAmount)
        TimePickerView(title: "min", range: model.minutesRange, binding: $model.selectedMinutesAmount)
        TimePickerView(title: "sec", range: model.secondsRange, binding: $model.selectedSecondsAmount)
    }
    .frame(width: 360, height: 255)
    .padding(.all, 32)
}

var progressView: some View {
    
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
                Text(model.completionDate, format: .dateTime.hour().minute())
            }
        }
    }
    .frame(width: 360, height: 255)
    .padding(.all, 32)
}

var body: some View {
    VStack {
        if model.state == .cancelled {
            timePickerControl
        } else {
            progressView
        }

        timerControls
        Spacer()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.black)
    .foregroundColor(.white)
}
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
    }
}
