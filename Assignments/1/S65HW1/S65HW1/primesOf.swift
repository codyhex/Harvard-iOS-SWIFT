//
//  primesOf.swift
//  S65HW1
//
//  Created by HePeng on 7/1/15.
//  Copyright (c) 2015 HePeng. All rights reserved.
//

import Foundation
// The prime number checking algorithm is from wiki
// https://en.wikipedia.org/wiki/Primality_test

// Implement 1, Extend the Int class
extension Int {
    
    func isPrimeEx() -> Bool {
        if self <= 1 {
            return false
        }
        else if self <= 3 {
            return true
        }
        else if self % 2 == 0 || self % 3 == 0 {
            return false
        }
        
        var i = 5
        while (i * i) <= self {
            if self % i == 0 || self % (i+2) == 0 {
                return false
            }
            i += 6
        }
        return true
    }
}

func primesOf(input: [Int]) -> [Int] {
    // this is the way to call a member function of Int class
    var primes = input.filter({($0).isPrimeEx()})
    
    println("Ext.  Mode: \(primes)")
    
    return primes
}

// Implemt 2, use a inner function
func primesOf_2(input: [Int]) -> [Int] {
    
    func isPrime(n : Int) -> Bool {
        if n <= 1 {
            return false
        }
        else if n <= 3 {
            return true
        }
        else if n % 2 == 0 || n % 3 == 0 {
            return false
        }
        
        var i = 5
        while (i * i) <= n {
            if n % i == 0 || n % (i+2) == 0 {
                return false
            }
            i += 6
        }
        return true
    }
    // when calling the function, the filter method will plug in each element of the array, so the param of isPrime should be an Int type.
    var primes = input.filter(isPrime)
    
    println("Inner mode: \(primes)")
    
    return primes
}


