//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Paula Vasconcelos on 22/03/17.
//  Copyright © 2017 Paula Vasconcelos. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    private var accumulator: Double?
    var result: Double? {
        get {
            return accumulator
        }
    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
    }
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double, (String) -> String)
        case binaryOperation((Double, Double) -> Double, (String, String) -> String)
        case equals
        case clear
    }
    
    private var operations: Dictionary<String,Operation> = [
        "±": Operation.unaryOperation({ -$0 }, { "±(\($0))" }),
        "x²": Operation.unaryOperation({ pow($0, 2) }, { "(\($0))²" }),
        "x⁻¹": Operation.unaryOperation({ pow($0, -1) }, { "(\($0))⁻¹" }),
        "%": Operation.unaryOperation({ $0/100 }, { "(\($0))%" }),
        "cos": Operation.unaryOperation(cos, { "cos(\($0))" }),
        "√": Operation.unaryOperation(sqrt, { "√(\($0))" }),
        "π": Operation.constant(Double.pi),
        "e": Operation.constant(M_E),
        "÷": Operation.binaryOperation({ $0 / $1 }, { "\($0) ÷ \($1)" }),
        "×": Operation.binaryOperation({ $0 * $1 }, { "\($0) × \($1)" }),
        "−": Operation.binaryOperation({ $0 - $1 }, { "\($0) − \($1)" }),
        "+": Operation.binaryOperation({ $0 + $1 }, { "\($0) + \($1)" }),
        "=": Operation.equals,
        "AC": Operation.clear
    ]
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    private var resultIsPending: Bool {
        get {
            return (pendingBinaryOperation != nil)
        }
    }
    
    // TEST FOR VALUES LIKE: 
    // (1 + 1) X 5
    // AND 
    // 3 + SQRT(9) = 6
    mutating func performOperation(_ symbol: String, displayValueWasSetByInput: Bool) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                if accumulator != nil && !resultIsPending {
                    description = ""
                }
                description += "\(symbol)"
                accumulator = value
                
            case .unaryOperation(let resultFunction, let descriptionFunction): // ±, ², %, cos...
                if let value = accumulator {
                    if displayValueWasSetByInput {
                        description = "\(value)"
                    }
                    description = descriptionFunction(description)
                    accumulator = resultFunction(value)
                }
            case .binaryOperation(let resultFunction, let descriptionFunction):
                if let value = accumulator {
                    pendingBinaryOperation = PendingBinaryOperation(function: resultFunction, firstOperand: value)
                    if displayValueWasSetByInput {
                        description = "\(value)"
                    }
                    description = descriptionFunction(description, "")
                    accumulator = nil
                }
            case .equals:
                if let value = accumulator {
                    description += "\(value)"
                }
                performPendingBinaryOperation()
            case .clear:
                description = ""
                accumulator = 0
                pendingBinaryOperation = nil
            }
        }
    }
    
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    
    private var description = ""
    var descriptionResult: String {
        get {
            if resultIsPending {
                return description + " ..."
            }
            else {
                return (description == "") ? "" : description + " ="
            }
        }
    }
}

