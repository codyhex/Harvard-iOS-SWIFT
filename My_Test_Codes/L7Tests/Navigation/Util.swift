//
//  Util.swift
//  Lecture7Demo
//
//  Created by Daniel Bromberg on 7/13/15.
//  Copyright (c) 2015 S65. All rights reserved.
//

import Foundation

public class Util {
    static var debug = true
    static var maxStack: Int?
    static let startStamp = NSDate().timeIntervalSince1970
    
    static public func log(message: String, sourceAbsolutePath: String = __FILE__, line: Int = __LINE__, function: String = __FUNCTION__) {
        if debug {
            if message == "exit" {
                // disable these by default; it gets too verbose unless we want to find slow functions
                return
            }
            
            // For the morbidly curious
            if let max = maxStack {
                var stackDump = NSThread.callStackSymbols()
                stackDump.removeRange(0...2)
                stackDump.removeRange(max...(stackDump.count - 1))
                println(stackDump.reduce("") { "\($0)\n\($1)" })
            }
            
            // let threadType = NSThread.currentThread().isMainThread ? "main" : "other"
            let baseName = NSURL(fileURLWithPath: sourceAbsolutePath)?.lastPathComponent?.stringByDeletingPathExtension ?? "UNKNOWN_FILE"
            var timeStampStr = NSString(format: "%5.5f", max(NSDate().timeIntervalSince1970 - startStamp, 0))
            println("\(timeStampStr) \(baseName) \(function)[\(line)]: \(message)")
        }
    }
}
