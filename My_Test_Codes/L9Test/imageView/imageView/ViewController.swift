//
//  ViewController.swift
//  imageView
//
//  Created by Peng on 7/20/15.
//  Copyright (c) 2015 Peng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let urlString = "http://c.hiphotos.baidu.com/image/w%3D400/sign=53646e5d57fbb2fb342b59127f4b2043/3bf33a87e950352accd643085143fbf2b2118b7e.jpg"
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    
    func errorAlert(message: String){
        let userAlert = UIAlertView(title: "Network Error", message: message, delegate: nil, cancelButtonTitle: "oh, well")
        userAlert.show()
        errorLabel.text = " no Image"
    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib.
//    }

    func urlArrivedCallback(response: NSURLResponse!, fetchedData: NSData, error: NSError!) -> Void{
        assert(NSThread.isMainThread())
        let httpResponse = response as! NSHTTPURLResponse
        
        if error != nil {
            errorAlert("Http request failed \(error.localizedDescription)")
        }
        
        else if httpResponse.statusCode != 200 {
            errorAlert("Http Error \(httpResponse.statusCode)")
        }
        else if let image = UIImage(data: fetchedData) {
            errorLabel.text = ""
            mainImageView.image = image
        }
        else {
            errorAlert("bad image")
        }
        activityIndicator.stopAnimating()
        
        return
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if mainImageView.image != nil {
            return
        }
        
        if let url = NSURL(string: urlString) {
            activityIndicator.startAnimating()
            let request = NSURLRequest(URL: url)
            /* @HP: Asynchronous is important very improtant for a  network event */
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: urlArrivedCallback)

        }
    }
}

