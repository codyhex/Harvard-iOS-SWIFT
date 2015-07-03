//
//  RestaurantBill.swift
//  MyRestaurantBill
//
//  Created by HePeng on 7/2/15.
//  Copyright (c) 2015 HePeng. All rights reserved.
//

import Foundation

enum ServiceLevel:Double {
    case poor = 0.15
    case good = 0.18
    case excellent = 0.20
}

class Item: Printable {
    var name : String = ""
    var quantity: Int = 0
    var price: Double = 0
    
    init(name: String, quantity: Int, price: Double) {
        self.name = name
        self.quantity = quantity
        self.price = price
    }
    
    var description: String {
        return "Item Description: \(name) \nQuantity: \(quantity)\nBase Total: \(price * Double(quantity))"
    }
}

class RestaurantBill: Printable {
    
//    struct Item: Printable {
//        let name : String
//        var quantity: Int
//        var price: Double
//        
//        var description: String {
//            return "Item Description: \(name) \nQuantity: \(quantity)\nBase Total: \(price * Double(quantity))"
//        }
//    }
    

    
    var serviceLevel: ServiceLevel
    var baseTotal: Int {
        didSet {
            finalTotal = baseTotal + Int(round(Double(baseTotal) * (0.07 + serviceLevel.rawValue)))
        }
    }
    var finalTotal: Int

    var billItems = [Item]()
    
    var description: String {
        return "Inovice "

    }
    
    init() {
//        description = ""
        serviceLevel = ServiceLevel.good
        baseTotal = 0
        finalTotal = 0
//        billItems = nil
    }
    
    func calculateBaseTotal() {
        
        var itemCosts = [Double]()
        
        // collect the cost of each item in an array
        for itemNum in billItems {
            // loop the Dict by key
            itemCosts.append(itemNum.price * Double(itemNum.quantity))
        }
        // the "+" can be used as func in swift, use reduce to get sum
        baseTotal = Int(round(itemCosts.reduce(0, combine: +)))
       
    }
    
    func setServiceLevel(level: ServiceLevel) {
        self.serviceLevel = level
    }
    
    func addLineItem(description: String, quantity: Int, price: Double) -> Bool {
        
        var item = Item(name: description, quantity: quantity, price: price)
        
        // Need to check if the item already exsists

        if billItems.count == 0 {
            billItems.append(item)
        }
        else {
            for itemNum in billItems {
                if item.name == itemNum.name {
                    itemNum.quantity = item.quantity
                    itemNum.price = item.price
                }
                else {
                    billItems.append(item)
                }
                
            }
        }
        
        calculateBaseTotal()
        
        return true
    }
    
}


