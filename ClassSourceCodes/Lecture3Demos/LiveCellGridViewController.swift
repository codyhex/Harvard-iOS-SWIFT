//
//  LiveCellGridViewController.swift
//  Lecture3Demo
//
//  Created by Daniel Bromberg on 6/27/15.
//  Copyright (c) 2015 S65. All rights reserved.
//
import Foundation // NSTimer
import UIKit

// Verbose, so just allow a global constant
let Center = NSNotificationCenter.defaultCenter()


extension UIDevice {
    var orientationAsString: String {
        let orientationStrings = [
            "Unknown", "Portrait", "PortraitUpsideDown",
            "LandscapeLeft", "LandscapeRight", "FaceUp", "FaceDown"]
        return orientationStrings[orientation.rawValue]
    }
}

// CHANGE Minor: removed superficial 'CellGridViewController' from hierarchy
class LiveCellGridViewController: UIViewController {
    @IBOutlet weak var generationLabel: UILabel!
    @IBOutlet weak var intervalSecondsLabel: UILabel!
    @IBOutlet weak var activeSwitch: UISwitch!
    @IBOutlet weak var intervalSlider: UISlider!
    @IBOutlet weak var lifeView: ModelBasedCellGridView!
    @IBOutlet weak var numLiving: UILabel!
    
    var model: CellGridModel?
    
    // CHANGE Minor: promoted from 'CellGridViewController'
    @IBOutlet weak var cellGridView: ModelBasedCellGridView!
    
    // NEW Store observers in an array to release them easily
    var observers = [NSObjectProtocol]()
    
    private var timer: NSTimer?
    
    // SOLUTION: Represent the pen state as a stored property
    private var penState: CellState?
    
    // SOLUTION: Inform the model when user toggles a switch
    @IBAction func toggleActive(sender: UISwitch) {
        model?.running = sender.on
    }
    
    // SOLUTION: Inform the model when user slides the slider
    @IBAction func speedDidChange(sender: UISlider) {
        model?.intervalSeconds = Double(sender.value)
    }
    
    // ENHANCEMENT: pull model from disk if possible
    // CHANGE: Minor: promoted code from 'CellGridViewController' to init model
    override func viewDidLoad() {
        super.viewDidLoad()
        if let restoredModel = Persistence.restore() as? CellGridModel {
            model = restoredModel
            println("Awoke model from disk")
        }
        else {
            model = CellGridModel(size: 20)
            println("Could not awaken, starting new model")
        }
        
        cellGridView.dataSource = model
        startObservers()
    }
    
    // CHANGE: Release observers properly, to ready for Assignment 4
    // Called just before the object is deallocated. When user pops child view off of Navigation stack
    // the child's view controller is deallocated. The observers are closures that contain references to 
    // this 'self'. When this 'self' becomes invalid, we must clear out those closures as follows.
    // Look for the code that manages the 'observers' Array stored property.
    // You don't need to use an Array; this is just my attempt at generality. You can explicitly store each
    // observer handle in a stored property.
    deinit {
        stopObservers()
    }
    
    func activateTimer() {
        assert(timer == nil && model != nil)
        timer = NSTimer.scheduledTimerWithTimeInterval(model!.intervalSeconds, target: self,
            selector: "handleTimer:", userInfo: nil, repeats: true)
    }
    
    func cancelTimer() {
        assert(timer != nil)
        timer!.invalidate()
        // SOLUTION: Since timer can be repeatedly canceled and activated, set to nil as expected by activateTimer()
        timer = nil
    }
    
    // SOLUTION: No longer call setNeedsDisplay(); rely on model and Notification processing
    func handleTimer(timer: NSTimer) {
        model?.nextGeneration()
    }
    
    // SOLUTION: Update every visual and temporal element from the current model state
    // don't assume anything is correct, including the timers which may have been adjusted by sliding
    func updateUI() {
        if let m = model {
            cellGridView.setNeedsDisplay()
            activeSwitch.on = m.running
            
            if timer != nil && (!m.running || timer!.timeInterval != m.intervalSeconds ) {
                cancelTimer()
            }

            if timer == nil && m.running {
                activateTimer()
            }
            
            generationLabel.text = "\(m.generation)"
            numLiving.text = "\(m.numLivingCells)"
            intervalSlider.value = Float(m.intervalSeconds)
            intervalSecondsLabel.text = NSString(format: "%4.2fs", m.intervalSeconds) as String
        }
    }
    
