//
//  ViewController.swift
//  Calculator
//
//  Created by Paula Vasconcelos on 22/03/17.
//  Copyright © 2017 Paula Vasconcelos. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var historyLabel: UILabel!
    
    var userIsTyping = false
    private var brain = CalculatorBrain()
    
    var displayValue: Double? {
        get {
            if let text = resultLabel.text, let resultValue = NumberFormatter().number(from: text)?.doubleValue {
                return resultValue
            }
            return nil
        }
        set {
            if let value = newValue {
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal
                formatter.maximumFractionDigits = 6
                resultLabel.text = formatter.string(from: NSNumber(value: value))
            }
        }
    }
    
    
    // MARK: - UIButton Actions

    @IBAction func touchedDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        
        if userIsTyping {
            if digit == "." && displayValue != nil && floor(displayValue!) != displayValue! { // checks if dot was touched and current number is already a floating point number
                return
            }
            let currentText = resultLabel.text!
            resultLabel.text = currentText + digit
        } else {
            if digit != "0" {
                userIsTyping = true
            }
            
            if digit == "." {
                resultLabel.text = "0."
            } else {
                resultLabel.text = digit
            }
        }
    }
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsTyping {
            brain.setOperand(displayValue!)
            userIsTyping = false
        }
        if let symbol = sender.currentTitle {
            brain.performOperation(symbol)
        }
        
        displayValue = brain.result
        historyLabel.text = brain.description
    }
}

