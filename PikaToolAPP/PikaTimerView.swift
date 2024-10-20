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
    
    
    var body: some View {
        VStack{
            VStack(alignment: .leading){
                HStack{
                    Text("Timer:")
                    Spacer()
                    Text("300")
                }.frame(width: 150)
                HStack{
                    Text("Minutes Before Target: 5")
                }
                HStack{
                    Text("Next Phase: 327:582")
                    
                }
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
            HStack{
                Button("Reset"){
                    print("Reset")
                }
                Button("Update"){
                    print("Update")
                }
                Button("Start"){
                    print("Start")
                }
            }
            .padding(.bottom)
        }
    }
}

#Preview {
    PikaTimerView()
}
