//
//  SearchRadicalsViewController.swift
//  HanZiBreaker
//
//  The searching process happens here. Use the arguments passed in to look up the radicals.
//  Let the user select the final radical and then use the radical character as the search key to search in parse.com and retriee the link
//  Display a website with the link in an UIWeb view in next page
//
//  Created by HePeng on 8/2/15.
//  Copyright (c) 2015 HePeng. All rights reserved.
//

import UIKit

struct RadicalProperties {
    static let WikiID = 0
    static let pinyin = 1
    static let character = 2
    static let URL = 3
}

class SearchRadicalsViewController: UIViewController {

    var radicalCode: String? {
        didSet {
            println(self.radicalCode)
        }
    }
    
    var radicalFCCodeList: NSDictionary! = nil
    
    var radicalWebsites: NSDictionary! = nil
    
    var possibleRadicals: NSArray?

    var userSelectedRadical: String? = "口"    /* @@HP: for test, code code here */
    
    var selectedRadicalInfo: NSArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchRadical()
        displayChoices()
        searchWebsite()
      }


    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        radicalFCCodeList = NSDictionary(contentsOfURL: NSBundle.mainBundle().URLForResource("radical FC code list", withExtension: "plist")!)
        radicalWebsites = NSDictionary(contentsOfURL: NSBundle.mainBundle().URLForResource("radical websites", withExtension: "plist")!)
    }

    func searchRadical() {
        if let code = radicalCode {
            possibleRadicals = radicalFCCodeList[code] as? NSArray
        }
        else {
            println("radical code \(radicalCode) is not in the diactionary")
        }
        
    }

    func displayChoices() {
        if let choices = possibleRadicals {
            for item in choices {
                println(item)
            }
        }
        else {
            println("no radicals is selected")
        }
     
    }
    
    /* @@HP: suppose the user will always select the correct radical */
    func searchWebsite() {
        if let choice = userSelectedRadical {
            selectedRadicalInfo = radicalWebsites[choice] as? NSArray
        }
        else {
            println("the user did not select radical of choice(s)")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier ?? "MISSING" {
        case Identifiers.radicalMeaningsSegue:
            // figure out which row of the table we're transitioning from
            
                // now need to look up the RadicalsViewController instance
                if let resultVC = segue.destinationViewController as? ResultsViewController {

                    if let radicalInfo = selectedRadicalInfo {
                        resultVC.title = "Result of \(radicalInfo[RadicalProperties.character])"
//                        resultVC.identifier = radicalInfo[RadicalProperties.character]
                        resultVC.websiteURL = radicalInfo[RadicalProperties.URL] as? String
                    }
                    else{
                        println("selected radical info not found")
                    }

                }
                else {
                    assertionFailure("destination of segue was not a ResultsViewController!")
                }

        default:
            assertionFailure("unknown segue ID \(segue.identifier)")
        }
    }

    
}
