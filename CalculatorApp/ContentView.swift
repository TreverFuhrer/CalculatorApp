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
    
    @State var displayText: String = "["

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
        switch button {
        case "0","1","2","3","4","5","6","7","8","9":
            displayText.append(button)
        default:
            if String(displayText.last ?? " ") == button {
                break
            }
            
            switch button {
            case "C":
                displayText = ""
            case "⌫":
                displayText.removeLast()
            case "√x":
                print("mal")
            case "x²":
                print("mal")
            case "+/-":
                print("ka")
            case "=":
                print("ka")
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
        
        
    }
}

#Preview {
    ContentView()
}
