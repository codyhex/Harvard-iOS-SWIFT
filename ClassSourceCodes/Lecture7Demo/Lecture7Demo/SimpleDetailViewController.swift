//
//  SimpleDetailViewController.swift
//  Lecture7Demo
//
//  Created by Daniel Bromberg on 7/13/15.
//  Copyright (c) 2015 S65. All rights reserved.
//

import UIKit

class SimpleDetailViewController: UIViewController, UIScrollViewDelegate {
    // prepareForSegue, where this field is set up, is very early in the
    // destination view controller's lifecycle, before the outlets below are set up
    var imageName: String? {
        didSet {
            if let imgName = imageName {
                image = UIImage(named: imgName)
            }
        }
    }
    var image: UIImage?
    var imageView = UIImageView()
    
    @IBOutlet weak var imageScrollView: UIScrollView! {
        didSet {
            Util.log("enter")
            imageScrollView.delegate = self
            if let img = image {
                imageView.image = img
                imageView.sizeToFit() // size to contain my children exactly
                imageScrollView.minimumZoomScale = 0.2
                imageScrollView.maximumZoomScale = 5.0
                imageScrollView.addSubview(imageView)
                imageScrollView.contentSize = imageView.frame.size // layout for a scrollview
                // if the image's frame is smaller than the imageScrollView's frame,
                // default is top-left alignment, and blank space otherwise
            }
        }
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
