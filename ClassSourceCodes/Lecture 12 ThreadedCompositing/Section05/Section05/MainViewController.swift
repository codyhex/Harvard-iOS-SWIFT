//
//  MainViewController.swift
//  Section05
//
//  Created by Van Simmons on 2/16/15.
//  Copyright (c) 2015 ComputeCycles, LLC. All rights reserved.
//

import Foundation
import UIKit

enum ExampleViews: Int {
    case Compositing
    case QueueingCompositing
    case GCDQueueingCompositing
    case ThreadedCompositing
}

class MainViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    override func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("MainCell", forIndexPath: indexPath) as! UITableViewCell
            cell.selectionStyle = .None
            cell.textLabel!.backgroundColor = UIColor.clearColor()
            let row = indexPath.row
            switch row {
            case ExampleViews.Compositing.rawValue:
                cell.textLabel!.text = "Compositing"
            case ExampleViews.QueueingCompositing.rawValue:
                cell.textLabel!.text = "QueueingCompositing"
            case ExampleViews.GCDQueueingCompositing.rawValue:
                cell.textLabel!.text = "GCDQueueingCompositing"
            case ExampleViews.ThreadedCompositing.rawValue:
                cell.textLabel!.text = "ThreadedCompositing"
            default:
                cell.textLabel!.text = "Unknown"
                cell.userInteractionEnabled = false
            }
            return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row
        switch row {
        case ExampleViews.Compositing.rawValue:
            self.performSegueWithIdentifier("Compositing", sender: tableView)
        case ExampleViews.QueueingCompositing.rawValue:
            self.performSegueWithIdentifier("QueueingCompositing", sender: tableView)
        case ExampleViews.GCDQueueingCompositing.rawValue:
            self.performSegueWithIdentifier("GCDQueueingCompositing", sender: tableView)
        case ExampleViews.ThreadedCompositing.rawValue:
            self.performSegueWithIdentifier("ThreadedCompositing", sender: tableView)
        default:
            NSLog("Selected default cell")
        }
        
    }

}
