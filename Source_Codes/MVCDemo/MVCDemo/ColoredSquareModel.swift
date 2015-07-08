import Foundation // 'round' function

protocol ColoredSquareDataSource: class /* adopter must be class (reference type） */{
    
    subscript(index:String) ->Double? { get set }
    
    func notifyObservers(#success: Bool)
//    var vx: Double { get set }
//    var vy: Double { get set }
//    var side: Double { get set }
//    var hue: Double { get set }
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

struct ModelMsgs {
    static let notificationName = "ColorSquareModel"
    static let notificationEventKey = "CS Model Message Key"
    static let modelChangeDidSucceed = "CS Model Change Succeeded"
    static let modelChangeDidFail = "CS Model Change Failed"
}

class ColoredSquareModel: ColoredSquareDataSource {
    struct Limits {
        // Control the location on screen
        static let defaultX = 10.0
        static let defaultY = 30.0
        static let maxX = 400.0
        static let maxY = 600.0
        static let minX = 0.0
        static let minY = 0.0
        
        // Control the size of the square
        static let defaultSide = 50.0
        static let minSide = 2.0
        static let maxSide = 250.0
        
        // Color limits: This is the standard range for an HSV color
        static let defaultHue = 0.0 // red
        static let minHue = 0.0
        static let maxHue = 1.0
    }
    
    var values: [String: NumericAttribute] = [
        ModelKeys.xLoc: NumericAttribute(min: 0.0, max: 0.0, value: Limits.defaultX),
        ModelKeys.yLoc: NumericAttribute(min: 0.0, max: 0.0, value: Limits.defaultY),
        ModelKeys.sideLength: NumericAttribute(min: Limits.minSide, max: Limits.maxSide, value: Limits.defaultSide),
        ModelKeys.hue: NumericAttribute(min: Limits.minHue, max: Limits.maxHue, value: Limits.defaultHue)
    
    ]
    
    init(minX: Double, maxX:Double, minY:Double, maxY: Double) {
        assert(minX < maxX && minY < maxY)
        values[ModelKeys.xLoc]!.min = minX
        values[ModelKeys.xLoc]!.max = maxX
        values[ModelKeys.yLoc]!.min = minY
        values[ModelKeys.yLoc]!.max = maxY
    }

    // myModel["xLoc"] = 57.0 <---- this is the newValue as Double?; index gets bound to "xLoc"
    subscript(index: String) -> Double? {
        get {
            return values[index]?.value // present just the Double, not the min/max
        }
        // filter out invalid data "at the door"
        //implicit declaration for "set" method: subscript(index: String, newValue:Double?)
        set {
            var successFlag = false
            if let attr = values[index], var unwrappedValue = newValue {
                if unwrappedValue < attr.min { // if enterd value too low, bound it at the minimum
                    unwrappedValue = attr.min
                }
                else if unwrappedValue > attr.max {
                    unwrappedValue = attr.max
                }
                // now suppose the value is input
                if unwrappedValue != attr.value {
                    // Three requirments now met:
                    // valid (known key) param
                    // non-nil Double optional passed in
                    // the value is substantially different than existing
                    successFlag = true
                    values[index]!.value = unwrappedValue
                    // why would attr.value = ... do not good? 
                    // because it is a copy
                }
                
            }
            notifyObservers(success: successFlag)
        }
    }
    // construct a notification
    func notifyObservers(#success: Bool) {
        let message = success ? ModelMsgs.modelChangeDidSucceed: ModelMsgs.modelChangeDidFail
        let notification = NSNotification(name: ModelMsgs.notificationName, object: self, userInfo: [ModelMsgs.notificationEventKey : message])
        NSNotificationCenter.defaultCenter().postNotification(notification) // missing somthing here
    }
    
    
    
    var vx = Limits.minX {
        didSet {
            if vx < Limits.minX || vx >= Limits.maxX {
                vx = oldValue
            }
        }
    }

    var vy = Limits.minY {
        didSet {
            if vy < Limits.minY || vy >= Limits.maxY {
                vy = oldValue
            }
        }
    }

    var side = Limits.defaultSide {
        didSet {
            if side < Limits.minSide || side > Limits.maxSide {
                side = oldValue
            }
        }
    }
    
    var hue = Limits.minHue {
        didSet {
            // Just to show there's different ways of handling out-of-bounds values,
            // we'll use the limit rather than the old value
            if hue < Limits.minHue {
                hue = Limits.minHue
            }
            else if hue > Limits.maxHue {
                hue = Limits.maxHue
            }
        }
    }
}
