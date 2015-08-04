//
//  RadicalsViewController.swift
//  HanZiBreaker
//
//  Created by HePeng on 7/31/15.
//  Copyright (c) 2015 HePeng. All rights reserved.
//

import UIKit

class RadicalsViewController: UIViewController {
    // The parent has the responsibility of setting up the data model of the child, so the child can render itself properly
    var identifier: String? // The "model"
    var chineseName: String?
    var FCCode: String?
    
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
    var labelSelectThreshold = 5
    
    
    @IBOutlet weak var radicalsTextField: UILabel! {
        didSet {
            radicalsTextField.text = "Selected Radical Code: \(FCCode!)"
        }
    }
    
    
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
        }
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
            println("Inside")
            labelSelectCounts[labelIndex]++
            return true
        }
        return false
    }
    
    func selectLabel(labelIndex: Int)->Void {
        if(labelSelectCounts[labelIndex] > labelSelectThreshold)
        {
            labels[labelIndex].backgroundColor = UIColor.greenColor()
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
            // do nothing
        }
        
    }

    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Identifiers.possibleRadicalsSegue {
            if let moreDetailVC = segue.destinationViewController as? UIViewController {
                if let navVC = parentViewController as? UINavigationController {
                    
                    let numControllersOnStack = navVC.viewControllers.count
                    
                    if let tableVC = navVC.viewControllers[numControllersOnStack - 2] as? IndexTableViewController {
                        tableVC.mostRecentMoreInfo = identifier
                        moreDetailVC.title = "Possible Radicals"
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
