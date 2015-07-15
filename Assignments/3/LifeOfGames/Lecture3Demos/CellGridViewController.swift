//
//  CellGridViewController.swift
//  Lecture3Demo
//
//  Created by Daniel Bromberg on 6/27/15.
//  Copyright (c) 2015 S65. All rights reserved.
//

import UIKit

class CellGridViewController: UIViewController {
    
    var model: CellGridDataSource!
    
    @IBOutlet weak var cellGridView: ModelBasedCellGridView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("CellGridViewController loaded")
        model = CellGridModel(size: 20)
        cellGridView.dataSource = model
    }
    
}