//
//  Map.swift
//  S65HW1
//
//  Created by HePeng on 6/29/15.
//  Copyright (c) 2015 HePeng. All rights reserved.
//

import Foundation

func MyMap(inputArray: [Int] = [Int]()) {

    
    map(inputArray, {
        (sourceValue: Int) -> Int in
        
        
        // check range
        if sourceValue < 0 or sourceValue > 99 {
            return nil
        }
        else if sourceValue >=0 and sourceValue <= 9 {
            return test
        }
        
        let returnVal = sourceValue * sourceValue;
        return returnVal;
    })
    
    println("Test \(inputArray)")
}
