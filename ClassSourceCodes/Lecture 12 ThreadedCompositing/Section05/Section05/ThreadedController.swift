//
//  ThreadedController.swift
//  Section05
//
//  Created by Van Simmons on 7/29/15.
//  Copyright (c) 2015 ComputeCycles, LLC. All rights reserved.
//

import Foundation
import UIKit

class ThreadedController: CompositingViewController, UITableViewDataSource, UITableViewDelegate {

    var placeHolder:UIImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.compositorNib.instantiateWithOwner(self, options: nil)
        var newCell = self.cellImageView!
        var newLabel = self.cellLabel!
        newLabel.text = "Compositing..."
        placeHolder = newCell.compositedImage()!
    }

    override func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("ImageCell", forIndexPath: indexPath) as! UITableViewCell
            cell.selectionStyle = .Default
            cell.textLabel!.backgroundColor = UIColor.clearColor()
            cell.tag = indexPath.row
            cell.imageView!.image = placeHolder
            
            let tag = cell.tag
            self.compositorNib.instantiateWithOwner(self, options: nil)
            var newCell = self.cellImageView!
            var newLabel = self.cellLabel!
            
            var op = QueueOperation { () -> Void in
                autoreleasepool {
                    let row = indexPath.row % 10
                    if cell.tag == tag {
                        var iv = UIImageView(frame: cell.imageView!.frame)
                        newCell.image = self.images[row]
                        newLabel.text! = "\(Image.all()[row].rawValue), Row: \(indexPath.row)"
                        let i = newCell.compositedImage()
                        
                        dispatch_async(dispatch_get_main_queue()) { () -> Void in
                            if cell.tag == tag {
                                cell.imageView!.image = i
                            }
                        }
                    }
                }
            }
            var ad = UIApplication.sharedApplication().delegate as! AppDelegate
            ad.threadPipeQueue.enqueueObject(op)
            
            return cell
    }
}
