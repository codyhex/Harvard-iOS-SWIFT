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
//    immutable struct issue, can't solve, use class instead.
    
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
        serviceLevel = ServiceLevel.good
        baseTotal = 0
        finalTotal = 0
    }
    
    func calculateBaseTotal() {
        
        var itemCosts: Double = 0
        
        // collect the cost of each item in an array
        for itemNum in billItems {
            // loop the Dict by key
            itemCosts += (itemNum.price * Double(itemNum.quantity))
        }
        // the "+" can be used as func in swift, use reduce to get sum
        baseTotal = Int(round(itemCosts))
       
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
            var index: Int = 0
            var flag: Bool = false
            // search the whole array to see if the item has already been here
            for itemNum in billItems {
                if itemNum.name == item.name {
                    // found !
                    flag = true
                    // very important, once I find the item I should break out the searching
                    break
                }
                // no matched item name
                flag = false
            }
            // update quantity if found
            if flag == true {
                // have item
                for itemNum in billItems {
                    if itemNum.name == item.name {
                        itemNum.quantity = item.quantity
                        itemNum.price = item.price
                        break
                    }
                }
            }
            // add item name to the array it not found
            else {
                // no item
                billItems.append(item)
            }
        }
        // update base total
        calculateBaseTotal()
        
        return true
    }
    
}


