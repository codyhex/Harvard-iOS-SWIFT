//
//  Map.swift
//  S65HW1
//
//  Created by HePeng on 6/29/15.
//  Copyright (c) 2015 HePeng. All rights reserved.
//

import Foundation

func intArrayToEnglishWords(numbers: [Int] = [Int]()) {
    // build dictionaries for each condition use
    // for ones
    let digitNames = [
        0: "zero", 1: "one", 2: "two", 3: "three", 4: "four",
        5: "five", 6: "six", 7: "seven", 8: "eight", 9: "nine"
    ]
    // for number in 10~19
    let digitNames2 = [
        0: "ten", 1: "eleven", 2: "twelve", 3: "thirteen", 4: "fourteen",
        5: "fifteen", 6: "sixteen", 7: "seventeen", 8: "eighteen", 9: "nineteen"
    ]
    // for tens
    let digitNames3 = [
        0: "twenty", 1: "N/A", 2: "twenty-", 3: "thirty-", 4: "forty-",
        5: "fifty-", 6: "sixty-", 7: "seventy-", 8: "eighty-", 9: "ninety-"
    ]
    // for number like 30, 50
    let digitNames4 = [
        0: "N/A", 1: "N/A", 2: "twenty", 3: "thirty", 4: "forty",
        5: "fifty", 6: "sixty", 7: "seventy", 8: "eighty", 9: "ninety"
    ]
    
    let strings = numbers.map {
        (var number) -> String in
        // each var should have a init value
        var output = ""
        // boundray check
        if number < 0 || number > 99 {
            output = "nil"  // I add the string "nil" for display only
        }
            else {
            // keep filtering the number until all digits get processed
            while number > 0 {
                // ones
                if number < 10 {
                output = output + digitNames[number % 10]!
                number /= 10
                }
                // 10~19
                else if number >= 10 && number < 20 {
                output = output + digitNames2[number % 10]!
                number = 0
                }
                // number > 20
                else if number >= 20 {
                    // just a tens number, like 30, there are no post-fix
                    if (number % 10) == 0 {
                        output = digitNames4[number / 10]! + output
                        return output
                    }
                    // the other should have a  pre-fix, like 34 is thirty-something
                    else {
                    output = digitNames3[number / 10]! + output
                    number %= 10
                    }
                }
            }
            
        }
        return output
    }
    
    println("\(strings)")
}
