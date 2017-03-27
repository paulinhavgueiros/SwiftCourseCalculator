//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Paula Vasconcelos on 22/03/17.
//  Copyright © 2017 Paula Vasconcelos. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    private var resultAccumulator = 0.0
    var result: Double {
        get {
            return resultAccumulator
        }
    }
    
    private var descriptionAccumulator = ""
    var description: String {
        get {
            if resultIsPending {
                let operation = pendingBinaryOperation!
                let descriptionEnding = operation.descriptionFirstOperand != descriptionAccumulator ? descriptionAccumulator : ""
                return operation.descriptionFunction(operation.descriptionFirstOperand, descriptionEnding) + " ..."
            }
            else {
                return (descriptionAccumulator == "") ? "" : descriptionAccumulator + " ="
            }
        }
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    private var resultIsPending: Bool {
        get {
            return pendingBinaryOperation != nil
        }
    }
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        var descriptionFunction: (String, String) -> String
        var descriptionFirstOperand: String
        
        func perform(withOperand secondOperand: Double, andDescription descriptionSecondOperand: String) -> (Double, String) {
            let operationResult = function(firstOperand, secondOperand)
            let descriptionResult = descriptionFunction(descriptionFirstOperand, descriptionSecondOperand)
            return (operationResult, descriptionResult)
        }
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
    
    
    mutating func setOperand(_ operand: Double) {
        resultAccumulator = operand
        descriptionAccumulator = String(format:"%g", operand)
    }

    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                resultAccumulator = value
                descriptionAccumulator = symbol

            case .unaryOperation(let resultFunction, let descriptionFunction):
                resultAccumulator = resultFunction(resultAccumulator)
                descriptionAccumulator = descriptionFunction(descriptionAccumulator)
                
            case .binaryOperation(let resultFunction, let descriptionFunction):
                performPendingBinaryOperation()

                pendingBinaryOperation = PendingBinaryOperation(function: resultFunction, firstOperand: resultAccumulator, descriptionFunction:descriptionFunction, descriptionFirstOperand: descriptionAccumulator)
                
            case .equals:
                performPendingBinaryOperation()

            case .clear:
                descriptionAccumulator = ""
                resultAccumulator = 0.0
                pendingBinaryOperation = nil
            }
        }
    }
    
    private mutating func performPendingBinaryOperation() {
        if resultIsPending {
            (resultAccumulator, descriptionAccumulator) = pendingBinaryOperation!.perform(withOperand: resultAccumulator, andDescription: descriptionAccumulator)
            pendingBinaryOperation = nil
        }
    }
}

