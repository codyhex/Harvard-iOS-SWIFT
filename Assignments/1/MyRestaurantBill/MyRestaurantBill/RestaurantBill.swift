//
//  RestaurantBill.swift
//  MyRestaurantBill
//
//  Created by HePeng on 7/2/15.
//  Copyright (c) 2015 HePeng. All rights reserved.
//

import Foundation

class RestaurantBill: Printable {
    
    struct Item: Printable {
        let name : String
        var quantity: Int
        var price: Double
        
        var description: String {
            return "Item Description: \(name) \nQuantity: \(quantity)\nBase Total: \(price * Double(quantity))"
        }
    }
    

    
    var serviceLevel: Int
    var baseTotal: Double
    var finalTotal: Double
    var billItems: [Item]?
    
    var description: String {
        return "Something"
    }
    
    init() {
//        description = ""
        serviceLevel = 0
        baseTotal = 0.0
        finalTotal = 0.0
        billItems = nil
    }
    
    func addLineItem(description: String, quantity: Int, price: Double) -> Bool {
        
        var item = Item(name: description, quantity: quantity, price: price)
        // Need to check if the item already exsists
        billItems?.append(item)
        
        return true
    }
    
}


