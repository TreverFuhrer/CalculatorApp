//
//  ContentView.swift
//  CalculatorApp
//
//  Created by Toki on 12/25/24.
//

import SwiftUI

var equation: String = "5"

let buttons: [[String]] = [
        ["x²", "√x", "C", "⌫"],
        ["%", "(", ")", "/"],
        ["7", "8", "9", "*"],
        ["4", "5", "6", "-"],
        ["1", "2", "3", "+"],
        ["+/-", "0", ".", "="]
]

struct ContentView: View {
    
    @State var displayText: String = "5+10/2+(5²-9)*0.5"

    var body: some View {
        VStack {
            //Text(equation)
            Text(displayText)
            ForEach(buttons, id: \.self) { row in
                HStack {
                    ForEach(row, id: \.self) { button in
                        Button(action: {
                            buttonUsed(button)
                        }) {
                            Text(button)
                                .font(.title)
                                .frame(width: 90, height: 70)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                        }
                    }
                }
                
            }
            
        }
        .padding()
    }
    
    // Using _ allows passing in param without name
    func buttonUsed(_ button: String) {
        // Check if number
        if let _ = Int(button) {
            displayText.append(button)
        }
        else {
            // Check if same character
            if String(displayText.last ?? " ") == button {
                return
            }
            // Specific Buttons
            switch button {
            case "C":
                displayText = ""
            case "⌫":
                displayText.removeLast()
            case "√x":
                displayText.append("√")
            case "x²":
                if let _ = Int(String(displayText.last ?? " ")) {
                    displayText.append("²")
                }
            case "+/-":
                print("ka")
            case "=":
                calculate()
            case "+", "-", "*", "/":
                switch displayText.last {
                case "+", "-", "*", "/":
                    displayText.removeLast()
                default:
                    break
                }
                displayText.append(button)
            default:
                displayText.append(button)
            }
        }
        
        func calculate() {
            guard !displayText.isEmpty else { return }
            
            if displayText.contains("²") {
                //displayText.split(separator: "²").forEach { displayText.append($0) }
            }
            
            let expression = NSExpression(format: displayText)
            if let result = expression.expressionValue(with: nil, context: nil) as? Double {
                displayText = String(result)
                if displayText.hasSuffix(".0") {
                    displayText.removeLast(2)
                }
            }
            else {
                
            }
        }
        
        
    }
}

#Preview {
    ContentView()
}
