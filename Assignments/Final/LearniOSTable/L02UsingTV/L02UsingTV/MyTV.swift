//
//  MyTV.swift
//  L02UsingTV
//
//  Created by plter on 6/25/14.
//  Copyright (c) 2014 eoe. All rights reserved.
//

import UIKit

class MyTV: UITableView ,UITableViewDataSource,UITableViewDelegate{
    
    
    let TAG_CELL_LABEL = 1
    let dataArr = ["Hello","jikexueyuan","ime"]
    
    var data:NSDictionary!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        data = NSDictionary(contentsOfURL: NSBundle.mainBundle().URLForResource("data", withExtension: "plist")!)
        
        self.dataSource = self
        self.delegate = self
    }

    init(frame: CGRect) {
        super.init(frame: frame)
        // Initialization code
    }
    
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return data.count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        
        var cell : AnyObject! = tableView.dequeueReusableCellWithIdentifier("cell")
        
        var label = cell.viewWithTag(TAG_CELL_LABEL) as UILabel
        label.text = (data.allValues[indexPath.section] as NSArray).objectAtIndex(indexPath.row) as String
        
        return cell as UITableViewCell
    }
    
    func tableView(tableView: UITableView!, titleForHeaderInSection section: Int) -> String!{
        return data.allKeys[section] as String
    }
    
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return (data.allValues[section] as NSArray).count
    }
    
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!){
        println("\((data.allValues[indexPath.section] as NSArray).objectAtIndex(indexPath.row)) Clicked")
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
        // Drawing code
    }
    */

}
