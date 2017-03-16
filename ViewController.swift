//
//  ViewController.swift
//  Calculator
//
//  Created by Jacob Todd on 3/2/17.
//  Copyright © 2017 Jacob Todd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var userIsInTheMiddleOfTyping: Bool = false
    private var brain = CalculatorBrain()
    
    // create a computed property
    var displayValue: Double {
        get {
            return Double(digitDisplay.text!)!
        }
        set {
            digitDisplay.text = String(newValue)
        }
    }
    
    //instance variable = property
    @IBOutlet private weak var digitDisplay: UILabel! //The exclamation point automatically unwraps the variable (implicitly unwrapped option)
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        let dupDecimal = decimalDuplicateCheck(input: digit, stringToCheck: digitDisplay.text)
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = digitDisplay.text!
            if !dupDecimal{
                digitDisplay.text = textCurrentlyInDisplay + digit
            }
        } else {
                digitDisplay.text = digit == "." ? "0" + digit: digit
                userIsInTheMiddleOfTyping = true
        }
        
    }
    
    func decimalDuplicateCheck(input digit: String, stringToCheck text: String?) -> Bool {
        if userIsInTheMiddleOfTyping {
            return digit == "." && text?.contains(".") == true
        } else {
            return false
        }
    }
    
    @IBAction func performOperation(_ sender: UIButton) {
        
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation((mathematicalSymbol))
        }
        
        
        if let result = brain.result {
            displayValue = result
        }
    }
}

