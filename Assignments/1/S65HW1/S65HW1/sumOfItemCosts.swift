//
//  sumOfItemCosts.swift
//  S65HW1
//
//  Created by HePeng on 6/30/15.
//  Copyright (c) 2015 HePeng. All rights reserved.
//

import Foundation
// build a functino that take a para as dictionary type
func sumOfItemCosts(#inputDic: Dictionary<String,Int>) -> Int {

    var itemCosts = [Int]()
    // collect the cost of each item in an array
    for key in inputDic.keys {
        // loop the Dict by key
        itemCosts.append(inputDic[key]!)
    }
    // the "+" can be used as func in swift, use reduce to get sum
    var sum = itemCosts.reduce(0, combine: +)
    // 15%(base tip) + 7%(food tax) + base = total
    var sumWithTip = Int(round(Double(sum) * 0.15 + Double(sum) * 0.07)) + sum
    
    println("\(sumWithTip)")
    
    return sumWithTip
}