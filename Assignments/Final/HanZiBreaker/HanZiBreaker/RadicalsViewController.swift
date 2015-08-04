//
//  RadicalsViewController.swift
//  HanZiBreaker
//
//  Created by HePeng on 7/31/15.
//  Copyright (c) 2015 HePeng. All rights reserved.
//

import UIKit

let LINKED_CHAR: Character = "-"
let TOUCH_SECTIONS: Int = 4

struct CornerIndexs {
    static let A = 0
    static let B = 1
    static let C = 2
    static let D = 3
    static let E = 4
}

class RadicalsViewController: UIViewController {
    // The parent has the responsibility of setting up the data model of the child, so the child can render itself properly
    var identifier: String? // The "model"
    var chineseName: String?
    var FCCode: String?
    var encoder: Array<Character> = Array(count: 5, repeatedValue: "-")
    
    var cornerAWasTapped = false, cornerBWasTapped = false, cornerCWasTapped = false, cornerDWasTapped = false
    
    var radicalCode = "" /* @@HP: FCcode is actually five digits */
    
    @IBOutlet weak var radicalsTextField: UILabel! {
        didSet {
            radicalsTextField.text = "Selected Radical Code: \(String(encoder))"
        }
    }
    
    @IBOutlet weak var wordImage: UIImageView! {
        didSet {
            if let imageName = chineseName {
                wordImage.image = UIImage(named: imageName)
            }
            else {
                println("image name wrong \(chineseName)")
            }
        }
    }

    @IBOutlet weak var buttonAField: UIButton!
    @IBOutlet weak var buttonBField: UIButton!
    @IBOutlet weak var buttonCField: UIButton!
    @IBOutlet weak var buttonDField: UIButton!

    
    @IBAction func cornerAwasTapped(sender: UIButton) {
        /* @@HP: animate the tapped region, onece tapped again, flip the value */
        if cornerAWasTapped == false {
            cornerAWasTapped = true
            /* @@HP: highlight the background once the button was tapped down and used as vaild */
            buttonAField.backgroundColor = UIColor(red: 0.4, green: 1.0, blue: 0.2, alpha: 0.5)

            if let code = FCCode {
                    encoder[CornerIndexs.A] = code[code.startIndex]
                }
        }
        else {
            cornerAWasTapped = false
            encoder[CornerIndexs.A] = LINKED_CHAR
            buttonAField.backgroundColor = UIColor.clearColor()
        }
        
        radicalsTextField.text = "Selected Radical Code: \(String(encoder))"
    }
    
    @IBAction func cornerBwasTapped(sender: UIButton) {
        /* @@HP: animate the tapped region, onece tapped again, flip the value */
        if cornerBWasTapped == false {
            cornerBWasTapped = true
            buttonBField.backgroundColor = UIColor(red: 0.4, green: 1.0, blue: 0.2, alpha: 0.5)

            if let code = FCCode {
                encoder[CornerIndexs.B] = code[advance(code.startIndex, CornerIndexs.B)]
            }

        }
        else {
            cornerBWasTapped = false
            encoder[CornerIndexs.B] = LINKED_CHAR
            buttonBField.backgroundColor = UIColor.clearColor()
        }
        
        radicalsTextField.text = "Selected Radical Code: \(String(encoder))"
    }
    
    @IBAction func cornerCWasTapped(sender: UIButton) {
        /* @@HP: animate the tapped region, onece tapped again, flip the value */
        if cornerCWasTapped == false {
            cornerCWasTapped = true
            buttonCField.backgroundColor = UIColor(red: 0.4, green: 1.0, blue: 0.2, alpha: 0.5)

            if let code = FCCode {
                encoder[CornerIndexs.C] = code[advance(code.startIndex, CornerIndexs.C)]
            }
        }
        else {
            cornerCWasTapped = false
            encoder[CornerIndexs.C] = LINKED_CHAR
            buttonCField.backgroundColor = UIColor.clearColor()
        }
        
        radicalsTextField.text = "Selected Radical Code: \(String(encoder))"
    }
    
    @IBAction func cornerDWasTapped(sender: UIButton) {
        /* @@HP: animate the tapped region, onece tapped again, flip the value */
        if cornerDWasTapped == false {
            cornerDWasTapped = true
            buttonDField.backgroundColor = UIColor(red: 0.4, green: 1.0, blue: 0.2, alpha: 0.5)

            if let code = FCCode {
                encoder[CornerIndexs.D] = code[advance(code.startIndex, CornerIndexs.D)]
            }
        }
        else {
            cornerDWasTapped = false
            encoder[CornerIndexs.D] = LINKED_CHAR
            buttonDField.backgroundColor = UIColor.clearColor()

        }
        
        radicalsTextField.text = "Selected Radical Code: \(String(encoder))"
    }
    
    func cleanCache() {
        cornerAWasTapped = false
        cornerBWasTapped = false
        cornerCWasTapped = false
        cornerDWasTapped = false
        
        encoder = Array<Character>(count: 5, repeatedValue: "-")
    }
    
    ///////////////////
    
    func convertFCCorners() {
        if let code = FCCode {
            for(var buttonIndex = 0; buttonIndex < TOUCH_SECTIONS; ++buttonIndex) {
                if buttonPressed[buttonIndex] == true {
                    encoder[buttonIndex] = code[advance(code.startIndex, buttonIndex)]
                }
            }
        }
        else {
            println("FC code is empty")
        }
        
    }

