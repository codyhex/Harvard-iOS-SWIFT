//
//  ColoredSquareView.swift
//  MVCDemo
//
//  Created by Daniel Bromberg on 7/5/15.
//  Copyright (c) 2015 S65. All rights reserved.
//

import UIKit
import Foundation

class ColoredSquareView: UIView {
    struct Messages {
        static let noModelFound = "Square View has no model!" as NSString
        static let font = UIFont.systemFontOfSize(24.0)
        static let color = UIColor.brownColor()
        static let fontAttributes = [NSFontAttributeName: font, NSForegroundColorAttributeName: color]
    }
    // use a protocol
    var dataSource: ColoredSquareDataSource?
    
    override func drawRect(rect: CGRect) {
        if let model = dataSource {
            let squareBounds = CGRect(x: model[ModelKeys.xLoc]!, y: model[ModelKeys.yLoc]!, width: model[ModelKeys.sideLength]!, height: model[ModelKeys.sideLength]!)
            let squareColor = UIColor(hue: CGFloat(model[ModelKeys.hue]!), saturation: CGFloat(0.8), brightness: 1.0, alpha: 1.0)
            let rectPath = UIBezierPath(rect: squareBounds)
            squareColor.set()
            rectPath.fill()
        }
        else {
            Messages.noModelFound.drawAtPoint(CGPoint(x: 10, y: 10), withAttributes: Messages.fontAttributes)
        }
    }
}
