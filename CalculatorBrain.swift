//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Jacob Todd on 3/13/17.
//  Copyright © 2017 Jacob Todd. All rights reserved.
//

import Foundation

//Structs automatically get an initializer
struct CalculatorBrain {
    
    //for internal implementation
    private var accumulator: Double? //intial accumulator on calculator is not set which is why it is an optional
    private var descriptionAccumulator = " "
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    var result: Double? {
        get {
            if accumulator != nil{
            }
            return accumulator
        }
    }
    
    //set associated values with a dictionary
    private var operations: Dictionary<String,Operation>=[
        "π" : Operation.constant(Double.pi),
        "e" : Operation.constant(M_E),
        "√" : Operation.unaryOperation(sqrt),
        "cos" : Operation.unaryOperation(cos),
        "±" : Operation.unaryOperation({-$0}),
        "×" : Operation.binaryOperation({$0 * $1}),
        "÷" : Operation.binaryOperation({$0 / $1}),
        "+" : Operation.binaryOperation({$0 + $1}),
        "-" : Operation.binaryOperation({$0 - $1}),
        "=" : Operation.equals
    ]
    
    private enum Operation {//enum -> data structure that has discrete values (can have multiple types)
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
    }
    
    private struct PendingBinaryOperation {
        let binaryFunction: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return binaryFunction(firstOperand, secondOperand)
        }
    }
    
    private mutating func performPendingBinaryOperation(){
        if pendingBinaryOperation != nil && accumulator != nil{
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }

    mutating func setOperand(_ operand: Double) {
        accumulator = operand
        //Truncates the remainder of the divide operation to a single decimal digit
        if operand.truncatingRemainder(dividingBy: 1.0) == 0{
            descriptionAccumulator = String(Int(operand))
        } else{
            descriptionAccumulator = String(operand)
        }
    }
    
    
    //others can call this
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol]{
            switch operation {
            case .constant(let value):
                accumulator = value
            case .unaryOperation(let function):
                if accumulator != nil {
                    accumulator = function(accumulator!)
                }
            case .binaryOperation(let function):
                if accumulator != nil {
                    performPendingBinaryOperation()
                    pendingBinaryOperation = PendingBinaryOperation(binaryFunction: function, firstOperand: accumulator!)
                    accumulator = nil
                }
            case .equals:
                performPendingBinaryOperation()
            }
            print(operations[symbol]!)
        }
    }
}
