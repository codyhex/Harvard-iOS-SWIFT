//
//  ViewController.swift
//  MVCClassDemo
//
//  Created by Daniel Bromberg on 7/6/15.
//  Copyright (c) 2015 S65. All rights reserved.
//

import UIKit

extension String {
    func toDouble() -> Double? {
        return NSNumberFormatter().numberFromString(self)?.doubleValue
    }
}

class ViewController: UIViewController {
    var allFields = [ UITextField : String ]()
    @IBOutlet weak var xLocField: UITextField! {
        didSet { allFields[xLocField] = ModelKeys.xLoc }
    }
    @IBOutlet weak var yLocField: UITextField! {
        didSet { allFields[yLocField] = ModelKeys.yLoc }
    }
    @IBOutlet weak var hueField: UITextField! {
        didSet { allFields[hueField] = ModelKeys.hue }
    }
    @IBOutlet weak var sideLengthField: UITextField! {
        didSet { allFields[sideLengthField] = ModelKeys.sideLength }
    }
    
    @IBOutlet weak var squareView: ColoredSquareView!
    
    // ViewController is the bridge between view and the model. Therefore it must instantiate the model and 'own' it
    var model: ColoredSquareModel! {
        didSet {
            startModelListener() // Whenever model inits or changes, we need to listen to the it
        }
    }
    
    // NEW: listen for model changes
    func startModelListener() {
        // just convenience temporaries so the big call below is less cluttered
        let center = NSNotificationCenter.defaultCenter()
        let uiQueue = NSOperationQueue.mainQueue()
        
        center.addObserverForName(ModelMsgs.notificationName, object: model, queue: uiQueue) {
            [unowned self]
            (notification) in
            if let message = notification.userInfo?[ModelMsgs.notificationMessageKey] as? String {
                println("Notification from \(ModelMsgs.notificationName): \(message)")
                switch message {
                case ModelMsgs.modelChangeDidSucceed:
                    self.updateTextualView()
                    self.updateGraphicalView()
                    
                // Text fields got invalid data & need reformatting
                case ModelMsgs.modelChangeDidFail:
                    self.updateTextualView()
                    
                default:
                    assertionFailure("Unknown message: \(message)")
                }
            }
            else {
                assertionFailure("Missing message")
            }
        }
    }

    func updateTextualView() {
        for textField in allFields.keys {
            textField.text = "\(model[allFields[textField]!]!)"
        }
    }
    
    func updateGraphicalView() {
       squareView.setNeedsDisplay() // eventually calls drawRect with the correct drawing context and clipping Rect
    }
    
    // Low level UI event taken care of by iOS once we wire it up:
    // Editing Did End
    // Whole idea of a controller is to translate this into an APPLICATION level event: "my X Location should be updated"
    @IBAction func numericValueDidChange(textField: UITextField) {
        model[allFields[textField]!] = textField.text.toDouble()
    }
    
    @IBAction func squareViewWasTapped(sender: UITapGestureRecognizer) {
        let tapSpot = sender.locationInView(squareView)
        // translating iOS object (CGPoint) to our model
        model[ModelKeys.xLoc] = Double(tapSpot.x)
        model[ModelKeys.yLoc] = Double(tapSpot.y)
    }
        
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let f = squareView.frame // just a convenience for shorter notation
        model = ColoredSquareModel(minX: 0.0, maxX: Double(f.maxX - f.minX), minY: 0.0, maxY: Double(f.maxY - f.minY))
        squareView.dataSource = model
        model.notifyObservers(success: true)
    }
}

