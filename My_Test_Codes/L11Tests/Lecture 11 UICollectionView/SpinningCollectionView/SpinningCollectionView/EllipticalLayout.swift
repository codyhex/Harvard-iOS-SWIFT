//
//  EllipiticalLayout.swift
//  Section09
//
//  Created by Van Simmons on 3/25/15.
//  Copyright (c) 2015 ComputeCycles, LLC. All rights reserved.
//

import UIKit

class EllipticalLayout: UICollectionViewLayout {
    
    var deleteIndexPaths = [] as [NSIndexPath]
    var insertIndexPaths = [] as [NSIndexPath]
    
    var radius   :CGFloat = 0
    var cellCount:Int     = 0
    
    override func prepareLayout()
    {
        super.prepareLayout()
        
        var cv = self.collectionView!
        var size = cv.frame.size
        cellCount = self.collectionView!.numberOfItemsInSection(0)
        radius = min(size.width, size.height) / 2.5
    }
    
    override func collectionViewContentSize() -> CGSize
    {
        var retVal = CGSizeMake(self.collectionView!.frame.size.width*NUM_PANELS,
            self.collectionView!.frame.size.height)
        return retVal
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        var cv = collectionView!
        var t = (cv.contentOffset.x - cv.frame.size.width) / (cv.frame.size.width)
        var angle = t * CGFloat(M_PI)
        var attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        attributes.size = CGSizeMake(ITEM_SIZE, ITEM_SIZE)
        var hArcLength = cosf((2.0 * Float(indexPath.item) * Float(M_PI) / Float(cellCount)) + Float(angle))
        var cx = cv.contentOffset.x + radius * CGFloat(hArcLength) + cv.frame.width/2.0
        var vArcLength = 0.5*sinf((2.0 * Float(indexPath.item) * Float(M_PI) / Float(cellCount)) + Float(angle))
        var cy = cv.contentOffset.y + radius * CGFloat(vArcLength) + cv.frame.height/2.0
        attributes.center = CGPointMake(cx,cy)
        //        var zoom = t+1.3333333
        //        if zoom < 0.75 {
        //            zoom = 0.75
        //        }
        //        else if zoom > 1.25 {
        //            zoom = 1.25
        //        }
        //        var scaleTransform = CATransform3DMakeScale(zoom, zoom, 1.0)
        var rotateTransform = CATransform3DMakeRotation(-angle, 0.0, 0.0, 1.0)
        //        var concatTransform = CATransform3DConcat(scaleTransform, rotateTransform)
        attributes.transform3D = rotateTransform
        attributes.zIndex = 1
        attributes.alpha = 1.0
        return attributes
    }
    
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        var cv = self.collectionView!
        var visibleRect = CGRectMake(
            cv.contentOffset.x,
            cv.contentOffset.y,
            cv.bounds.size.width,
            cv.bounds.size.height)
        var attributes = [] as [UICollectionViewLayoutAttributes]
        for var i=0 ; i < self.cellCount; i++ {
            var indexPath = NSIndexPath(forItem: i, inSection: 0)
            attributes.append(self.layoutAttributesForItemAtIndexPath(indexPath))
        }
        return attributes
    }
    
    
    
    //    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint) -> CGPoint {
    //        var offsetAdjustment = CGFloat(MAXFLOAT)
    //        var horizontalCenter = proposedContentOffset.x + (CGRectGetWidth(self.collectionView!.bounds) / 2.0);
    //
    //        var targetRect = CGRectMake(proposedContentOffset.x, 0.0,
    //            self.collectionView!.bounds.size.width,
    //            self.collectionView!.bounds.size.height)
    //        var array = self.layoutAttributesForElementsInRect(targetRect)
    //
    //        if let els = super.layoutAttributesForElementsInRect(targetRect)
    //        {
    //            for el in els {
    //                var itemHorizontalCenter = el.center.x;
    //                if abs(itemHorizontalCenter - horizontalCenter) < abs(offsetAdjustment) {
    //                    offsetAdjustment = itemHorizontalCenter - horizontalCenter;
    //                }
    //            }
    //        }
    //        return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
    //    }
    //
    
    override func initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        var attributes = super.initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath)
        if contains(insertIndexPaths, itemIndexPath) {
            if attributes == nil {
                attributes = self.layoutAttributesForItemAtIndexPath(itemIndexPath)
            }
        }
        return attributes
    }
    
    
    override func finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        var cv = self.collectionView!
        var attributes = super.finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath)
        if contains(deleteIndexPaths, itemIndexPath) {
            if attributes == nil {
                attributes = self.layoutAttributesForItemAtIndexPath(itemIndexPath) as UICollectionViewLayoutAttributes
            }
            attributes!.alpha = 0.2
            var cx = cv.contentOffset.x + cv.frame.width/2.0
            var cy = cv.contentOffset.y + cv.frame.height/2.0
            attributes!.center = CGPointMake(cx, cy);
            //            attributes!.transform3D = CATransform3DMakeScale(0.1, 0.1, 1.0);
        }
        return attributes
        
    }
    
    override func prepareForCollectionViewUpdates(updateItems: [AnyObject]!) {
        super.prepareForCollectionViewUpdates(updateItems)
        for update in updateItems {
            if let u = update as? UICollectionViewUpdateItem {
                if u.updateAction == .Delete {
                    if let bip = u.indexPathBeforeUpdate  {
                        self.deleteIndexPaths.append(bip)
                    }
                }
                else if u.updateAction == .Insert {
                    if let aip = u.indexPathAfterUpdate {
                        self.insertIndexPaths.append(aip)
                    }
                }
            }
        }
    }
    
    override func finalizeCollectionViewUpdates() {
        self.deleteIndexPaths = [] as [NSIndexPath]
        self.insertIndexPaths = [] as [NSIndexPath]
    }
  
}
