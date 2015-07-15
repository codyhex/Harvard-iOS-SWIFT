//
//  ColoredSquareModel.swift
//  MVCClassDemo
//
//  Created by Daniel Bromberg on 7/6/15.
//  Copyright (c) 2015 S65. All rights reserved.
//

// NOTE: A model should not import UIKit!

import Foundation

// Principle of loose coupling: Two classes that must work together should have as few dependencies as
// Possible

// Protocol: what does a model do versus how does it do it (in Java, 'interface')

// Allows for easy swapping of different implementations of the same functionality

protocol ColoredSquareDataSource: class /* adopters must be class (reference type) */ {
    // encapsulates the idea of a dictionary of named parameters, each of which is floating-point
    subscript(index: String) -> Double? { get set }
    func notifyObservers(#success: Bool)
    func getArea() -> Double
}

struct ModelKeys {
    static let xLoc = "xLoc" /* these string values are internal use only right now */
    static let yLoc = "yLoc"
    static let width = "width"
    static let height = "height"
    static let hue = "hue"
}

struct NumericAttribute {
    var min: Double
    var max: Double
    var value: Double
}

/** Part of C) of UIBible: notification system **/
struct ModelMsgs {
    static let notificationName = "ColoredSquareModel"
    static let notificationEventKey = "CS Model Message Key"
    static let modelChangeDidSucceed = "CS Model Change Succeeded"
    static let modelChangeDidFail = "CS Model Change Failed"
}

class ColoredSquareModel: ColoredSquareDataSource {
    struct Limits {
        static let defaultX = 10.0
        static let defaultY = 30.0
        
        static let defaultSide = 50.0
        static let minSide = 1.0
        static let maxSide = 250.0
        
        static let defaultHeight = 100.0
        static let minHeight = 1.0
        static let maxHeight = 250.0
        
        static let defaultHue = 0.0 /* red */
        static let minHue = 0.0
        static let maxHue = 1.0
    }
    
    /** Model "A) a." of UIBible: values is the fundamental representation
        Model "A) b." of UIBible: values is a stored property
        Model "A) d." of the UIBible: we have a representation that can accomodate as many or as few
        numeric parameters as needed without changing the rest of the code **/
    /* This is just a long dictionary literal */
    var values: [String : NumericAttribute] =
    [
         /** Model "D)" of UIBible: the model has to be initialized in an orderly way. **/
        ModelKeys.xLoc: NumericAttribute(min: 0.0, max: 0.0, value: Limits.defaultX),
        ModelKeys.yLoc: NumericAttribute(min: 0.0, max: 0.0, value: Limits.defaultY),
        ModelKeys.width: NumericAttribute(min: Limits.minSide, max: Limits.maxSide, value: Limits.defaultSide),
        ModelKeys.height: NumericAttribute(min: Limits.minHeight, max: Limits.maxHeight, value: Limits.defaultHeight),
        ModelKeys.hue: NumericAttribute(min: Limits.minHue, max: Limits.maxHue, value: Limits.defaultHue)
    ]
    
    /** Model "B)" of UIBible; a computed property that gives something useful, but computes it from
        the fundamental data. This was not shown in class. **/
    var numValues: Int {
        return values.count
    }
    
    var area: Double {
        return values[ModelKeys.width]!.value * values[ModelKeys.height]!.value
    }
    
    func getArea() -> Double {
        return area
    }
    
    init(minX: Double, maxX: Double, minY: Double, maxY: Double) {
        assert(minX < maxX && minY < maxY) // Good defensive programming
        values[ModelKeys.xLoc]!.min = minX
        values[ModelKeys.xLoc]!.max = maxX
        values[ModelKeys.yLoc]!.min = minY
        values[ModelKeys.yLoc]!.max = maxY
        /* @@HP: limit width and height */
        values[ModelKeys.width]!.max = (maxX / 2)
        values[ModelKeys.height]!.max = (maxY / 2)
    }
    
    // myModel["xLoc"] = 57.8 <-- 57.8 gets bound to newValue as a Double?; index gets bound to "xLoc"
    subscript(index: String) -> Double? {
        get {
            return values[index]?.value // present just the Double, not the min/max: not useful for output
        }
        // filter out invalid data "at the door"
        // implicit declaration for "set" method: subscript(index: String, newValue: Double?)
        set {
            var successFlag = false
            // STEP 3 of diagram (A, B, C below): validate data
            if let attr = values[index], var unwrappedValue = newValue {
                if unwrappedValue < attr.min { // If entered value too low, bound it at the minimum
                    unwrappedValue = attr.min // Why I needed var; I'm changing it here
                }
                else if unwrappedValue > attr.max {
                    unwrappedValue = attr.max
                }
                // now suppose text field was edited from "57.0" to "57.00"; this is a non-substantial change
                // The model will not change, so we'll call it a failed edit
                if unwrappedValue != attr.value {
                    // 3 requirements now met:
                    // A. valid (known key) parameter
                    // B. non-nil Double optional passed in
                    // C. the value is substantially different than existing
                    successFlag = true
                    // STEP 4 of diagram: record new data
                    values[index]!.value = unwrappedValue
                    // why would attr.value = ... do no good, even if it were a 'if var...'?
                }
            }
            /** Part of "C)" of UIBible: notification system **/
            // STEP 5 of diagram: notify model changed event
            notifyObservers(success: successFlag)
        }
    }
    
    /** Part of "C)" of UIBible: notification system **/
    func notifyObservers(#success: Bool) {
        let message = success ? ModelMsgs.modelChangeDidSucceed : ModelMsgs.modelChangeDidFail
        let notification = NSNotification(
            name: ModelMsgs.notificationName, object: self,
            userInfo: [ ModelMsgs.notificationEventKey : message ])
        NSNotificationCenter.defaultCenter().postNotification(notification)
    }
}

