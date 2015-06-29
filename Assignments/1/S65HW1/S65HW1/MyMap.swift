//
//  Map.swift
//  S65HW1
//
//  Created by HePeng on 6/29/15.
//  Copyright (c) 2015 HePeng. All rights reserved.
//

import Foundation

//var inputArray: [Int] = [Int]()
//
//
//inputArray.append(2)
//inputArray.append(4)


func MyMap(inputArray: [Int] = [Int]()) {

    
    map(inputArray, {
        (sourceValue: Int) -> Int in
        
        let returnVal = sourceValue * sourceValue;
        return returnVal;
    })
    
    println("Test \(inputArray)")
}
