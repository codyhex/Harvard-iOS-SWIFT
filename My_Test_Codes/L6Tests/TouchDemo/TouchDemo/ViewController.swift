//
//  ViewController.swift
//  TouchDemo
//
//  Created by Peng on 7/8/15.
//  Copyright (c) 2015 Peng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        if let uiTouches = event.touchesForView(view) as? Set<UITouch>,
        let touchCount = event.allTouches()?.count,
            let touch = uiTouches.first {
                println("\(touchCount)")
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

