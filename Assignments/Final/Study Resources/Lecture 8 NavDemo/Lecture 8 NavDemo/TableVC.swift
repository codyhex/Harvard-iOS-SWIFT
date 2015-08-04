//
//  TableVC.swift
//  Lecture 8 NavDemo
//
//  Created by Daniel Bromberg on 7/15/15.
//  Copyright (c) 2015 S65. All rights reserved.
//

import UIKit

struct Identifiers {
    static let moreDetailSegue = "more info segue"
    static let basicSegue = "basic detail segue"
    static let basicCell = "basic table cell"
    static let tableSize = 20
}

class MyModel {
    var myItems: [ String ] = [String]()
    
    // in prepareForSegue you might see:
    // detailVC.identifier = myModelInstance.myItems[indexPath.row]
}

class TableVC: UITableViewController {
    var mostRecentMoreInfo: String? {
        didSet {
            // Whenever the model changes AFTER the first time the view is shown on
            // screen, you must do this
            // setNeedsDisplay() does not do it
            tableView.reloadData()
        }
    }
    
    func makeSubviewName(indexPath: NSIndexPath) -> String {
        return "subview #\(indexPath.row + 1)"
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Identifiers.tableSize
    }

    // prepareCellForRendering
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Identifiers.basicCell, forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel!.text = makeSubviewName(indexPath)
        if cell.textLabel!.text == mostRecentMoreInfo {
            cell.textLabel!.text! += "(user got more)"
        }
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return false
    }

    // MARK: - Navigation
    // Segue: Transition from one full-screen view to another where user is "diving deeper"
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier ?? "MISSING" {
        case Identifiers.basicSegue:
            // figure out which row of the table we're transitioning from
            
            // tableView property is initialized by TableViewController and knows
            // where the user just tapped.
            if let indexPath = tableView.indexPathForSelectedRow() {
                // now need to look up the DetailVC instance
                if let detailVC = segue.destinationViewController as? DetailVC {
                    // finally we have the handle on the view we need to prepare
                    // and we have a handle on the data from "indexPath"
                    // This is the big moment that connects the data from parent to child
                    detailVC.title = "Title of \(makeSubviewName(indexPath))"
                    detailVC.identifier = makeSubviewName(indexPath)
                    //...in a realistic scenario, the right side is a lookup, based on
                    // the indexPath's section & row, into a substantial data model
                    
                    //... and the left side may be a number of assignments because
                    // the detail view actually has a lot of detail
                }
                else {
                    assertionFailure("destination of segue was not a DetailVC!")
                }
            }
            else {
                assertionFailure("prepareForSegue called when no row selected")
            }
        default:
            assertionFailure("unknown segue ID \(segue.identifier)")
        }
    }
}
