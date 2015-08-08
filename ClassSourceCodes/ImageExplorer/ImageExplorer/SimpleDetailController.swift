//
//  DetailViewController.swift
//  ImageExplorer
//
//  Created by Daniel Bromberg on 5/12/15.
//  Copyright (c) 2015 S65. All rights reserved.
//

import UIKit

class SimpleDetailController: DebugViewController, UIScrollViewDelegate {
    var aspectRatio: CGFloat?
    
    @IBOutlet weak var imageScroller: UIScrollView! { // ENHANCEMENT 3
        didSet {
            Util.log("enter")
            imageScroller.delegate = self
            if image != nil {
                imageScroller.minimumZoomScale = 0.1
                imageScroller.maximumZoomScale = 5.0
            }
            // This is ready because segue init happens before outlets connect
            imageScroller.addSubview(imageView)
            imageScroller.contentSize = imageView.frame.size
            
            Util.log("bounds: \(imageScroller.bounds) frame: \(imageScroller.frame) size: \(imageScroller.contentSize) content offset: \(imageScroller.contentOffset)")
        }
    }
    
    let imageView = UIImageView()
    let thumbnailView = UIImageView()
    let imageGuideView = UIView()

    var image: UIImage? {
        didSet {
            Util.log("enter setting image")
            if let img = image {
                imageView.image = img
                thumbnailView.image = img
            }
            else {
                imageView.image = UIImage(named: "not_found") // ENHANCEMENT 1
            }
            imageView.sizeToFit()
            aspectRatio = imageView.frame.height / imageView.frame.width
            // Below only applies if image is changed AFTER view is ready
            // NOTE: You can still prevent an implicit unwrap by putting in the '?'
            // image
            imageScroller?.contentSize = imageView.frame.size
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if image == nil {
            return
        }
        thumbnailView.alpha = CGFloat(0.75)
        thumbnailView.layer.borderColor = UIColor.yellowColor().CGColor
        thumbnailView.layer.borderWidth = 1.0
        view.addSubview(thumbnailView)
        
        thumbnailView.addSubview(imageGuideView)
        imageGuideView.layer.borderColor = UIColor.whiteColor().CGColor
        imageGuideView.layer.borderWidth = 1.0
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        thumbnailView.frame = CGRect(x: 0, y: 64,
            width: CGFloat(imageScroller.frame.width / 2.0),
            height: imageScroller.frame.width / 2.0 * aspectRatio!)
        updateThumbnail()
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        Util.log("enter")
        return imageView
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        updateThumbnail()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        updateThumbnail()
    }
    
    // ENHANCEMENT 4
    func updateThumbnail() {
        let horzOffsetRatio = imageScroller.contentOffset.x / imageScroller.contentSize.width
        let vertOffsetRatio = imageScroller.contentOffset.y / imageScroller.contentSize.height
        
        let thWidth = thumbnailView.frame.width
        let thHeight = thumbnailView.frame.height
        
        // Content size increases as we zoom in, don't need to account for it in calculation
        let widthContentRatio = imageScroller.frame.width / imageScroller.contentSize.width
        let heightContentRatio = imageScroller.frame.height / imageScroller.contentSize.height

        imageGuideView.frame = CGRect(x: thWidth * horzOffsetRatio, y: thHeight * vertOffsetRatio,
            width: thWidth * widthContentRatio, height: thHeight * heightContentRatio)
    }
}
