//
//  TimerViewController.swift
//  Lecture3Demo
//
//  Created by Daniel Bromberg on 6/27/15.
//  Copyright (c) 2015 S65. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {
    @IBOutlet weak var timerLog: UITextView!
    
    // Must be an optional because it starts off as nil: it makes no sense to have a timer initialized (and thus, started) in our situtation. Its only effect is visual.
    private var timer: NSTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Clear out the IB-initialized value; we want to start off fresh and only put in our
        // own log messages.
        timerLog.text = ""
        logIt("View just loaded, clearing text from IB value and starting observers")
        startObservers()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        logIt("View just appeared")
    }
    
    func handleAppActivated() {
        logIt("App just activated")
        // Let's start building thread-awareness. We'll visit this topic many times.
        // All UI manipulation must go on the "main" thread. However, that poses no
        // challenges here. The documentation says that a timer created thusly will go off
        // on the same thread from which it was started (terminology is "current run loop").
        // Remember that 'text' is always an observed property so redrawing messages happen automagically
        timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "handleTimer:", userInfo: nil, repeats: true)
        logIt("Timer created at \(NSDate()) when App activated")
    }
    
    // Strictly speaking, all timers are automatically suspended when an App resigns control of the screen. This is just here to show we can capture the event, and there are other practical reasons to do so.
    func handleAppResigned() {
        logIt("App just resigned")
        if let t = timer {
            t.invalidate()
            logIt("Timer NOT canceled at \(NSDate()) when app resigned")
        }
        else {
            logIt("Strange, there was no timer to cancel. Lifecycle error?")
        }
    }
    
    func handleTimer(timer: NSTimer) {
        // deliberately crash if this is not occurring on the UI thread
        assert(NSThread.isMainThread())
        logIt("Timer went off at \(NSDate())")
    }
    
    func logIt(msg: String) {
        // All UI manipulations must happen on the 'main' thread.
        // Notifications and Timer events don't necessarily happen on the
        // main thread, so documentation must be checked carefully.
        timerLog.insertText("\(msg)\n") // insertText() also triggers an automatic redraw
        // Log to the console as well in case there's any problems with the UI
        println("\(NSDate()) \(msg)")
    }
    
    func startObservers() {
        let center = NSNotificationCenter.defaultCenter()
        // The "mainQueue()" stuff just means run the notificaition handler on th emain thread, where it is safe to perform
        // UI manipulations. If you follow the call chain, there is ultimately a manipulation of the UITextView
        center.addObserverForName(TimerApp.NotificationName, object: nil, queue: NSOperationQueue.mainQueue()) {
            // ignore the [unowned self] for now; it's called a "capture list" and it's just something you need
            // when an anonymous closure is using its containing object's data. It has to do with correct memory
            // management and is one of the sharp ugly corners of Swift programming.
            [unowned self] // This is the capture list: how to capture 'self'
            (notification: NSNotification!) -> Void in
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