    /////////////////////////////////////////Draw Begins////////////////////////////////////
    //for draw
    @IBOutlet weak var selectView: UIImageView!
    var swiped = false
    var lastPoint = CGPoint.zeroPoint
    var red: CGFloat = 1.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var brushWidth: CGFloat = 5.0
    var opacity: CGFloat = 1.0
    
    //for label selection
    @IBOutlet weak var label_A: UIButton!
    @IBOutlet weak var label_B: UIButton!
    @IBOutlet weak var label_C: UIButton!
    @IBOutlet weak var label_D: UIButton!
    var labels = [UIButton]()
    var labelSelectCounts = [Int]()
    var labelSelectThreshold = 2
    
    var buttonPressed = Array<Bool>(count: TOUCH_SECTIONS, repeatedValue: false)
    
    
    //draw
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        swiped = false
        if let touch = touches.first as? UITouch {
            lastPoint = touch.locationInView(selectView)
        }
        
        //TO-DO: should register at init
        labels.removeAll()
        labels.append(label_A)
        labels.append(label_B)
        labels.append(label_C)
        labels.append(label_D)
        
        //prepare selection
        labelSelectCounts.removeAll()
        for(var i=0; i<4;i++)
        {
            labelSelectCounts.append(0)
            labels[i].backgroundColor = UIColor.clearColor()
            buttonPressed[i] = false
        }
        encoder = Array<Character>(count: 5, repeatedValue: "-")

    }
    
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        
        // 1
        UIGraphicsBeginImageContext(selectView.frame.size)
        let context = UIGraphicsGetCurrentContext()
        
        selectView.image?.drawInRect(CGRect(x: 0, y: 0, width: selectView.frame.size.width, height: selectView.frame.size.height))
        //println(fromPoint.y)
        
        // 2
        CGContextMoveToPoint(context, fromPoint.x, fromPoint.y)
        CGContextAddLineToPoint(context, toPoint.x, toPoint.y)
        
        // 3
        CGContextSetLineCap(context, kCGLineCapRound)
        CGContextSetLineWidth(context, brushWidth)
        CGContextSetRGBStrokeColor(context, red, green, blue, 1.0)
        CGContextSetBlendMode(context, kCGBlendModeNormal)
        
        // 4
        CGContextStrokePath(context)
        
        // 5 draw to
        selectView.image = UIGraphicsGetImageFromCurrentImageContext()
        selectView.alpha = opacity
        UIGraphicsEndImageContext()
        
    }
    
    func isTouchInsideLabel(pt:CGPoint, labelIndex:Int, coordView:UIImageView)->Bool {
        
        var size: CGSize
        size = labels[labelIndex].frame.size
        var convertedOrigin:CGPoint
        convertedOrigin = self.view.convertPoint(labels[labelIndex].frame.origin, toView: coordView)
        if(pt.x > convertedOrigin.x && pt.x < convertedOrigin.x + size.width && pt.y > convertedOrigin.y && pt.y < convertedOrigin.y + size.height)
        {
//            println("Inside")
            labelSelectCounts[labelIndex]++
            return true
        }
        return false
    }
    
    func selectLabel(labelIndex: Int)->Void {
        if(labelSelectCounts[labelIndex] > labelSelectThreshold)
        {
            labels[labelIndex].backgroundColor = UIColor(red: 0.4, green: 1.0, blue: 0.2, alpha: 0.5)
            buttonPressed[labelIndex] = true
        }
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        // 6
        swiped = true
        if let touch = touches.first as? UITouch {
            let currentPoint = touch.locationInView(selectView)
            drawLineFrom(lastPoint, toPoint: currentPoint)
            
            // 7
            lastPoint = currentPoint
            
            //active corresponding labels if selected
            for(var i = 0;i<4;i++)
            {
                isTouchInsideLabel(currentPoint, labelIndex:i, coordView:selectView)
                selectLabel(i)
            }
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        if !swiped {
            
        }
        // clear the drawing
        UIGraphicsBeginImageContext(selectView.frame.size)
        selectView.image = nil
        UIGraphicsEndImageContext()
        
        convertFCCorners()
        
        radicalsTextField.text = "Selected Radical Code: \(String(encoder))"

    }
    

    
    
    /////////////////////////////////////////Draw Ends////////////////////////////////////
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Identifiers.possibleRadicalsSegue {
            if let searchRadicalsVC = segue.destinationViewController as? SearchRadicalsViewController {
                if let navVC = parentViewController as? UINavigationController {
                    let numControllersOnStack = navVC.viewControllers.count
                    if let tableVC = navVC.viewControllers[numControllersOnStack - 2] as? IndexTableViewController {
                        tableVC.mostRecentMoreInfo = identifier
                        searchRadicalsVC.title = "Radicals"
                        searchRadicalsVC.radicalCode = String(self.encoder)
//                        cleanCache()
                    }
                    else {
                        assertionFailure("Failed to find a tableVC")
                    }
                }
                else {
                    assertionFailure("failed to find tne parent navigation VC")
                }
            }
            else {
                assertionFailure("failed to find a destination VC to the segue")
            }
        }
        else {
            assertionFailure("unknown segue \(segue.identifier)")
        }
    }
}
