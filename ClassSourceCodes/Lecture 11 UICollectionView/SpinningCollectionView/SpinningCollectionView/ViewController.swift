//
//  ViewController.swift
//  Section09
//
//  Created by Van Simmons on 3/20/15.
//  Copyright (c) 2015 ComputeCycles, LLC. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController, UICollectionViewDataSource,
UICollectionViewDelegate, UIScrollViewDelegate {
    
    var cellCount:Int = 10
    var layoutStateIsCircular = true
    @IBOutlet var circularLayout:CircularLayout?
    @IBOutlet var ellipticalLayout:EllipticalLayout?

    var images: [UIImage] = [UIImage(named:"OnSpyPond.png")!,
        UIImage(named:"Library.png")!,
        UIImage(named:"Sept11Memorial.png")!,
        UIImage(named:"SnowTunnel.png")!,
        UIImage(named:"QuincyMarket.png")!]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cv = self.collectionView!
        let w = cv.frame.size.width
        let h = cv.frame.size.height
        cv.contentSize = CGSizeMake(w*NUM_PANELS, h)
        cv.contentOffset = CGPointMake(w, 0)
        
        var tapRecognizer = UITapGestureRecognizer(target: self, action: "handleTapGesture:")
        cv.addGestureRecognizer(tapRecognizer)

        var pinchRecognizer = UIPinchGestureRecognizer(target: self, action: "handlePinchGesture:")
        cv.addGestureRecognizer(pinchRecognizer)
    }
    
    @IBAction func handlePinchGesture(sender:UIPinchGestureRecognizer) {
        var layout: UICollectionViewLayout = self.circularLayout!
        if sender.scale < 1.0 {
            layout = self.ellipticalLayout!
        }
        
        let cv = self.collectionView!
        UIView.animateWithDuration(2.0, animations: { () -> Void in
                cv.performBatchUpdates({ () -> Void in
                    cv.setCollectionViewLayout(layout, animated: true)
                }, completion: { (success) -> Void in
                    
                })
            
            }, completion: { (success) -> Void in
            
        })
    }
    
    func handleTapGesture(sender:UITapGestureRecognizer) {
        let cv = self.collectionView!

        if sender.state == UIGestureRecognizerState.Ended {
            var tapPoint = sender.locationInView(cv)
            if let tappedCellPath = cv.indexPathForItemAtPoint(tapPoint) {
                var indexPaths = [tappedCellPath]
                self.cellCount = self.cellCount - 1
                cv.performBatchUpdates({ () -> Void in
                    cv.deleteItemsAtIndexPaths(indexPaths)
                    },
                    completion: { (success) -> Void in
                      NSLog("Received completion \(success) of batch updates")
                })
            }
            else {
                self.cellCount = self.cellCount + 1
                cv.performBatchUpdates({ () -> Void in
                    var loc = UInt32(self.cellCount)
                    var iLoc = Int(arc4random_uniform(loc))
                    var indexPath = NSIndexPath(forItem: iLoc, inSection: 0)
                    cv.insertItemsAtIndexPaths([indexPath])
                    },
                    completion: { (success) -> Void in
                        NSLog("Received completion \(success) of batch updates")
                })
            }
            NSLog("fnished handling")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
        return cellCount
    }
    
    override func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("ImageCell",
            forIndexPath: indexPath) as! CollectionViewCell
        
        let row = indexPath.row
        cell.imageView.image = images[row%5]

        return cell
    }
    
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        NSLog("ScrollViewDidEndDecelerating")
        let cv = self.collectionView!
        let w = cv.frame.size.width
        let h = cv.frame.size.height

        var newPoint = cv.contentOffset
        if(cv.contentOffset.x < w)
        {
            newPoint = CGPointMake(cv.contentOffset.x + w, cv.contentOffset.y)
        }
        else if cv.bounds.origin.x > (NUM_PANELS-1)*w {
            newPoint = CGPointMake(cv.contentOffset.x - w, cv.contentOffset.y)
        }
        if cv.contentOffset.x != newPoint.x {
            var rect:CGRect = CGRectMake(0, 0, 0, 0)
            rect.origin = newPoint
            rect.size = cv.frame.size

            cv.scrollRectToVisible(rect, animated: false)
        }
    }
}

