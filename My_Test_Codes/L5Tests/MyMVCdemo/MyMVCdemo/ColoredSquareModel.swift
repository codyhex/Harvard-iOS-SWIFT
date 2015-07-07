//
//  ColoredSquareModel.swift
//  MyMVCdemo
//
//  Created by Peng on 7/6/15.
//  Copyright (c) 2015 Peng. All rights reserved.
//

import Foundation

class ColoredSquareModel {
    var xLoc = 10.0 {
        didSet {
            println("my xLoc is change to \(xLoc)")
        }
    }// Doubles for zoom-in ability
    var yLoc = 30.0 {
        didSet {
            println("my yLoc is change to \(yLoc)")
        }
    }
    var hue = 0.0
    var sideLength = 50.0
    
}
