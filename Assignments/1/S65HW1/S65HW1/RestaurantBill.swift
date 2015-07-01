//
//  RestaurantBill.swift
//  S65HW1
//
//  Created by HePeng on 7/1/15.
//  Copyright (c) 2015 HePeng. All rights reserved.
//

import Foundation

class RestaurantBill {
    
    var description: String
    var serviceLevel: Int
    var baseTotal: Double
    var finalTotal: Double
    
    init() {
        description = ""
        serviceLevel = 0
        baseTotal = 0.0
        finalTotal = 0.0
    }
    
    func addLineItem(description: String, quantity: Int, price: Double) -> Bool {
    
        return true
    }
    
}
