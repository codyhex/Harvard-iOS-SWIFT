//
//  ViewController.swift
//  MyMVCdemo
//
//  Created by Peng on 7/6/15.
//  Copyright (c) 2015 Peng. All rights reserved.
//

import UIKit

extension String {
    func toDouble() -> Double? {
        return NSNumberFormatter().numberFromString(self)?.doubleValue
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var xLocField: UITextField!
    @IBOutlet weak var yLocField: UITextField!
    @IBOutlet weak var hueField: UITextField!
    @IBOutlet weak var sideLengthField: UITextField!

    @IBOutlet weak var squareView: ColoredSquareView!
    
    // View controller is the bridge between view and the model. Therefore it myst instantiate the model and 'own' it
    var model: ColoredSquareModel?
    
    func updateUI() {
        
        hueField.text = "\(model!.hue)"
        sideLengthField.text = "\(model!.sideLength)"
        xLocField.text = "\(model!.xLoc)"
        yLocField.text = "\(model!.yLoc)"
        
        squareView.setNeedsDisplay() // put the re-draw in the queue, eventually calls drawRect in the right context
    }
    
    @IBAction func xLocDidChange(sender: UITextField) {
        if let newXLoc = sender.text.toDouble() {
            model?.xLoc = newXLoc
        }
        updateUI()
    }
    @IBAction func yLocDidChange(sender: UITextField) {
        if let newYLoc = sender.text.toDouble() {
            model?.yLoc = newYLoc
        }
        updateUI()
    }
    @IBAction func sideLengthChanged(sender: UITextField) {
        if let newSideLength = sender.text.toDouble() {
            model?.sideLength = newSideLength
        }
        updateUI()
    }
    
    @IBAction func hueDidChange(sender: UITextField) {
        if let newHue = sender.text.toDouble() {
            model?.hue = newHue
        }
        updateUI()
    }
    
    @IBAction func touchScreen(sender: UITapGestureRecognizer) {
        
        
    }
    
    
    // view happens before app view shows
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        model = ColoredSquareModel()
        squareView.dataSource = model
        
        updateUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

