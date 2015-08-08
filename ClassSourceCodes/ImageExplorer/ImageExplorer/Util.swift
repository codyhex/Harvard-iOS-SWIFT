import Foundation
import UIKit

extension UIViewController {
    func notifyUser(title: String, message: String) {
        let alertBox = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alertBox.addAction(UIAlertAction(title: "Oy!", style: .Default, handler: nil))
        // Study & absorb the difference between a ViewController, which is "active" and must be presented as a
        // layer, VERSUS a UIView, which is just a hierchical building block of a single VC
        self.presentViewController(alertBox, animated: true, completion: nil)
    }
}

extension NSDictionary {
    // A custom description
    var keyValsAsString: String {
        var result = ""
        for (key, val) in self { // val is already unwrapped, which is quite sensible
            result += "\(key): \(val)"
        }
        return result
    }
}


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
    
    static public func keyValsAsString<KeyType, ValueType where KeyType: Equatable, ValueType: Hashable>(dict: [KeyType: ValueType]?) -> String? {
        if let d = dict {
            // reduce requires an array, not a dictionary unfortuantely, so we must make an Array out of the keys: Array(d.keys)
            // we start building the string with the empty string ""
            // $0 is the "result-so-far" (the string being built up)
            // $1 is the current key in the iteration
            // d[$1]! is the looked-up, unwrapped value for that key (safe to unwrap)
            return Array(d.keys).reduce("") { "\($0) \($1): \(d[$1]!)" }
        }
        else {
            return nil
        }
    }
}