    // SOLUTION: Generalize the idea of listening to a notification
    // 'actions' is a *dispatch* table: A Dictionary mapping messages to functions. That is, quickly determine
    // the actions to take based on a message.
    // This is an important idiom across all languages and makes for compact, fast code.
    // The limitation is that the message signature of every action function must be identical.
    func watch(notifyName: String, sourceObj: AnyObject?, messageKey: String, actions: [String: () -> Void]) {
        let obsHandle = Center.addObserverForName(notifyName, object: sourceObj, queue: NSOperationQueue.mainQueue()) {
            [unowned self]
            (notification) in
            if let message = notification.userInfo?[messageKey] as? String {
                if let actionFunc = actions[message] {
                    actionFunc()
                }
                else {
                    assertionFailure("Unkonwn message: \(message)")
                }
            }
            else {
                assertionFailure("Missing message key \(messageKey) for \(notifyName)")
            }
        }
        observers.append(obsHandle)
    }
    
    // ENHANCEMENT: Allow upside down operation
    // http://stackoverflow.com/questions/14057778/cannot-rotate-interface-orientation-to-portrait-upside-down
    override func supportedInterfaceOrientations() -> Int {
        // default is .AllButUpsideDown
        return Int(UIInterfaceOrientationMask.All.rawValue) // one of the ugly corners of bridging to old API
    }
    
    // ENHANCEMENT: Handle event of orientation change
    func orientationDidChange() {
        println("orientation changed to \(UIDevice.currentDevice().orientationAsString)")
        updateUI()
    }
    
    func startObservers() {
        // ENHANCEMENT: Listen for changes to orientation
        Center.addObserver(self, selector: "orientationDidChange", name: UIDeviceOrientationDidChangeNotification, object: nil)
        // SOLUTION: Listen to a variety of messages from Timer and Model, using a dispatch table
        watch(TimerApp.NotificationName, sourceObj: nil, messageKey: TimerApp.MessageKey, actions: [
            TimerApp.ActivatedMessage: updateUI,
            TimerApp.ResignedMessage: updateUI])
        watch(CellGridModel.NotificationName, sourceObj: nil, messageKey: CellGridModel.MessageKey, actions: [
            CellGridModel.NewGeneration: updateUI,
            CellGridModel.GridChange: updateUI,
            CellGridModel.IntervalChange: updateUI,
            CellGridModel.SimulationResumed: updateUI,
            CellGridModel.SimulationPaused: updateUI])
    }
    
    // SOLUTION: Implemention of releasing observers
    func stopObservers() {
        Center.removeObserver(self, name: UIDeviceOrientationDidChangeNotification, object: nil)
        for o in observers {
            Center.removeObserver(o)
        }
    }
    
    // MARK - touches
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        if model!.running {
            return
        }
        if let uiTouches = event.touchesForView(lifeView) as? Set<UITouch>,
            let touchCount = event.allTouches()?.count,
            let touch = uiTouches.first where touchCount == 1 {
                // SOLUTION: Handle a valid touch, translate to logical coordinates
                let touchPoint = touch.locationInView(lifeView)
                let xDim = Int(touchPoint.x / lifeView.cellDim.x)
                let yDim = Int(touchPoint.y / lifeView.cellDim.y)
                let state = model!.grid[xDim][yDim]
                penState = state == .Alive || state == .Born ? .Died : .Born
                model!.grid[xDim][yDim] = penState!
        }
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        if model!.running {
            return
        }
        if let uiTouches = event.touchesForView(lifeView) as? Set<UITouch>,
            let touchCount = event.allTouches()?.count,
            let touch = uiTouches.first where touchCount == 1 {
                // SOLUTION: Handle a continuing valid touch
                let touchPoint = touch.locationInView(lifeView)
                let xDim = Int(touchPoint.x / lifeView.cellDim.x)
                let yDim = Int(touchPoint.y / lifeView.cellDim.y)
                // A drag must start in view but can wander outside of view and touches event will still get sent
                // to that view
                if xDim < 0 || xDim >= model!.grid.count || yDim < 0 || yDim >= model!.grid[0].count {
                    println("Out of bounds in the drag: \(xDim), \(yDim)")
                    return
                }
                // SOLUTION: Avoid unnecessary calls to model, thus eventually to UI
                if model!.grid[xDim][yDim] != penState! {
                    model!.grid[xDim][yDim] = penState!
                }
        }
    }
    
    // ENHANCEMENT: Save every time the user modifies the grid
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        if model!.running {
            return
        }
        if let uiTouches = event.touchesForView(lifeView) as? Set<UITouch>,
            let touchCount = event.allTouches()?.count,
            let touch = uiTouches.first where touchCount == 1 {
            Persistence.save(model!)
        }
    }
}