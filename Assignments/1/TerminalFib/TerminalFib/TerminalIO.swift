import Foundation // NS* foundation classes

private let stdio = NSFileHandle.fileHandleWithStandardInput() // These and all the other non-UI NS classes are applicable to Mac OS X Cocoa API too

private var debug = true


// Debugging on steroids to show how much information can automatically be grabbed. Note how smart 
// the default function values are: They specifically come from the CALLING function which is what we want.
public func log(message: String, file: String = __FILE__, line: Int = __LINE__, function: String = __FUNCTION__) {
    // Feels a bit C-like to embed #ifs but they're available to keep out debugging code in the final release,
    // for the performance obsessed.
    // Find this in Build Settings -> Swift Compiler -> Custom Flags -> Other Swift Flags -> Debug:
    // and set a value of "-D DEBUG"
#if DEBUG
    if debug {
        NSLog("\n\tthread: \(NSThread.currentThread())\n\tfile: \(file):\(line)\n\tfunc: \(function)\n\t\(message)")
    }
#endif
}


public func setDebug(newVal: Bool) {
#if DEBUG
    debug = newVal
#endif
}


public extension String {
    static func fromTerminal() -> String {
        // Strictly speaking, for the Cocoa-heads, stdio.availableData is operating on a data stream which MAY
        // be from a failable source such as the network. Hence it can technically generate an NSFileHandleException,
        // which can only be caught by Objective-C code. All this means is if you're writing very low-level code or
        // commercial-grade server code, Swift needs help from an Objective-C wrapper. We're not worried about the an Xcode
        // or Terminal as our stdio source; closing it terminates the whole program anyway.
        return NSString(data: stdio.availableData, encoding: NSUTF8StringEncoding) as! String
    }
    
    func trim() -> String {
        let empties = NSCharacterSet.whitespaceAndNewlineCharacterSet()
        return self.stringByTrimmingCharactersInSet(empties)
    }
}


// Really like this part of Swift. Fulfills a "don't you wish..." expressiveness that's lacking in other languages.
public extension Int {
    // 43.cardinal() -> "  43rd"
    func cardinal(padding: Int = 4) -> String {
        let suffix: String
        switch self % 10 {
        case 1: suffix = "st"
        case 2: suffix  = "nd"
        case 3: suffix = "rd"
        default: suffix = "th"
        }
        return "\(self.spacePad(padding))\(suffix)"
    }
    
    // 27.spacePad(6) -> "    27"; 3728.spacePad(6) -> "  3728" so it lines up
    func spacePad(spaces: Int) -> String {
        // For those acustomed to 'self' (aka 'this' in Java) referring to complex objects, in this case it's just an Int!
        return NSString(format: "%\(spaces)ld", self) as! String
    }
    
    
    // Enforces a return value [min..max], repeating given prompt each time
    static func fromTerminal(reason: String, min: Int = 0, max: Int = Int.max) -> Int {
        var userVal: Int? // why must this be an Optional?
        do {
            print("Enter an integer in [\(min), \(max)] for \(reason): ")
            fflush(__stdoutp) // ugly but Swift doesn't emphasize terminal
            userVal = String.fromTerminal().trim().toInt() // trim needed since whitespace disturbs int parsing
        } while userVal < min || userVal > max // Why don't we need a comparison to nil?
        return userVal! // Why are we confident about force-unwrapping?
    }
}
