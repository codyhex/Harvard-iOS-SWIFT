//
//  ColoredSquareView.swift
//  MVCClassDemo
//
//  Created by Daniel Bromberg on 7/6/15.
//  Copyright (c) 2015 S65. All rights reserved.
//

import UIKit

class ColoredSquareView: UIView {
    struct Messages {
        static let noModelFound = "Square View has no model!" as NSString
        static let font = UIFont.systemFontOfSize(24.0)
        static let color = UIColor.brownColor()
        static let fontAttributes = [NSFontAttributeName: font, NSForegroundColorAttributeName: color]
    }
    
    /** UIBible: Views are passive. We wait for the dataSource to be initialized; we don't do it ourselves **/
    // Use a Protocol, not a concrete type, for delegates / dataSources
    var dataSource: ColoredSquareDataSource?
    
    /** UIBible: Views are passive. Rendering algorithm is below in drawRect **/
    // Mapping function from the abstract mathematical idea of a located square with a color, to
    // something on an iOS device
    // This should be fast, not rely on outside sources that may delay like network
    // rect input parameter is for logical clipping
    override func drawRect(rect: CGRect) {
        // STEP 9 of diagram: drawRect gets called by iOS after drawing context has been set up
        if let model = dataSource {
            // STEP 10 of diagram: Consult the model for the particulars
            /** UIBible: Same thing. "they must delegate to a model". **/
            // without bracket syntax: 
            // x: model.getParameterValue(forKey: ModelKeys.xLoc)
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
