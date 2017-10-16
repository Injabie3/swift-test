//
//  ViewController.swift
//  Calculator
//
//  Created by Ryan Lui on 2017-10-02.
//  Copyright © 2017 Injabie3. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var userIsInTheMiddleOfTyping = false

    @IBOutlet weak var display: UILabel!

    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        print("\(digit) was touched")
        if userIsInTheMiddleOfTyping {
            display.text = "\(display.text!)\(digit)"
        }
        else {
            display.text = "\(digit)"
            userIsInTheMiddleOfTyping = true
        }
    }

    var displayValue: Double {
    // Computed properties in Lecture 01: 1:20:43
        get {
            // Must unwrap text and the Double because it's an optional.
            // Basically every time you "get" (e.g. read) this variable it computes the value for you.
            return Double(display.text!)!
        }
        set {
            // Every time you "set" (e.g. assign) this variable it does the following:
            display.text = String(newValue)
        }
    }

    private var brain: CalculatorBrain = CalculatorBrain() // Must initialize this because it is in a class.

    @IBAction func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        if let result = brain.result {
            displayValue = result
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
