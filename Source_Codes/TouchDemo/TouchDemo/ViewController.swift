//
//  ViewController.swift
//  TouchDemo
//
//  Created by Daniel Bromberg on 7/8/15.
//  Copyright (c) 2015 S65. All rights reserved.
//

import UIKit

let touchEnumToString: [ UITouchPhase : String ] =
[.Began: "began", .Cancelled: "cancelled", .Ended: "ended",
    .Moved: "moved", .Stationary: "stationary" ]

class ViewController: UIViewController {
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        if let uiTouches = event.touchesForView(view) as? Set<UITouch>,
        let touchCount = event.allTouches()?.count, // "1" for one finger touches, "2" for two finger touches
            let touch = uiTouches.first {
                // normally, you need to translate the touch to the desired custom rendered subview
                println("\(touchCount)-finger drag started at \(touch.locationInView(view))")
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        if let uiTouches = event.touchesForView(view) as? Set<UITouch>,
            let touchCount = event.allTouches()?.count,
            let touch = uiTouches.first {
                println("\(touchCount)-finger drag ended at \(touch.locationInView(view))")
        }
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        if let uiTouches = event.touchesForView(view) as? Set<UITouch>,
            let touchCount = event.allTouches()?.count,
            let touch = uiTouches.first {
                println("\(touchCount)-finger drag continued at \(touch.locationInView(view))")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

