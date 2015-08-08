//
//  ViewController.swift
//  Touches
//
//  Created by Daniel Bromberg on 7/8/15.
//  Copyright (c) 2015 S65. All rights reserved.
//

import UIKit

let touchEnumToString: [UITouchPhase : String] =
[ .Began: "began", .Cancelled: "cancelled", .Ended: "ended", .Moved: "moved", .Stationary: "stationary" ]

class ViewController: UIViewController {
    func debug(kind: String, withTouches touches: Set<NSObject>, withEvent event: UIEvent) {
        print("\(event.timestamp) touches\(kind)[\(touches.count)] fingers: \(event.allTouches()!.count) ")
        for t in touches {
            let touch = t as! UITouch
            println("Phase: \(touchEnumToString[touch.phase]!)")
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        debug("Began", withTouches: touches, withEvent: event)
        if let uiTouches = event.touchesForView(view) as? Set<UITouch>,
            let touchCount = event.allTouches()?.count,
            let touch = uiTouches.first {
            println("\(touchCount)-finger drag started at \(touch.locationInView(view))")
        }
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        debug("Moved", withTouches: touches, withEvent: event)
        if let uiTouches = event.touchesForView(view) as? Set<UITouch>,
            let touchCount = event.allTouches()?.count,
            let touch = uiTouches.first {
                println("\(touchCount)-finger drag continued at \(touch.locationInView(view))")
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        debug("Ended", withTouches: touches, withEvent: event)
        if let uiTouches = event.touchesForView(view) as? Set<UITouch>,
            let touchCount = event.allTouches()?.count,
            let touch = uiTouches.first {
                println("\(touchCount)-finger drag finished at \(touch.locationInView(view))")
        }
    }
}
