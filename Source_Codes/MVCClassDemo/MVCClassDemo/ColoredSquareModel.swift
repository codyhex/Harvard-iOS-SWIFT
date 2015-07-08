//
//  ColoredSquareModel.swift
//  MVCClassDemo
//
//  Created by Daniel Bromberg on 7/6/15.
//  Copyright (c) 2015 S65. All rights reserved.
//

// NOTE: A model should not import UIKit!

// UPDATED 7/7/15 to be True MVC

import Foundation

// NEW: Constants for Notifications between model & view
struct ModelMsgs {
    static let notificationName = "ColoredSquareModel"
    static let notificationMessageKey = "CS Model Message Key"
    static let modelChangeDidSucceed = "CS Model Change Succeeded"
    static let modelChangeDidFail = "CS Model Change Failed"
}

struct ModelKeys {
    static let xLoc = "xLoc"
    static let yLoc = "yLoc"
    static let sideLength = "sideLength"
    static let hue = "hue"
}

struct NumericAttribute {
    var min: Double
    var max: Double
    var value: Double
}


class ColoredSquareModel {
    struct Limits {
        static let defaultX = 10.0
        static let defaultY = 30.0
        
        static let defaultSide = 50.0
        static let minSide = 1.0
        static let maxSide = 250.0
        
        static let defaultHue = 0.0
        static let minHue = 0.0
        static let maxHue = 1.0
    }
    
    var values: [String : NumericAttribute] =
    [ ModelKeys.xLoc: NumericAttribute(min: 0.0, max: 0.0, value: Limits.defaultX),
        ModelKeys.yLoc: NumericAttribute(min: 0.0, max: 0.0, value: Limits.defaultY),
        ModelKeys.sideLength: NumericAttribute(min: Limits.minSide, max: Limits.maxSide, value: Limits.defaultSide),
        ModelKeys.hue: NumericAttribute(min: Limits.minHue, max: Limits.maxHue, value: Limits.defaultHue) ]

    init(minX: Double, maxX: Double, minY: Double, maxY: Double) {
        assert(minX < maxX && minY < maxY)
        values[ModelKeys.xLoc]!.min = minX
        values[ModelKeys.xLoc]!.max = maxX
        values[ModelKeys.yLoc]!.min = minY
        values[ModelKeys.yLoc]!.max = maxY
    }
    
    func notifyObservers(#success: Bool) {
        let message = success ? ModelMsgs.modelChangeDidSucceed : ModelMsgs.modelChangeDidFail
        let notification = NSNotification(
            name: ModelMsgs.notificationName,
            object: self,
            userInfo: [ModelMsgs.notificationMessageKey : message])
        NSNotificationCenter.defaultCenter().postNotification(notification)
    }
    
    subscript(index: String) -> Double? {
        get {
            return values[index]?.value
        }
        // implicit declaration for set: subscript(index: String, newValue: Double?)
        set {
            var successFlag = false
            // Read this as: 
            // 1) If this is a valid key into our attributes dictionary
            // 2) If the new value to be stored into the attribute is non-nil 
            //   -- then store it and notify success; otherwise notify that 1) or 2) failed.
            if let attr = values[index], var unwrappedValue = newValue {
                if unwrappedValue < attr.min {
                    unwrappedValue = attr.min
                    println("bounding \(index) to min \(attr.min)")
                }
                if unwrappedValue > attr.max {
                    unwrappedValue = attr.max
                    println("bounding \(index) to max \(attr.max)")
                }
                if unwrappedValue != values[index]!.value {
                    successFlag = true
                    values[index]!.value = unwrappedValue
                }
            }
            notifyObservers(success: successFlag)
        }
    }
}

