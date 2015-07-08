//
//  ColoredSquareView.swift
//  MVCClassDemo
//
//  Created by Daniel Bromberg on 7/6/15.
//  Copyright (c) 2015 S65. All rights reserved.
//

import UIKit

class ColoredSquareView: UIView {
    // When this view is constructed, the model won't be ready yet; by having as optional, I can do it later, such as in viewDidLoad (the controller is responsible for wiring the model to the view)
    var dataSource: ColoredSquareModel?
    
    struct Messages {
        static let noModelFound = "Square View has no model!" as NSString
        static let font = UIFont.systemFontOfSize(24.0)
        static let color = UIColor.brownColor()
        static let fontAttributes = [NSFontAttributeName: font, NSForegroundColorAttributeName: color]
    }
    
    // Mapping function from the abstract mathematical idea of a located square with a color, to
    // something on an iOS device
    // This should be fast, not rely on outside sources that may delay like network
    // rect input parameter is for logical clipping
    override func drawRect(rect: CGRect) {
        if let model = dataSource {
            let squareBounds = CGRect(x: model[ModelKeys.xLoc]!, y: model[ModelKeys.yLoc]!,
                width: model[ModelKeys.sideLength]!, height: model[ModelKeys.sideLength]!)
            let rectPath = UIBezierPath(rect: squareBounds)
            let squareColor  = UIColor(hue: CGFloat(model[ModelKeys.hue]!),
                saturation: CGFloat(0.8), brightness: 1.0, alpha: 1.0)
            squareColor.set() // There's a "drawing context" that is prepared by iOS just before
            // drawRect is called, and set() automatically accesses this context and sets its color
            rectPath.fill()
        }
        else {
            Messages.noModelFound.drawAtPoint(CGPoint(x: 10, y: 10), withAttributes: Messages.fontAttributes)
        }
    }
}
