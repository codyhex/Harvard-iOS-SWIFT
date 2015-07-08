//
//  ModelBasedCellGridView.swift
//  Lecture3Demo
//
//  Created by Daniel Bromberg on 6/27/15.
//  Copyright (c) 2015 S65. All rights reserved.
//

import UIKit

class ModelBasedCellGridView: HardCodedCellGridView {
    // Note the brevity allowed by explicit type and subsequent context
    let colors: [CellState: UIColor] = [ .Alive: .yellowColor(), .Born: .greenColor(), .Died: .brownColor(), .Empty: .grayColor() ]
    
    var dataSource: CellGridModel?

    override var cellDim: CGPoint {
        if let s = dataSource {
            let smallerDim = min(frame.width, frame.height)
            return CGPoint(x: smallerDim / CGFloat(s.size), y: smallerDim / CGFloat(s.size))
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
            for x in 0..<source.size {
                for y in 0..<source.size {
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
    }
}
