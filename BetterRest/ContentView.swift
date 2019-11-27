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
    
    var body: some View {
        
        DatePicker("Please select a date.", selection: $wakeUp, in: Date()..., displayedComponents: .hourAndMinute)
        .labelsHidden()

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
