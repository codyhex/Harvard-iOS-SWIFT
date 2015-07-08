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
            println("interval set to \(intervalField)")
        }
    }
    
    private var timer: NSTimer?

    override func viewDidLoad() {
        super.viewDidLoad()
        startObservers()
    }
    
    @IBOutlet weak var sliderField: UISlider!
    
    @IBOutlet weak var intervalField: UILabel!
    
    @IBAction func sliderChange(sender: UISlider) {
        // some how the sliderField.valve is a Float and results in long digits when rounded and have to cast it into Doule
        var currentValue = Double(round(Double(sliderField.value) * 10)/10)
        
        println("current value of slider is \(currentValue)")
        
        intervalField.text = "\(currentValue)"
        //update timer
        
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
            m.nextGeneration()
            // Responsibility is on the implementor to call setNeedsDisplay() whenever
            // a significant change to the underlying model has occurred.
            // This is a *request* that is scheduled to happen sometime later.
            // (But soon; we want the App to be responsive and interactive)
            
//            self.intervalSeconds = Double(sliderField.value)

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