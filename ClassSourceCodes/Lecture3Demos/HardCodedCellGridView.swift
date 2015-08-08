//
//  HardCodedCellGridView.swift
//  Lecture3Demo
//
//  Created by Daniel Bromberg on 6/27/15.
//  Copyright (c) 2015 S65. All rights reserved.
//

import UIKit

// Demonstrates a minimal custom view, with drawing techniques, although there's no real
// model abstraction. It's all hardcoded
class HardCodedCellGridView: UIView {
    let gridSize = 25
    
    var cellDim: CGPoint {
        let smallerDim = min(frame.width, frame.height)
        return CGPoint(x: smallerDim / CGFloat(gridSize), y: smallerDim / CGFloat(gridSize))
    }
    
    func drawCell(#x: Int, y: Int) {
        let cellRect = CGRect(x: CGFloat(x) * cellDim.x, y: CGFloat(y) * cellDim.y, width: cellDim.x, height: cellDim.y)
        let cellPath = UIBezierPath(rect: cellRect)
        UIColor.blueColor().set() // Sets this color in the current drawing context
        cellPath.fill()
    }

    // drawRect is called for you whenever iOS decides view needs to be rendered
    override func drawRect(rect: CGRect) {
        drawCell(x: 5, y: 5)
        drawCell(x: 6, y: 6)
        drawCell(x: 6, y: 7)
        drawCell(x: 5, y: 7)
        drawCell(x: 4, y: 7)
        drawCell(x: 10, y: 10)
    }
}
