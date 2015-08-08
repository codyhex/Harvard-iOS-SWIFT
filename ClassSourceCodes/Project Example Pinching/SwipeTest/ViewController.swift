//
//  ViewController.swift
//  SwipeTest
//
//  Created by Daniel Bromberg on 7/23/15.
//  Copyright (c) 2015 S65. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    @IBAction func pinched(sender: UIPinchGestureRecognizer) {
        println("\(sender.scale) \(sender.velocity)")
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

