//
//  ContentView.swift
//  CalculatorApp
//
//  Created by Toki on 12/25/24.
//

import SwiftUI

let buttons: [[String]] = [
        ["x²", "√x", "C", "⌫"],
        ["%", "(", ")", "/"],
        ["7", "8", "9", "*"],
        ["4", "5", "6", "-"],
        ["1", "2", "3", "+"],
        ["+/-", "0", ".", "="]
]

struct ContentView: View {
    
    @State var displayText: String = "5+-10/2+(5²-9)*0.5"
    @State var calculation: String = "5+-10/2+5**2-9*0.5"
    @State var equation: String = ""
    @State var usingParenthesis: String = ""
    @State var startingChar: String = ""
    
    var body: some View {
        VStack {
            Text(equation)
            Text(startingChar + displayText + usingParenthesis)
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
            doubleAppend(button)
            updateStartingChar()
        }
        else {
            // Check if same character
            if displayText.suffix(1) == button {
                return
            }
            // Specific Buttons
            switch button {
            case "+", "-", "*", "/":
                switch displayText.suffix(1) {
                case "+", "-", "*", "/":
                    displayText.removeLast()
                    calculation.removeLast()
                    doubleAppend(button)
                case "√", "(", ".":
                    break
                default:
                    if !displayText.isEmpty {
                        doubleAppend(button)
                    }
                }
            case "C":
                displayText = ""
                calculation = ""
                usingParenthesis = ""
                updateStartingChar()
            case "⌫":
                if !calculation.isEmpty {
                    if displayText.last == ")" {
                        usingParenthesis = "〉"
                    }
                    if displayText.last == "(" {
                        usingParenthesis = ""
                    }
                    displayText.removeLast()
                    calculation.removeLast()
                    updateStartingChar()
                }
            case "(":
                switch calculation.suffix(1) {
                case "/", "*", "+", "-", "":
                    usingParenthesis = "〉"
                    doubleAppend(button)
                    updateStartingChar()
                default: break
                }
            case ")":
                if usingParenthesis == "〉" && displayText.last != "(" {
                    usingParenthesis = ""
                    doubleAppend(button)
                }
            case "√x":
                switch calculation.suffix(1) {
                case "/", "*", "+", "-", "":
                    displayText.append("√")
                    calculation.append("0.5**")
                    updateStartingChar()
                default: break
                }
            case "%":
                if let _ = Int(displayText.suffix(1)) {
                    displayText.append("%")
                    calculation.append("*0.01")
                }
            case ".":
                if startingChar == "0" {
                    doubleAppend("0.")
                }
                else if let _ = Int(displayText.suffix(1)) {
                    doubleAppend(".")
                }
                updateStartingChar()
            case "x²":
                if let _ = Int(displayText.suffix(1)) {
                    displayText.append("²")
                    calculation.append("**2")
                }
            case "+/-":
                switch calculation.suffix(1) {
                case "/", "*", "+", "-", "√":
                    doubleAppend("-")
                default: break
                }
                //var temp = calculation
                //for
                print("ma")
            case "=":
                calculate()
            default:
                doubleAppend(button)
            }
        }
        
        // Clean Append Helper
        func doubleAppend(_ str: String) {
            displayText.append(str)
            calculation.append(str)
        }
        
        // Helper Function
        func updateStartingChar() {
            if displayText.isEmpty {
                startingChar = "0"
                calculation = ""
            }
            else {
                startingChar = ""
            }
        }
        
        // Calculation Helper
        func calculate() {
            guard !displayText.isEmpty else { return }
            guard validateEquation() else { return }
            
            let expression = NSExpression(format: calculation)
            if let result = expression.expressionValue(with: nil, context: nil) as? Double {
                equation = displayText
                displayText = String(result)
                calculation = String(result)
                if calculation.hasSuffix(".0") {
                    displayText.removeLast(2)
                    calculation.removeLast(2)
                }
            }
            
        }
        
        // Validation Helper
        func validateEquation() -> Bool {
            
            if !usingParenthesis.isEmpty {
                return false
            }
            
            switch calculation.suffix(1) {
            case "/", "*", "+", "-", "√", ".":
                return false
            default: break
            }
            
            return true
        }
        
        
    }
}

#Preview {
    ContentView()
}
