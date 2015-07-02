//
//  ViewController.swift
//  L4Tests
//
//  Created by Peng on 7/1/15.
//  Copyright (c) 2015 Peng. All rights reserved.
//

import UIKit

// UI programming shuold accurately reflect the model, ASAP
class ViewController: UIViewController,UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var bigStepper: UIStepper! {
        didSet {
            bigStepper.value = 4.0
        }
    }
    
    @IBAction func stepperTapped(sender: UIStepper) {
        // This is very different with UIPicker, NO delegate
        println(sender.value)
    }
    
    let pickerValues = ["Sky", "Earth", "Moon", "Ocean", "Human"]
    
    // all outlets is nil when being innitilized
    @IBOutlet weak var letsSeeLabel: UILabel! // '!' force unwrapped here is a convenice way for the content below, then you don't need to unwrape the var next time.
    
    @IBOutlet weak var picker: UIPickerView! {
        // add an observer
        didSet { // remember to init the delegate with these two sentance
            picker.dataSource = self
            picker.delegate = self
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        if pickerView == picker {
            return 1
        } else {
            assertionFailure("Unkown Picker")
            return -1
        }
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 5
        }
        else {
            assertionFailure("Unkown component in picker ! \(component)")
            return -1
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        // array scope can be seen outside
        // let pickerValues = ["Sky", "Earth", "Moon", "Ocean", "Human"]
        
        return pickerValues[row]
        
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        println("Row \(row) In component \(component)")
        letsSeeLabel.text = "Value chosen was \(pickerValues[row])"
        
    }
    
    var pressCount = 0 { // This is our model
        didSet {
            letsSeeLabel.text = "You had fun pressing \(pressCount) times"
        }
    }
    
   
    
    func helperFunction() {
        println("Helpping")
        pressCount += 2
        println("Returning")
    }
    
    @IBAction func funButtonTapped(sender: AnyObject) {
        ++pressCount
        helperFunction()
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()

    }
}
