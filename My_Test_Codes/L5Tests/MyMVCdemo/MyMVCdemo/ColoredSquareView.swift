//
//  ColoredSquareView.swift
//  MyMVCdemo
//
//  Created by Peng on 7/6/15.
//  Copyright (c) 2015 Peng. All rights reserved.
//

import UIKit

class ColoredSquareView: UIView {
    // when this view is constructed, the model may not be initilized yet, so optional type
    var dataSource: ColoredSquareModel?

    // Mapping function from the abstract mathematical idea of a located quare with a color, to something on an iOS device
    // this should be fast, not rely on outside sources that may delay like network.
    override func drawRect(rect: CGRect) {
        // Drawing code
        if let model = dataSource {
            let squareBounds = CGRect(x: model.xLoc, y: model.yLoc, width: model.sideLength, height: model.sideLength)
            let rectPath = UIBezierPath(rect:squareBounds)
            // the constructor requires a CGFloat, the swift auto convert them on 1.0
            // if you need like saturation: 0.8, you need case saturation:CGFloat(0.8)
            let squareColor = UIColor(hue: CGFloat(model.hue), saturation: 1.0, brightness: 1.0, alpha: 1.0)
            // this needs to be memorized
            squareColor.set()
            
            rectPath.fill()
            
        }
        else {
            println("No model when attempting to draw!")
        }
    }
    
}
