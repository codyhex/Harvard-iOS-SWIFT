//
//  ViewController.swift
//  Lecture 9 JustPersistence
//
//  Created by Daniel Bromberg on 7/20/15.
//  Copyright (c) 2015 S65. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let myObj = SuperSimpleSave()
        myObj.anotherVar = 328974
        Persistence.save(myObj)
        if let mySavedObj = Persistence.restore() as? SuperSimpleSave {
            println("success!!: \(mySavedObj.superSimpleSaveString) anotherVar: \(mySavedObj.anotherVar)")
        }
        else {
            println("failure!!")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

