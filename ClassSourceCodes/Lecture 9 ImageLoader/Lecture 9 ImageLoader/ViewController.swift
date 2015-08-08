//
//  ViewController.swift
//  Lecture 9 ImageLoader
//
//  Created by Daniel Bromberg on 7/20/15.
//  Copyright (c) 2015 S65. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let urlString = "http://beachgrooves.com/wp-content/uploads/2014/07/beach.jpg"
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mainImageView: UIImageView!

    func errorAlert(message: String) {
        let userAlert = UIAlertView(title: "Network Error", message: message, delegate: nil, cancelButtonTitle: "Oh, well")
        userAlert.show()
        // modal means iOS captures all input until button is tapped and alert is dismissed
        errorLabel.text = "<No Image>"
    }
    
    // Closure gets called AFTER retrieval process is done, happens on the 
    // queue referenced below. So again we must be quick; we're on the UI thread.
    func urlArrivedCallback(response: NSURLResponse!, fetchedData: NSData!, error: NSError!) {
        assert(NSThread.isMainThread())
        if error != nil { // Always check first, otherwise can't unwrap the data
            errorAlert("HTTP request failed: \(error.localizedDescription)")
            return
        }
        
        let httpResponse = response as! NSHTTPURLResponse
        // if error is nil, at least can parse the response
        if httpResponse.statusCode != 200 {
            errorAlert("HTTP Error \(httpResponse.statusCode)")
        }
        else if let image = UIImage(data: fetchedData) {
            errorLabel.text = ""
            mainImageView.image = image
        }
        else {
            errorAlert("Bad image format")
        }
        activityIndicator.stopAnimating() // auto-hides
    }
    
    // Generally, delay network requests until necessary due to use of bandwidth and battery power
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // first filter out unnecessary loads: don't load if already present: for example if something was 
        // popped off the navigation stack, revealing this one. It had already loaded earlier.
        if mainImageView.image != nil {
            return
        }
        
        //Syntax checking in NSURL constructor is very rudimentary
        if let url = NSURL(string: urlString) {
            activityIndicator.startAnimating()
            let request = NSURLRequest(URL: url)
            // Not synchronous! If your methods don't return quickly, the UI freezes
            // completely
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: urlArrivedCallback)
        }
    }


}

