//
//  Lecture4DemoViewController.swift
//
//
//  Created by Daniel Bromberg on 7/1/15.
//
//

import UIKit

// ***Fundamental requirement of UI programming is that the View should
// accurately reflect the model, **ASAP** ***

class Lecture4DemoViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    //let pickerValues = [ "Asparagus", "Orangutan", "Boats", "Bears", "A Velociraptor"]
    
    @IBOutlet weak var picker2: UIDatePicker!
    @IBOutlet weak var thirteenStepper: UIStepper! {
        didSet {
            thirteenStepper.value = 4.0
        }
    }
    
    @IBAction func stepperTapped(sender: UIStepper) {
        // Very different than UIPicker.
        // It *Does* have state: the value!
        println(sender.value)
    }
    
    @IBOutlet weak var letsSeeLabel: UILabel!
    
    @IBOutlet weak var pickerr: UIPickerView! {
        didSet {
            self.pickerr.dataSource = self
            self.pickerr.delegate = self
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        println("Row: \(row) In Component: \(component)")
        // letsSeeLabel.text = "Value chosen was \(pickerValues[row])"
        letsSeeLabel.text = "Value chosen was \(row * 2)"
    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        if pickerView == pickerr {
            return 1
        } else {
            assertionFailure("Unknown picker!!")
            return -1
        }
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 5
        }
        else {
            assertionFailure("Unknown component in picker! \(component)")
            return -1
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String!
    {
        // pickerValues can't be here any more; other functions need them to update the UI
        // return pickerValues[row]
        return "\(row * 2)"
    }
    
    var pressCount = 0 { // This is our Model!
        didSet {
            println("didSet fired on pressCount: \(pressCount)")
        }
    }
    
    
    func helperFunction() {
        println("I'm helping!")
        pressCount = pressCount + 2
        println("I'm returning!")
    }
    
    
    @IBAction func funButtonReallyTapped(sender: AnyObject) {
        pressCount++
        letsSeeLabel.text = "You had fun pressing \(pressCount) times"
        
        helperFunction()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
