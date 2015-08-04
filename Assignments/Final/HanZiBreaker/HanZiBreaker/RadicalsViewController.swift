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
    
    @IBOutlet weak var selectView: UIImageView!
    //for draw
    var swiped = false
    var lastPoint = CGPoint.zeroPoint
    var red: CGFloat = 1.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var brushWidth: CGFloat = 5.0
    var opacity: CGFloat = 1.0
    
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
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        // 6
        swiped = true
        if let touch = touches.first as? UITouch {
            let currentPoint = touch.locationInView(selectView)
            drawLineFrom(lastPoint, toPoint: currentPoint)
            
            // 7
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        if !swiped {
            // draw a single point
            drawLineFrom(lastPoint, toPoint: lastPoint)
        }
        
        // Merge tempImageView into mainImageView
        //UIGraphicsBeginImageContext(selectView.frame.size)
        //selectView.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: kCGBlendModeNormal, alpha: 1.0)
        //selectView.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: kCGBlendModeNormal, alpha: opacity)
        //selectView.image = UIGraphicsGetImageFromCurrentImageContext()
        //UIGraphicsEndImageContext()
        
       // tempImageView.image = nil
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
