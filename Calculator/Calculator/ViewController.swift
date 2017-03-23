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
    
    var displayValue: Double {
        get {
            return Double(resultLabel.text!)!
        }
        set {
            resultLabel.text = String(newValue)
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
        let digit = sender.currentTitle!
        
        if digit == "AC" {
            resultLabel.text = "0"
            userIsTyping = false
            return
        }
        
        if userIsTyping {
            if digit == "." && floor(displayValue) != displayValue { // checks if dot was touched and current number is already a floating point number
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
            brain.setOperand(displayValue)
            userIsTyping = false
        }
        if let symbol = sender.currentTitle {
            brain.performOperation(symbol)
        }
        if let result = brain.result {
            displayValue = result
        }
    }
}

