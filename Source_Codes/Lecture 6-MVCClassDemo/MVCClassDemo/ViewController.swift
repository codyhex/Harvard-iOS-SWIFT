//
//  ViewController.swift
//  MVCClassDemo
//
//  Created by Daniel Bromberg on 7/6/15.
//  Copyright (c) 2015 S65. All rights reserved.
//

import UIKit

/* Our usual extension to get a function that acts just like toInt() */
extension String {
    func toDouble() -> Double? {
        return NSNumberFormatter().numberFromString(self)?.doubleValue
    }
}

class ViewController: UIViewController {
    var observer: NSObjectProtocol? /* Not shown in class. See startObservers / viewDidDisappear below */
    
    // When an event comes in, I want to easily find out which named parameter the event (sending Text field)
    // is associated with
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
    // By the time viewDidLoad is called, the allFields dict is fully popuulated
    // Suspending an app does not affect any of this initialization -- it all stays as it last was
    
    @IBOutlet weak var squareView: ColoredSquareView!
    
    /** "D)" of UIBible **/
    @IBAction func squareViewWasTapped(sender: UITapGestureRecognizer) {
        let tapSpot = sender.locationInView(squareView)
    }
    
    // Mistake 2: this was entirely left out, so the process never got kicked off
    // STEP 1 of diagram (hidden in "editingDidEnd" event): iOS calls this for us
    /** "D)" of UIBible **/
    @IBAction func numericValueDidChange(sender: UITextField) {
        let modelKey = allFields[sender]!
        // STEP 2 of diagram: translate the UI into a model update
        model[modelKey] = sender.text.toDouble()
    }
  
    // Why create trouble for myself? Why not initialize model in viewDidLoad()?
    // In viewDidLoad, all the child views & sizes have not been calculated or laid out yet.
    // The "frame" values are those found in the StoryBoard, artificial values.
    
    /* 
       Between viewDidLoad & viewDidAppear is a layout process, where you have hooks:
       viewWillLayoutSubviews & viewDidLayoutSubviews
    */
    
    /* viewDidAppear only happens after all views have been painted once */
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let frame = squareView.frame
        /** UIBible "A)": gaining access to the models it needs **/
        model = ColoredSquareModel(minX: 0.0, maxX: Double(frame.width),
            minY: 0.0, maxY: Double(frame.height))
        /** UIBible "B": set delegates **/
        squareView.dataSource = model // In-class Mistake 1: this was left out
        // In-class Mistake 3: no final notification sent
        model.notifyObservers(success: true) // Need to force the view to update
    }
    
    /** UIBible "F)": disposing of unused observers. Not shown in class **/
    override func viewDidDisappear(animated: Bool) {
        if let obs = observer {
            NSNotificationCenter.defaultCenter().removeObserver(obs)
        }
    }
    
    var model: ColoredSquareDataSource! {
        didSet {
            startModelListener()
        }
    }
    
    
    func startModelListener() {
        let center = NSNotificationCenter.defaultCenter()
        let uiQueue = NSOperationQueue.mainQueue() // all UI activity must happen on the "main" thread
        
        /** UIBible C) Listen to relevant broadcasts **/
        observer = center.addObserverForName(ModelMsgs.notificationName, object: model, queue: uiQueue) {
            [unowned self]
            (notification) in
            // STEP 6 of diagram: hear the change (via a closure)
            // pull out the specifics from the userInfo dictiontary
            if let message = notification.userInfo?[ModelMsgs.notificationEventKey] as? String {
                self.handleNotification(message) // "self." is required in closures
            }
            else {
                assertionFailure("No message found in notification")
            }
        }
    }
    
    /** UIBible E) Translate broadcasted message into view update commands **/
    func handleNotification(message: String) {
        // STEP 7 of diagram: parse & process the message
        switch message {
        case ModelMsgs.modelChangeDidFail:
            updateTextualView() // but NOT necessary to change graphical view; numbers haven't actually changed
        case ModelMsgs.modelChangeDidSucceed:
            updateGraphicalView()
            updateTextualView()
        default:
            assertionFailure("Unexpected message: \(message)")
        }
    }
    
    func updateGraphicalView() {
        // STEP 8 of diagram: inform the view it's out of date
        squareView.setNeedsDisplay()
    }
    
    func updateTextualView() {
        for textField in allFields.keys {
            let modelKey = allFields[textField]!
            // STEPS 8, 9, and 10 of diagram: It all happens within the UITextField code
            textField.text = "\(model[modelKey]!)"
        }
    }
}

