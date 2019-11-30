//
//  ContentView.swift
//  BetterRest
//
//  Created by Davron on 11/27/19.
//  Copyright © 2019 Davron. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State private var wakeUp = defaultWakeUpTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 0
    
    //@State private var alertTitle = ""
    //@State private var alertMessage = ""
    //@State private var showingAlert = false
    
    //computed property
    static var defaultWakeUpTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    var calculateBedtimes: String {
        
        var message = ""
        let model = SleepCalculator()

        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60

        do {
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))

            let sleepTime = wakeUp - prediction.actualSleep

            let formatter = DateFormatter()
            formatter.timeStyle = .short

            message = formatter.string(from: sleepTime)
            //alertTitle = "Your ideal bedtime is..."
        }
        catch {
            //alertTitle = "Error"
            message = "Sorry, there was a problem calculating your bedtime."
        }
        return message
    }
    
    var body: some View {
        NavigationView{
            Form {
                Section {
                    Text("When do you want to wake up?")
                        .font(.headline)
                    DatePicker("Please select a time.", selection: self.$wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .datePickerStyle(WheelDatePickerStyle())

                }
                Section{
                    Text("Desired amount of sleep:")
                        .font(.headline)
                    Stepper(value: $sleepAmount, in: 4...10, step: 0.25){
                        Text("\(sleepAmount, specifier: "%g") hours")
                    }
                }

                Section {
                    Text("Daily coffee intake:")
                        .font(.headline)
                    Picker(selection: $coffeeAmount, label: Text("Coffee")) {
                        ForEach(0..<20) { n in
                            if n == 0 || n == 1 {
                                Text("\(n) cup")
                            }else {
                                Text("\(n) cups")
                            }
                        }
                    }
                    .labelsHidden()
                    .pickerStyle(DefaultPickerStyle())
                }
                    
                Section(header: Text("Your ideal bedtime:")) {
                
                    Text("\(calculateBedtimes)")
                        .foregroundColor(.red)
                        .font(.largeTitle)
                        .fontWeight(.heavy)

                }
            }
            .navigationBarTitle("BetterRest")
//            .navigationBarItems(trailing:
//                Button(action: calculateBedTime) {
//                    Text("Calculate")
//                })
//            .alert(isPresented: $showingAlert) {
//                Alert(title: Text("\(alertTitle)"), message: Text("\(alertMessage)"), dismissButton: .default(Text("OK")))
        }

    }


//    func calculateBedTime() {
//
//        let model = SleepCalculator()
//
//        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
//        let hour = (components.hour ?? 0) * 60 * 60
//        let minute = (components.minute ?? 0) * 60
//
//        do {
//            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
//
//            let sleepTime = wakeUp - prediction.actualSleep
//
//            let formatter = DateFormatter()
//            formatter.timeStyle = .short
//
//            alertMessage = formatter.string(from: sleepTime)
//            alertTitle = "Your ideal bedtime is..."
//        }
//        catch {
//            alertTitle = "Error"
//            alertMessage = "Sorry, there was a problem calculating your bedtime."
//        }
//
//        showingAlert = true
//
//    }

}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
    
