//
//  PikaTimerView.swift
//  PikaToolAPP
//
//  Created by Gessy Avila on 20/10/24.
//

import SwiftUI

struct PikaTimerView: View {
    @State var preTimer:String = "3000"
    @State var targetFrame:String = "3000"
    @State var calibration:String = "3000"
    @State var frameHit:String = "3000"
    
    @StateObject private var model = TimerViewModel()
    
    var body: some View {
        
        VStack{
            VStack(alignment: .center){
                ZStack {
                    withAnimation {
                        CircularProgressView(progress: $model.progress,
                                             
                                             stepProgress: $model.stepProgress)
                    }

                    VStack {
                        Text(model.millisecondsToCompletion.asTimestamp)
                            .font(.largeTitle)
                            .monospaced()
                            
                        HStack {
                            Image(systemName: "bell.fill")
                            
                            Text("End Time \(model.completionDate, format: .dateTime.hour().minute())")
                        }
                    }
                }
                .frame(width: 360, height: 255)
                .padding(.all, 32)
                HStack{
                    Text("Next Phase: 327:582")
                    
                }
                HStack{
                    Text("Minutes Before Target: 5")
                }
            }
            .padding(.all,5)
            
            VStack(alignment: .leading){
                
            }
            List{
                HStack{
                    Text("Pre timer")
                    Spacer()
                    TextField("Pre Timer", text: $preTimer)
                }
                HStack{
                    Text("Target Frame")
                    Spacer()
                    TextField("Target Frame", text: $targetFrame)
                }
                HStack{
                    Text("Calibration")
                    Spacer()
                    TextField("Calibration", text: $calibration)
                }
                Spacer()
                HStack{
                    Text("Frame Hit")
                    Spacer()
                    TextField("Frame Hit", text: $frameHit)
                }
            }
            HStack {

                Button("Update") {
                    model.state = .cancelled
                }
                .buttonStyle(UpdateButtonStyle())
                

                Spacer()

                switch model.state {
                case .cancelled:
                    Button("Start") {
                        model.state = .active
                    }
                    .buttonStyle(StartButtonStyle())
                case .active, .resumed:
                    Button("Cancel") {
                        model.state = .cancelled
                    }
                    .buttonStyle(CancelButtonStyle())
                }
            }
            .padding(.horizontal, 32)
        }
    }
}

#Preview {
    PikaTimerView()
}
