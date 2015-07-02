import Foundation

"123".toInt()
" 123.".toInt()
"123 ".toInt()
"123a".toInt()
"123123412534512341234123".toInt()
"-1234123".toInt()


("234.1" as NSString).doubleValue
("234.junk" as NSString).doubleValue
(" abc junk" as NSString).doubleValue
("" as NSString).doubleValue

// Not very satisfying. Let's go to StackExchange:
// http://stackoverflow.com/questions/24031621/swift-how-to-convert-string-to-double

let numFormatter = NSNumberFormatter()
let numResult: NSNumber? = numFormatter.numberFromString("   -43612.12 ")
var myDouble: Double?
var myInt: Int?

if let unwrappedNum = numResult {
    myDouble = unwrappedNum.doubleValue
    myInt = unwrappedNum.integerValue
}

println("\(myDouble)")
println("\(myInt)")

extension String {
    // uses optional chaining to handle case of numberFromString returning
    // nil, in which case the 'doubleValue' access is canceled
    func toDouble() -> Double? {
        return NSNumberFormatter().numberFromString(self)?.doubleValue
    }
    
    func toIntFromDouble() -> Int? {
        return NSNumberFormatter().numberFromString(self)?.integerValue
    }
}

"234.52".toInt() // built in
"234.52".toIntFromDouble() // our new method
"234.12".toDouble() // our other new method
"234abc".toIntFromDouble()
"234abc".toDouble()

"123123412534512341234123".toInt()
"123123412534512341234123".toDouble()
"123123412534512341234123".toIntFromDouble() // interesting failure! Be careful of large values. What's being returned is Int.min
Int.min

// Shallow copies of structs: demonstrate

