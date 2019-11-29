//
//  ContentView.swift
//  BetterRest
//
//  Created by Davron on 11/27/19.
//  Copyright © 2019 Davron. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State private var wakeUp = Date()
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    
    
    var body: some View {
        NavigationView{
            VStack {
                Text("When do you want to wake up?")
                    .font(.headline)
                DatePicker("Please select a time.", selection: $wakeUp, displayedComponents: .hourAndMinute)
                .labelsHidden()
                
                Text("Desired sleep amount.")
                    .font(.headline)
                Stepper(value: $sleepAmount, in: 4...10, step: 0.25){
                    Text("\(sleepAmount, specifier: "%g") hours")
                }
                
                Text("Daily coffee intake?")
                    .font(.headline)
                Stepper(value: $coffeeAmount, in: 1...20, step: 1){
                    if coffeeAmount == 1 {
                        Text("1 cup")
                    }
                    else {
                        Text("\(coffeeAmount) cups")
                    }

                }
                Spacer()
            }
            .navigationBarTitle("Better Rest", displayMode: .automatic)
            .navigationBarItems(trailing:
                Button(action: calculateBedTime) {
                    Text("Calculate")
                }
            )
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("\(alertTitle)"), message: Text("\(alertMessage)"), dismissButton: .default(Text("OK")))
        }
    }
    
    func calculateBedTime() {
        
        let model = SleepCalculator()
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        
        do {
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            
            alertMessage = formatter.string(from: sleepTime)
            alertTitle = "Your ideal bedtime is..."
        }
        catch {
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime."
        }
        
        showingAlert = true
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
