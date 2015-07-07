//: Playground - noun: a place where people can play

import UIKit
// with the helpper padding function, we know how large can a string holds
func pad(string : String, toSize: Int) -> String {
    var padded = string
    for i in 0..<toSize - count(string) {
        padded = "0" + padded
    }
    return padded
}
// try to conver the integer to string with built in constructor
let num = 220
let str = String(num, radix: 16)
println(str) // 10110
pad(str, 5)  // 00010110

// extends the string to integer method
extension Int {
    func fromHexString(input: String, radix: Int) -> Int? {
        let digits = "0123456789abcdefghijklmnopqrstuvwxyz"
        var result = Int(0)
        for digit in input.lowercaseString {
            if let range = digits.rangeOfString(String(digit)) {
                let val = Int(distance(digits.startIndex, range.startIndex))
                if val >= radix {
                    return nil
                }
                result = result * radix + val
            } else {
                return nil
            }
        }
        return result
    }
}
// test case
let hexString = pad("A8",8)
var t1 = Int()

if let num = t1.fromHexString(hexString, radix: 16) {
    println(num)
}
else {
    println("invalid input")
}

// test case 2
let hexString3 = "C65"
var t3 = Int()

if let num = t3.fromHexString(hexString3, radix: 16) {
    println(num)
}
else {
    println("invalid input")
}


// the max of Int (signed, 64-bit integer)
let hexMax = "7FFFFFFFFFFFFFFF"
var t2 = Int()

if let num = t2.fromHexString(hexMax, radix: 16) {
    println(num)
}
else {
    println("invalid input")
}
