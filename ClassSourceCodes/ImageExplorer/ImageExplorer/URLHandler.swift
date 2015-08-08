//
//  URLHandler.swift
//  ImageExplorer
//
//  Created by Daniel Bromberg on 5/12/15.
//  Copyright (c) 2015 S65. All rights reserved.
//

import Foundation

extension NSError {
    func keyValsAsString() -> String {
        if let errInfo = self.userInfo {
            return "Code \(self.code): " + Array(errInfo.keys).reduce("") { "\($0) \($1): \(errInfo[$1]!)" }
        }
        else {
            return "Code \(self.code) (no further info)"
        }
    }
}


class URLHandler {
    var session: NSURLSession = {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.timeoutIntervalForRequest = 15.0
        /* Now create our session which will allow us to create the tasks */
        let s = NSURLSession(configuration: configuration, delegate: nil, delegateQueue: nil)
        return s
        }()

    func httpRequest(url: NSURL, handler: (data: NSData?, message: String?) -> Void) {
        Util.log("requested url is \(url)")
        let task = session.dataTaskWithURL(url) {
            [unowned self]
            (var data: NSData?, response: NSURLResponse?, netError: NSError?) in
            let errmsg: String?
            
            if let statusCode = (response as? NSHTTPURLResponse)?.statusCode {
                Util.log("http responded, statusCode \(statusCode)")
                if statusCode == 200 {
                    errmsg = nil
                }
                else { // status code other than 200
                    errmsg = "HTTP Error \(statusCode): \(NSHTTPURLResponse.localizedStringForStatusCode(statusCode))"
                }
            }
            else { // No HTTP response available at all, couldn't hit server
                Util.log("http data did not arrive")
                var buildError: String
                if let netErr = netError {
                    buildError = "Network Error: \(netErr.localizedDescription)"
                    if let badURL = netErr.userInfo?["NSErrorFailingURLStringKey"] as? String {
                        buildError += " (Bad URL was '\(badURL)')"
                    }
                    errmsg = buildError // errmsg is a 'let' so it must be assigned once; we can't build it in-place
                }
                else {
                    errmsg = "OS Error: network report was empty for URL \(url)"
                }
            }
            Util.log("http req dispatching with error: " + (errmsg ?? "(No error)"))
            // It is OK for this to run slowly: we are off the main thread right now
            NSThread.sleepForTimeInterval(1.0) // EDUCATIONAL PURPOSES: Simulate slow network so we can watch the spinner

            // the handler that runs here must be FAST: always run in less than 0.25s
            // Oddity of API, perhaps Obj-C legacy, is that for network errors, data comes back as non-nil 0 length array
            dispatch_async(dispatch_get_main_queue()) { handler(data: errmsg == nil ? data : nil, message: errmsg) }
        }
        task.resume()
    }
}

