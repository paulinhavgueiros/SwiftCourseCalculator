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
    var currentDisplayValueWasSetByInput = false
    
    var userIsTyping = false
    private var brain = CalculatorBrain()
    
    var displayValue: Double? {
        get {
            if let _ = resultLabel.text, let resultValue = Double(resultLabel.text!) {
                return resultValue
            }
            return nil
        }
        set {
            if newValue != nil {
                resultLabel.text = String(newValue!)
            }
        }
    }
    
    // MARK: - Initialization

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - UIButton Actions

    @IBAction func touchedDigit(_ sender: UIButton) {
        currentDisplayValueWasSetByInput = true // display value is being changed using input
        
        let digit = sender.currentTitle!
        if digit == "AC" {
            resultLabel.text = "0"
            userIsTyping = false
            return
        }
        
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
            brain.performOperation(symbol, displayValueWasSetByInput:currentDisplayValueWasSetByInput)
        }
        if let result = brain.result {
            displayValue = result
            currentDisplayValueWasSetByInput = false // display value has been captured by calculator brain
        }
        historyLabel.text = brain.descriptionResult
    }
}

