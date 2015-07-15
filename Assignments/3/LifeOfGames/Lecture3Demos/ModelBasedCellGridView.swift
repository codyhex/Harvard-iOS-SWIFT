//
//  ModelBasedCellGridView.swift
//  Lecture3Demo
//
//  Created by Daniel Bromberg on 6/27/15.
//  Copyright (c) 2015 S65. All rights reserved.
//

import UIKit

class ModelBasedCellGridView: HardCodedCellGridView {
    /* @@HP: just in case the model not init */
    struct Messages {
        static let noModelFound = "Square View has no model!" as NSString
        static let font = UIFont.systemFontOfSize(24.0)
        static let color = UIColor.brownColor()
        static let fontAttributes = [NSFontAttributeName: font, NSForegroundColorAttributeName: color]
    }
    
    // Note the brevity allowed by explicit type and subsequent context
    let colors: [CellState: UIColor] = [ .Alive: .yellowColor(), .Born: .greenColor(), .Died: .brownColor(), .Empty: .grayColor() ]
    
    var dataSource: CellGridDataSource?

    
    override var cellDim: CGPoint {
        if let s = dataSource {
            
            let smallerDim = min(frame.width, frame.height)
            return CGPoint(x: smallerDim / CGFloat(s.getSize()), y: smallerDim / CGFloat(s.getSize()))
        }
        return CGPointZero
    }

//    override func drawRect(rect: CGRect) {
//        if let source = dataSource {
//            for x in 0..<source.size {
//                for y in 0..<source.size {
//                    let cellRect = CGRect(x: CGFloat(x) * cellDim.x, y: CGFloat(y) * cellDim.y, width: cellDim.x, height: cellDim.y)
//                    let cellPath = UIBezierPath(rect: cellRect)
//                    // For the sake of efficiency, we'll force-unwrap rather than doing a 'safe' check, and code carefully
//                    colors[source.getState((x: x, y: y))]!.set()
//                    cellPath.fill()
//                }
//            }
//        }
//    }
    
    override func drawRect(rect: CGRect) {
        if let source = dataSource {
            for x in 0..<source.getSize() {
                for y in 0..<source.getSize() {
                    let arcCenter   = CGPoint(x: CGFloat(x) * cellDim.x + CGFloat(cellDim.x / 2), y: CGFloat(y) * cellDim.y + CGFloat(cellDim.y / 2))
                    let radius  = CGFloat(cellDim.x / 2)
                    let cellPath : UIBezierPath = UIBezierPath(arcCenter: arcCenter, radius:
                        CGFloat(radius), startAngle: CGFloat(0), endAngle: CGFloat(M_PI*2), clockwise: true)
                    // For the sake of efficiency, we'll force-unwrap rather than doing a 'safe' check, and code carefully
                    colors[source.getState((x: x, y: y))]!.set()
                    cellPath.fill()
                }
            }
        }
        else {
            Messages.noModelFound.drawAtPoint(CGPoint(x: 10, y: 10), withAttributes: Messages.fontAttributes)
        }
    }
    
}
