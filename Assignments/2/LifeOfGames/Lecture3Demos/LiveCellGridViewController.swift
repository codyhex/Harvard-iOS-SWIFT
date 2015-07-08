//
//  LiveCellGridViewController.swift
//  Lecture3Demo
//
//  Created by Daniel Bromberg on 6/27/15.
//  Copyright (c) 2015 S65. All rights reserved.
//
import Foundation // NSTimer
import UIKit



class LiveCellGridViewController: CellGridViewController {

    var intervalSeconds = 0.5 {
        didSet {
            println("interval set to \(intervalSeconds)")
        }
    }
    
    private var timer: NSTimer?

    override func viewDidLoad() {
        super.viewDidLoad()
        startObservers()
    }
    
    @IBOutlet weak var sliderField: UISlider!
    
    @IBOutlet weak var intervalField: UILabel!
    
    @IBOutlet weak var geneField: UILabel!
    
    @IBOutlet weak var switchField: UILabel!
    
    @IBAction func switchChange(sender: UISwitch) {
        if sender.on {
            handleAppActivated()
            switchField.text = ""
        } else {
            assert(timer != nil)
            timer!.invalidate()
            timer = nil
            
            switchField.text = "Game Paused"
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
        
        handleAppResigned()     // stop current timer
        timer = nil             // release the timer
        handleAppActivated()    // assign a new timer
        
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
            
            geneField.text = "The \(m.generation)nd Gen"
            
            m.nextGeneration()
            // Responsibility is on the implementor to call setNeedsDisplay() whenever
            // a significant change to the underlying model has occurred.
            // This is a *request* that is scheduled to happen sometime later.
            // (But soon; we want the App to be responsive and interactive)
            
            cellGridView.setNeedsDisplay()
        }
    }
    
    func startObservers() {
        let center = NSNotificationCenter.defaultCenter()
        center.addObserverForName(TimerApp.NotificationName, object: nil, queue: NSOperationQueue.mainQueue()) {
            [unowned self]
            (notification) in
            if let message = notification.userInfo?[TimerApp.MessageKey] as? String {
                
//                self.intervalSeconds = Double(round(Double(self.sliderField.value) * 10)/10)
                
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
}