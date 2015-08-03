//
//  ViewController.swift
//  Lecture2Demo
//
//  Created by Daniel Bromberg on 6/24/15.
//  Copyright (c) 2015 S65. All rights reserved.
//


// Debugging
// UIPicker
// Optional examples: nil, unwrapping
// inifinte loops
// ++ vs. i+3
// Round trip from UI to representation and back
import UIKit

extension String {
    func trim() -> String {
        let empties = NSCharacterSet.whitespaceAndNewlineCharacterSet()
        return self.stringByTrimmingCharactersInSet(empties)
    }
}


class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var nameTextField: UITextField! {
        didSet {
            // 'self' refers to the containing class, which feels a bit counter-intuitive
            // 3 curly braces deep
            nameTextField.delegate = self
        }
    }

    @IBOutlet weak var currentValue: UILabel!
    @IBOutlet weak var greetingLabel: UILabel!
    
    @IBAction func sayItWasTapped(sender: AnyObject) {
        greetingLabel.text = "Hello, \(nameTextField.text)"
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        println("Editing began, value: \(textField.text)")
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField == nameTextField {
            println("Editing ended, value: \(textField.text)")}
        else {
            println("Unexpected message!!")
        }
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        println("Testing if editing should end")
        if textField.text.trim() == "" {
            greetingLabel.text = "I can't say it if you won't!"
            return false
        }
        else {
            return true
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

