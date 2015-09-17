//
//  PetsTableViewController.swift
//  S65ParseDemo
//
//  Created by Sir Austin S. Lin on 7/29/15.
//  Copyright (c) 2015 Everyday Ventures LLC. All rights reserved.
//

import UIKit

class PetsTableViewController: UITableViewController {
  
  var pets = [PFObject]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    reloadDataFromParse()
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func reloadDataFromParse() {
    
    var query = PFQuery(className: "Pets")
    
    query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
      
      if let objs = objects as? [PFObject] {
        self.pets = objs
        self.tableView.reloadData()
      } else {
        UIAlertView(title: "Error", message: "Unable to retrieve data from Parse :(", delegate: nil, cancelButtonTitle: "OK")
      }
    }
  }
  
  @IBAction func refresh(sender: UIRefreshControl) {
    reloadDataFromParse()
    sender.endRefreshing() // this should be moved to the closure that's called above
  }
  // MARK: - Table view data source
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    // #warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete method implementation.
    // Return the number of rows in the section.
    return pets.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("Pet Cell", forIndexPath: indexPath) as! UITableViewCell
    
    // Configure the cell...
    
    cell.textLabel!.text = pets[indexPath.row]["name"] as? String
    cell.detailTextLabel!.text = pets[indexPath.row]["type"] as? String
    cell.imageView!.image = UIImage(data: NSData(contentsOfURL: NSURL(string: pets[indexPath.row]["url"] as! String)!)!)
    
    return cell
  }
  
  /*
  // Override to support conditional editing of the table view.
  override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
  // Return NO if you do not want the specified item to be editable.
  return true
  }
  */
  
  // Override to support editing the table view.
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
      // Delete the row from the data source
      
      //
      // ideally here you set up an observer that sees a local delete
      // and initiates a remote delete - Dan
      //
      pets[indexPath.row].deleteInBackground()   // delete from Parse
      pets.removeAtIndex(indexPath.row)          // remove from model
      
      // remove fro view
      tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
      // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
  }
  
  /*
  // Override to support rearranging the table view.
  override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
  
  }
  */
  
  /*
  // Override to support conditional rearranging of the table view.
  override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
  // Return NO if you do not want the item to be re-orderable.
  return true
  }
  */
  
  /*
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using [segue destinationViewController].
  // Pass the selected object to the new view controller.
  }
  */
  
}
