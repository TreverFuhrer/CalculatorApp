//
//  ContentView.swift
//  CalculatorApp
//
//  Created by Toki on 12/25/24.
//

import SwiftUI

var displayLine: String = ""

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

func updateDisplayLine(_ newLine: String) {
    displayLine = newLine
}

#Preview {
    ContentView()
}
