//
//  Lecture4ViewController.swift
//  Lecture4XcodeDemo
//
//  Created by Daniel Bromberg on 7/1/15.
//  Copyright (c) 2015 S65. All rights reserved.
//

import UIKit

class Lecture4ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonClicked(sender: UIButton) {
        // Example of "nil coalescing" operator. If an optional is nil, give an alternative, otherwise unwrap
        let buttonTitle = sender.currentTitle ?? "Unknown button"
        println("\(buttonTitle) was clicked")
    }
}
