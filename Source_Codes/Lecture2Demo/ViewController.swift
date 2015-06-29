//
//  ViewController.swift
//  Lecture2Demo
//
//  Created by Daniel Bromberg on 6/24/15.
//  Copyright (c) 2015 S65. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var greetingLabel: UILabel!
    
    @IBAction func sayItWasTapped(sender: AnyObject) {
        greetingLabel.text = "Hello, \(nameTextField.text)"
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

