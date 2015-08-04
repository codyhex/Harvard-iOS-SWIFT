//
//  RadicalsViewController.swift
//  HanZiBreaker
//
//  Created by HePeng on 7/31/15.
//  Copyright (c) 2015 HePeng. All rights reserved.
//

import UIKit

let LINKED_CHAR: Character = "-"
struct CornerIndexs {
    static let A = 0
    static let B = 1
    static let C = 2
    static let D = 3
    static let E = 4
}

class RadicalsViewController: UIViewController {
    // The parent has the responsibility of setting up the data model of the child, so the child can render itself properly
    var identifier: String? // The "model"
    var chineseName: String?
    var FCCode: String?
    var encoder: Array<Character> = Array(count: 5, repeatedValue: "-")
    
    var cornerAWasTapped = false, cornerBWasTapped = false, cornerCWasTapped = false, cornerDWasTapped = false
    
    var radicalCode = "" /* @@HP: FCcode is actually five digits */
    
    @IBOutlet weak var radicalsTextField: UILabel! {
        didSet {
            radicalsTextField.text = "Selected Radical Code: \(String(encoder))"
        }
    }
    
    @IBOutlet weak var buttonAField: UIButton!
    @IBOutlet weak var buttonBField: UIButton!
    @IBOutlet weak var buttonCField: UIButton!
    @IBOutlet weak var buttonDField: UIButton!

    
    @IBAction func cornerAwasTapped(sender: UIButton) {
        /* @@HP: animate the tapped region, onece tapped again, flip the value */
        if cornerAWasTapped == false {
            cornerAWasTapped = true
            /* @@HP: highlight the background once the button was tapped down and used as vaild */
            buttonAField.backgroundColor = UIColor(red: 0.4, green: 1.0, blue: 0.2, alpha: 0.5)

            if let code = FCCode {
                    encoder[CornerIndexs.A] = code[code.startIndex]
                }
        }
        else {
            cornerAWasTapped = false
            encoder[CornerIndexs.A] = LINKED_CHAR
        }
        
        radicalsTextField.text = "Selected Radical Code: \(String(encoder))"
    }
    
    @IBAction func cornerBwasTapped(sender: UIButton) {
        /* @@HP: animate the tapped region, onece tapped again, flip the value */
        if cornerBWasTapped == false {
            cornerBWasTapped = true
            buttonBField.backgroundColor = UIColor(red: 0.4, green: 1.0, blue: 0.2, alpha: 0.5)

            if let code = FCCode {
                encoder[CornerIndexs.B] = code[advance(code.startIndex, CornerIndexs.B)]
            }

        }
        else {
            cornerBWasTapped = false
            encoder[CornerIndexs.B] = LINKED_CHAR
        }
        
        radicalsTextField.text = "Selected Radical Code: \(String(encoder))"
    }
    
    @IBAction func cornerCWasTapped(sender: UIButton) {
        /* @@HP: animate the tapped region, onece tapped again, flip the value */
        if cornerCWasTapped == false {
            cornerCWasTapped = true
            buttonCField.backgroundColor = UIColor(red: 0.4, green: 1.0, blue: 0.2, alpha: 0.5)

            if let code = FCCode {
                encoder[CornerIndexs.C] = code[advance(code.startIndex, CornerIndexs.C)]
            }
        }
        else {
            cornerCWasTapped = false
            encoder[CornerIndexs.C] = LINKED_CHAR
        }
        
        radicalsTextField.text = "Selected Radical Code: \(String(encoder))"
    }
    
    @IBAction func cornerDWasTapped(sender: UIButton) {
        /* @@HP: animate the tapped region, onece tapped again, flip the value */
        if cornerDWasTapped == false {
            cornerDWasTapped = true
            buttonDField.backgroundColor = UIColor(red: 0.4, green: 1.0, blue: 0.2, alpha: 0.5)

            if let code = FCCode {
                encoder[CornerIndexs.D] = code[advance(code.startIndex, CornerIndexs.D)]
            }
        }
        else {
            cornerDWasTapped = false
            encoder[CornerIndexs.D] = LINKED_CHAR
        }
        
        radicalsTextField.text = "Selected Radical Code: \(String(encoder))"
    }
    
    func cleanCache() {
        cornerAWasTapped = false
        cornerBWasTapped = false
        cornerCWasTapped = false
        cornerDWasTapped = false
        
        encoder = Array<Character>(count: 5, repeatedValue: "-")
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Identifiers.possibleRadicalsSegue {
            if let searchRadicalsVC = segue.destinationViewController as? SearchRadicalsViewController {
                if let navVC = parentViewController as? UINavigationController {
                    let numControllersOnStack = navVC.viewControllers.count
                    if let tableVC = navVC.viewControllers[numControllersOnStack - 2] as? IndexTableViewController {
                        tableVC.mostRecentMoreInfo = identifier
                        searchRadicalsVC.title = "Radicals"
                        searchRadicalsVC.radicalCode = String(self.encoder)
                        cleanCache()
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
