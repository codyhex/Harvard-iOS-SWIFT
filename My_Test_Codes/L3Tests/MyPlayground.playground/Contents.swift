//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"




let array = ["one", "one", "two", "two", "three", "three"]
let unique = NSSet(array: array).allObjects

var array2 : [Point] = []

var p = (1,2)

var p2 = Point(2,2)

var p3 = Point(1,2)

array2.append(p)
array2.append(p2)
array2.append(p3)


let money = [1,2,3,4,5]

var sum = money.reduce(0, combine: +)

let inputDic = [
    "Ham": 345, "Cheese": 115
]

var result = 0

var itemCosts = [Int]()

for key in inputDic.keys {
    itemCosts.append(inputDic[key]!)
}

var sum2 = itemCosts.reduce(0, combine: +)


func songInformation(myFavoriteSong : Dictionary<String,String> = ["title": "Raju", "artist": "John McLaughlin", "album": "The Boston Record"]) {
}

enum ServiceLevel:Double {
    case poor = 0.1
    case good = 0.15
    case excellent = 0.2
}

var Service = ServiceLevel.good

var a = 10.0 * Service.rawValue

println("\(a)")

Int(2.1)


