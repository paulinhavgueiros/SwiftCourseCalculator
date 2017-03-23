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
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
        case clear
    }
    
    private var operations: Dictionary<String,Operation> = [
        "±": Operation.unaryOperation({ -$0 }),
        "x²": Operation.unaryOperation({ pow($0, 2) }),
        "x⁻¹": Operation.unaryOperation({ pow($0, -1) }),
        "%": Operation.unaryOperation({ $0/100 }),
        "cos": Operation.unaryOperation(cos),
        "√": Operation.unaryOperation(sqrt),
        "π": Operation.constant(Double.pi),
        "e": Operation.constant(M_E),
        "÷": Operation.binaryOperation({ $0 / $1 }),
        "×": Operation.binaryOperation({ $0 * $1 }),
        "−": Operation.binaryOperation({ $0 - $1 }),
        "+": Operation.binaryOperation({ $0 + $1 }),
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
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = value
            case .unaryOperation(let function):
                if let value = accumulator {
                    accumulator = function(value)
                }
            case .binaryOperation(let function):
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    accumulator = nil
                }
            case .equals:
                performPendingBinaryOperation()
            case .clear:
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
    
    var description: String
}

