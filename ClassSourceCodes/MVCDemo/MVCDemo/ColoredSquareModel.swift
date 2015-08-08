import Foundation // 'round' function

protocol ColoredSquareDataSource {
    var vx: Double { get set }
    var vy: Double { get set }
    var side: Double { get set }
    var hue: Double { get set }
}

class ColoredSquareModel: ColoredSquareDataSource {
    struct Limits {
        // Control the location on screen
        static let maxX = 400.0
        static let maxY = 600.0
        static let minX = 0.0
        static let minY = 0.0
        
        // Control the size of the square
        static let defaultSide = 50.0
        static let minSide = 2.0
        static let maxSide = 250.0
        
        // Color limits: This is the standard range for an HSV color
        static let minHue = 0.0
        static let maxHue = 1.0
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
