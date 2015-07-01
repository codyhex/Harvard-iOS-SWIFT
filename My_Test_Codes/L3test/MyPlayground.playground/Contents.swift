//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

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

songInformation("apple": "big")


