//
//  SimpleMasterController.swift
//  Lecture7Demo
//
//  Created by Daniel Bromberg on 7/13/15.
//  Copyright (c) 2015 S65. All rights reserved.
//

import UIKit

struct Identifiers {
    static let basicCell = "basic cell"
    static let detailSegue = "image detail segue"
}

class SimpleMasterController: DebugTableViewController, UISplitViewControllerDelegate
{
    var assetImages = [ "bill", "square", "game"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            // When you tap on a cell in a table view it gets selected (gray bg)
            clearsSelectionOnViewWillAppear = false
            preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let splitVC = splitViewController { // accesses our parent view controller
            splitVC.delegate = self
        }
        else {
            assertionFailure("Someone messed up the storyboard, need a splitVC")
        }
    }
    
    // Start off on the master view
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController!, ontoPrimaryViewController primaryViewController: UIViewController!) -> Bool {
        Util.log("enter")
        return true
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assetImages.count
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    // We have to build the cell based on the row number
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // We are always in the first and only section
        Util.log("enter, row \(indexPath.row)")
        let cell = tableView.dequeueReusableCellWithIdentifier(Identifiers.basicCell, forIndexPath: indexPath) as! UITableViewCell
        // Assume cell is full of old stale data from cells that have scrolled off 
        // screen and are candidates for re-use
        // Key linkage here: between UI and Model
        cell.textLabel!.text = assetImages[indexPath.row] // 0-based indices
        return cell
    }
    
    // Set up the detail view controller with everything it needs to do its job
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        Util.log("enter, identifier \(segue.identifier)")
        switch segue.identifier ?? "MISSING" {
        case Identifiers.detailSegue:
            if let indexPath = tableView.indexPathForSelectedRow(),
            let destVCNav = segue.destinationViewController as? UINavigationController,
                let detailVC = destVCNav.topViewController as? SimpleDetailViewController {
                    // look up name of image in underlying data model based on clicked-on row
                    let imageName = assetImages[indexPath.row]
                    detailVC.imageName = imageName
            }
        default:
            assertionFailure("unknown segue ID")
        }
    }
}
