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
            let currentText = resultLabel.text!
            resultLabel.text = currentText + digit
        } else {
            resultLabel.text = digit
            if digit != "0" {
                userIsTyping = true
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

