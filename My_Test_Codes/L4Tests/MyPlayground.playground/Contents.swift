//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

struct Item: Printable {
    let name : String
    var quantity: Int
    var price: Double
    
    var description: String {
        return "Item Description: \(name) \nQuantity: \(quantity)\nBase Total: \(price * Double(quantity))"
    }
}



//var billItems: [Item]?
//
//var a = Item(name: "SP", quantity: 10, price: 3)
//
//billItems?.append(a)
//billItems?.count


var t2 = [Int]()

t2.count

t2.append(3)

t2.count

if "streing" == "streing" {
    t2.append(5)
}

t2.count

t2[1]


var t3 = [Item]()

t3.count

var item = Item(name: "test", quantity: 1, price: 3)

t3.append(item)

t3.count

var item2 = Item(name: "test2", quantity: 1, price: 3)

t3.append(item2)

t3.count

if t3[0].name != t3[1].name {
    println("true")
}

for i = 0; i < t3.count; i = i+1 {
    println("\t3[i].name")
}









