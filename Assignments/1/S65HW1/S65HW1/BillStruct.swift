//
//  billStruct.swift
//  S65HW1
//
//  Created by HePeng on 7/2/15.
//  Copyright (c) 2015 HePeng. All rights reserved.
//

import Foundation

struct BillStruct: Printable {
    
    let baseFoodCost: Int
    
    var tax: Int {
        return Int(round(Double(baseFoodCost) * 0.07))
    }
    
    var tip: Int {
        return Int(round(Double(baseFoodCost) * 0.15))
    }
    
    var total: Int {
        // calculate the total here
        return (baseFoodCost + tax + tip)
    }
    // when you print the struct instance if it is printable and we have to give a defintion about what to print. This is a computed String bascially.
    var description: String {
        return "baseFoodCost: \(baseFoodCost), tax: \(tax), tip: \(tip), total: \(total)"
    }
}


// build a function from ex.4
func sumCosts(#inputDic: Dictionary<String,Int>) -> BillStruct {
    
    var itemCosts = [Int]()
    // collect the cost of each item in an array
    for key in inputDic.keys {
        // loop the Dict by key
        itemCosts.append(inputDic[key]!)
    }
    // the "+" can be used as func in swift, use reduce to get sum
    var sum = itemCosts.reduce(0, combine: +)
    
    var billInstance = BillStruct(baseFoodCost: sum)
    // return the instance
    return billInstance
}

