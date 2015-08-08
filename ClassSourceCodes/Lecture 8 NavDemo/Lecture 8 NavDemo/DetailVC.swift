//
//  DetailVC.swift
//  Lecture 8 NavDemo
//
//  Created by Daniel Bromberg on 7/15/15.
//  Copyright (c) 2015 S65. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    // The parent has the responsibility of setting up the data model of the child, so the child can render itself properly
    var identifier: String? // The "model"
    
    @IBOutlet weak var myLabel: UILabel! {
        didSet {
            myLabel.text = identifier
        }
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Identifiers.moreDetailSegue {
            if let moreDetailVC = segue.destinationViewController as? UIViewController {
                if let navVC = parentViewController as? UINavigationController {
                    let numControllersOnStack = navVC.viewControllers.count
                    if let tableVC = navVC.viewControllers[numControllersOnStack - 2] as? TableVC {
                        tableVC.mostRecentMoreInfo = identifier
                        moreDetailVC.title = "More info about \(identifier)"
                    }
                    else {
                        assertionFailure("Failed to find a tableVC")
                    }
                }
                else {
                    assertionFailure("failed to find tne parent navigation VC")
                }
            }
            else {
                assertionFailure("failed to find a destination VC to the segue")
            }
        }
        else {
            assertionFailure("unknown segue \(segue.identifier)")
        }
    }
}
