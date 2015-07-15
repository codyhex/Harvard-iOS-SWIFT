//
//  LiveCellGridViewController.swift
//  Lecture3Demo
//
//  Created by Daniel Bromberg on 6/27/15.
//  Copyright (c) 2015 S65. All rights reserved.
//
import Foundation // NSTimer
import UIKit


struct ModelMsgs {
    static let notificationName = "ColoredSquareModel"
    static let notificationEventKey = "CS Model Message Key"
    static let modelChangeDidSucceed = "CS Model Change Succeeded"
    static let modelChangeDidFail = "CS Model Change Failed"
}

class LiveCellGridViewController: CellGridViewController {
    var observer: NSObjectProtocol?
    
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
        
        /* @@HP: do not call directly, use notify here */
        /* @@HP: when timer traggers, send a msg */
        println("handle Timer")
        
        var successFlag = true
        /* @@HP: now sending the succeed msg only */
        notifyObservers(success: successFlag)

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
    
    /* @@HP: Start the notificate Mode Below */
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let frame = squareView.frame
        /** UIBible "A)": gaining access to the models it needs **/
        /* @@HP: The way of initial with a class constructor */
//        model = ColoredSquareModel(minX: 0.0, maxX: Double(frame.width),
//            minY: 0.0, maxY: Double(frame.height))
        /** UIBible "B": set delegates **/
        cellGridView.dataSource = model // In-class Mistake 1: this was left out
        // In-class Mistake 3: no final notification sent
        /* @@Don't understand: how to update */
        model.notifyObservers(success: true) // Need to force the view to update
    }
    }
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
            println("problem")
            if let message = notification.userInfo?[ModelMsgs.notificationEventKey] as? String {
                self.handleNotification(message) // "self." is required in closures
            }
            else {
                assertionFailure("No message found in notification")
            }
        }
    }
    
    
    
    
    func handleNotification(message: String) {
        // STEP 7 of diagram: parse & process the message
        switch message {
        case ModelMsgs.modelChangeDidFail:
            println("Just fake one") // but NOT necessary to change graphical view; numbers haven't actually changed
        case ModelMsgs.modelChangeDidSucceed:
            updateGraphicalView()
        default:
            assertionFailure("Unexpected message: \(message)")
        }
    }
    
    
    func updateGraphicalView() {
        if let m = model {
            
            geneField.text = "The \(m.generation)nd Gen"
            
            m.nextGeneration()
            // Responsibility is on the implementor to call setNeedsDisplay() whenever
            // a significant change to the underlying model has occurred.
            // This is a *request* that is scheduled to happen sometime later.
            // (But soon; we want the App to be responsive and interactive)
            
            cellGridView.setNeedsDisplay()
        }
    }
}

