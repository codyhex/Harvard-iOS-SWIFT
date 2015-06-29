//
//  main.swift
//  S65HW1
//
//  Created by HePeng on 6/29/15.
//  Copyright (c) 2015 HePeng. All rights reserved.
//

import Foundation

println("Exercise #.1 ")

HelloWorld()

println("Exercise #.2 ")

let inputArray = [1,2,3]


let digitNames = [
    0: "zero", 1: "one", 2: "two", 3: "three", 4: "four",
    5: "five", 6: "six", 7: "seven", 8: "eight", 9: "nine"
]

let digitNames2 = [
    0: "ten", 1: "eleven", 2: "twelve", 3: "thirteen", 4: "fourteen",
    5: "fifteen", 6: "sixteen", 7: "seventeen", 8: "eighteen", 9: "nineteen"
]

let digitNames3 = [
    0: "twenty", 1: "N/A", 2: "twenty-", 3: "thirty-", 4: "forty-",
    5: "fifty-", 6: "sixty-", 7: "seventy-", 8: "eighty-", 9: "ninety-"
]

let digitNames4 = [
    0: "N/A", 1: "N/A", 2: "twenty", 3: "thirty", 4: "forty",
    5: "fifty", 6: "sixty", 7: "seventy", 8: "eighty", 9: "ninety"
]

let numbers = [3, 16, 20, 58, 80, 510]

let strings = numbers.map {
    (var number) -> String in
    var output = ""
    // boundray check
    if number < 0 || number > 99 {
        output = "nil"
    }
    else {
        // keep checking the number
        while number > 0 {
            if number < 10 {
            output = output + digitNames[number % 10]!
            number /= 10
        }
            else if number >= 10 && number < 20 {
            output = output + digitNames2[number % 10]!
            number = 0
        }
            else if number >= 20 {
                if (number % 10) == 0 {
                    output = digitNames4[number / 10]! + output
                    return output
                }
                else {
                output = digitNames3[number / 10]! + output
                number /= 10
                }
            }
        }
        
    }
    return output

}

println("\(strings)")



