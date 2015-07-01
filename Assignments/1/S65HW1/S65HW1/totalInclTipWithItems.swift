//
//  totalInclTipWithItems.swift
//  S65HW1
//
//  Created by HePeng on 7/1/15.
//  Copyright (c) 2015 HePeng. All rights reserved.
//

import Foundation

enum ServiceLevel:Double {
    case poor = 0.15
    case good = 0.18
    case excellent = 0.20
}

func totalInclTipWithItems(#inputDic: Dictionary<String,Int>, servicelevel: ServiceLevel) -> Int {
    
    var itemCosts = [Int]()
    var tip = Double()
    
    // collect the cost of each item in an array
    for key in inputDic.keys {
        // loop the Dict by key
        itemCosts.append(inputDic[key]!)
    }
    // the "+" can be used as func in swift, use reduce to get sum
    var sum = itemCosts.reduce(0, combine: +)
    // serviceLevel%(base tip) + 7%(food tax) + base = total
    // be awared of that you need .rawValue() to get the value from enum
    var sumWithTip = Int(round(Double(sum) * servicelevel.rawValue + Double(sum) * 0.07)) + sum

    println("\(sumWithTip)")
    
    return sumWithTip

}
