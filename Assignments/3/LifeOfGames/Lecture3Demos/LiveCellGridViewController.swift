//
//  LiveCellGridViewController.swift
//  Lecture3Demo
//
//  Created by Daniel Bromberg on 6/27/15.
//  Copyright (c) 2015 S65. All rights reserved.
//
import Foundation // NSTimer

import UIKit

let touchEnumToString: [ UITouchPhase : String ] =
[.Began: "began", .Cancelled: "cancelled", .Ended: "ended",
    .Moved: "moved", .Stationary: "stationary" ]

class LiveCellGridViewController: CellGridViewController {
    var observer: NSObjectProtocol? /* Not shown in class. See startObservers / viewDidDisappear below */

    var intervalSeconds = 0.5 {
        didSet {
            println("interval set to \(intervalSeconds)")
        }
    }
    
    private var timer: NSTimer?

    override func viewDidLoad() {
        super.viewDidLoad()
        startObservers()
        startModelListener()
        
    }
    
    @IBOutlet weak var sliderField: UISlider!
    
    @IBOutlet weak var intervalField: UILabel!
    
    @IBOutlet weak var geneField: UILabel!
    
    @IBOutlet weak var switchField: UILabel!
    
    var switchFlag: Bool = true // adding this flag will prevent slider reactivate the game while switch is Off
    
    @IBAction func switchChange(sender: UISwitch) {
        if sender.on {
            if timer == nil {
                handleAppActivated()    // assign a new timer
            }
            switchField.text = ""
            switchFlag = true
            
        } else {
            assert(timer != nil)
            if timer != nil {
                timer!.invalidate()
                timer = nil
            }
            switchField.text = "Game Paused"
            
            switchFlag = false
        }
    }
    
    
    @IBAction func sliderChange(sender: UISlider) {
        // some how the sliderField.valve is a Float and results in long digits when rounded and have to cast it into Doule
        intervalSeconds = Double(round(Double(sliderField.value) * 10)/10)
        
        println("current value of slider is \(intervalSeconds)")
        
        intervalField.text = "Interval: \(intervalSeconds)s"
        
        // Update timer, so our new interval second can be used. 
        // This is the way that I figured it out
        // I suppose there should be a timer.reset() to reset the intervalSecond but I fail to find it.
        
        // only when the switch is remaining ON, the slider will start the timer
        if switchFlag == true {
            if timer == nil {
                handleAppActivated()    // assign a new timer
            }
            else {
                handleAppResigned()     // stop current timer
                timer = nil             // release the timer
                handleAppActivated()    // assign a new timer
            }
        }
        
    }
    
    func handleAppActivated() {
        assert(timer == nil)
        timer = NSTimer.scheduledTimerWithTimeInterval(intervalSeconds, target: self, selector: "handleTimer:", userInfo: nil, repeats: true)
    }
    
    func handleAppResigned() {
        assert(timer != nil)
        timer!.invalidate()
    }
    
    func handleTimer(timer: NSTimer) {
        if let m = model {

            geneField.text = "The \(m.getGeneration())nd Gen"
            /* @@HP: the model will send a msg after produce next generation */
            m.nextGeneration()

        }
    }
    
    func startObservers() {
        let center = NSNotificationCenter.defaultCenter()
        center.addObserverForName(TimerApp.NotificationName, object: nil, queue: NSOperationQueue.mainQueue()) {
            [unowned self]
            (notification) in
            if let message = notification.userInfo?[TimerApp.MessageKey] as? String {
                
                switch message {
                // When we're in a closure, all uses of 'self' must be explicit
                case TimerApp.ActivatedMessage: self.handleAppActivated()
                case TimerApp.ResignedMessage: self.handleAppResigned()
                default: assertionFailure("Unknown message: \(message)")
                }
            }
            else {
                assertionFailure("Missing message")
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        model.notifyObservers(success: true) // Need to force the view to update
    }
    
    /** UIBible "F)": disposing of unused observers. Not shown in class **/
    override func viewDidDisappear(animated: Bool) {
        if let obs = observer {
            NSNotificationCenter.defaultCenter().removeObserver(obs)
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
            println("Model Change Failed")
        case ModelMsgs.modelChangeDidSucceed:
            updateGraphicalView()
        default:
            assertionFailure("Unexpected message: \(message)")
        }
    }
    
    func updateGraphicalView() {
        // STEP 8 of diagram: inform the view it's out of date
        cellGridView.setNeedsDisplay()
    }
    
    
    /* @HP: <#commment#> */
    @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translationInView(self.view)
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                y:view.center.y + translation.y)
        }
        recognizer.setTranslation(CGPointZero, inView: self.view)
    }
    
    /* @HP: Start the touch function */
    /* @HP: This should happens ONLY when the pause is enabled */
    
    /* @HP: Basic touching feature codes copied from class */
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        if let uiTouches = event.touchesForView(view) as? Set<UITouch>,
            let touchCount = event.allTouches()?.count, // "1" for one finger touches, "2" for two finger touches
            let touch = uiTouches.first {
                // normally, you need to translate the touch to the desired custom rendered subview
                println("\(touchCount)-finger drag started at \(touch.locationInView(view))")
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        if let uiTouches = event.touchesForView(view) as? Set<UITouch>,
            let touchCount = event.allTouches()?.count,
            let touch = uiTouches.first {
                println("\(touchCount)-finger drag ended at \(touch.locationInView(view))")
        }
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        if let uiTouches = event.touchesForView(view) as? Set<UITouch>,
            let touchCount = event.allTouches()?.count,
            let touch = uiTouches.first {
                println("\(touchCount)-finger drag continued at \(touch.locationInView(view))")
        }
    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib.
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   

}

