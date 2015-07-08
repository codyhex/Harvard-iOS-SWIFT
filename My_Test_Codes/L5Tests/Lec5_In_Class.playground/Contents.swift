//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

// Type is [String:String]
let frenchToEnglish = ["pomme": "apple", "ananas" : "pineapple","banana": "banana"]

// bill["hamburger"]!.quantity++
// for x in billItems { if x.description == "hamburger" {...}}


//frenchWords[0]

//frenchToEnglish[0] //  this is wrong

frenchToEnglish["orange"] // should return nil
frenchToEnglish["banana"]
frenchToEnglish["apple"]
frenchToEnglish["pomme"]


// mutable dict
var frenchToEnglishMutable = [String: String]()
frenchToEnglishMutable["fries"]
frenchToEnglishMutable["fries"] = "French Fries"

frenchToEnglishMutable["fries"]
frenchToEnglishMutable["fries"] = nil // 字典的这个item nil了

struct MenuItem {
    let name: String
    let priceInCents: Int
}

var item = MenuItem(name: "coca", priceInCents: 99)


// Extensions: 
// Int, Double do not work like Jaave, C. They can have methos added directly to them. Just like they are structs.
extension Int {
    func addOne() ->Int {
        return self + 1
    }
}

let myInt = 3
myInt.addOne()

4.addOne()


class MyInt: Printable {
    var theInteger: Int = 0
    
    // derived, or computed from other properties, in is *ONLY code* not storage. Only *stored properies* take up memory per instance of this class.
    // 这个70就是一个特殊的func，用var开头的
    var description: String {
        return "the value of my integer is \(theInteger)"
    }
}

var container = MyInt()

"\(container)"

// integrate printale ability in the object

func printObject(obj1: Printable, obj2: Printable) {
    println("\(obj1) \(obj2)")
    
}

printObject(container, [1,2])   // terminal


enum SalesTax: Double {
    case NM = 0.6
    case CM = 0.5
}

var taxRate: SalesTax = .NM

taxRate.rawValue

let x = 1.23556789
let y = Double(round(1000*x)/1000)


