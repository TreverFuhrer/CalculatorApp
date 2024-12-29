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
    
    @State var displayText: String = ""
    @State var calculation: String = ""
    @State var equation: String = "Ans = 0"
    
    @State var usingParenthesis: String = ""
    @State var startingChar: String = "0"
    
    var body: some View {
        ZStack {
            Color(UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)).ignoresSafeArea()
            VStack {
                Spacer()
                Text(equation)
                    .font(.system(size: 24, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 16)
                    .lineLimit(1)
                
                Text(startingChar + displayText + usingParenthesis)
                    .font(.system(size: 48, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                
                
                ForEach(buttons, id: \.self) { row in
                    HStack {
                        ForEach(row, id: \.self) { button in
                            Button(action: {
                                buttonUsed(button)
                            }) {
                                Text(button)
                                    .font(.title)
                                    .frame(width: 85, height: 70)
                                    .background(buttonBackgroundColor(for: button))
                                    .foregroundStyle(Color.white)
                                    .cornerRadius(10)
                            }
                        }
                    }
                }
                
            }
            .padding(.bottom, 16)
        }
    }
    
    func buttonBackgroundColor(for button: String) -> Color {
        switch button {
        case "0","1","2","3","4","5","6","7","8","9":
            return Color(UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0))
        case "C":
            return Color.red.opacity(0.45)
        case "⌫":
            return Color.orange.opacity(0.45)
        case "=":
            return Color.green.opacity(0.45)
        default:
            return Color.gray.opacity(0.2)
        }
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
