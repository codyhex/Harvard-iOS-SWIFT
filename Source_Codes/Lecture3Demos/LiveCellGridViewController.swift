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
    let intervalSeconds = 1.5
    
    private var timer: NSTimer?

    override func viewDidLoad() {
        super.viewDidLoad()
        startObservers()
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
            cellGridView.setNeedsDisplay()
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
}