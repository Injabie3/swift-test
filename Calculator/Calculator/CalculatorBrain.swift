//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Ryan Lui on 2017-10-03.
//  Copyright © 2017 Injabie3. All rights reserved.
//

import Foundation


struct CalculatorBrain {

    private var accumulator: Double? // When we first begin, we haven't set it yet, so make this an optional: 27:15

    private enum Operation {
        case constant(Double) // The (Double) specifies associated value.
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
    }

    private var operations: Dictionary<String, Operation> =
    [
        "π": Operation.constant(Double.pi),
        "e": Operation.constant(M_E),
        "√": Operation.unaryOperation(sqrt),
        "cos": Operation.unaryOperation(cos),
        "sin": Operation.unaryOperation(sin),
        "±": Operation.unaryOperation { -$0 },
        // HOLY IN LINE FUNCTIONS ARE COOL! Lecture 02: 1:10:55
        // This function can be made more simple, from this:
        "×": Operation.binaryOperation { (op1: Double, op2) -> Double in return op1 * op2 },
        // To this:
        "+": Operation.binaryOperation { $0 + $1 },
        "-": Operation.binaryOperation { $0 - $1 },
        "÷": Operation.binaryOperation { $0 / $1 },
        "=": Operation.equals
    ]


    mutating func setOperand(_ operand: Double) {
        // We use the _ because it's clear what operand is.
        accumulator = operand
    }

    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }

    private var pendingBinaryOperation: PendingBinaryOperation? // Notice how we set this as an optional, because we're not always in the middle of a binary operation! Lecture 02: 1:02:50

    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double

        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
        
    }

    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = value
            case .unaryOperation(let function):
                if accumulator != nil {
                    // This helps to prevent app from crashing too.
                    accumulator = function(accumulator!)
                }
            case .binaryOperation(let function):
                if accumulator != nil {
                    // Once again, helps to prevent crashing.
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    accumulator = nil
                }
            case .equals:
                performPendingBinaryOperation()
            }
        }
        // case "√":

    }

    var result: Double? {
        // Make this an optional too.
        get {
            return accumulator
        }
    }
}
