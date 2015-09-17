import Foundation // required for sqrt, which is not part of Swift proper

postfix operator ▢{}
    
postfix func ▢(x: Double) -> Double {
    return x * x
}

//: Parameters are quite rich in Swift. There's lots of ways to do things.

//: Recall the external / internal name syntax. The convention is to not label the first parameter, but imply it from the function name.

//: Most iOS APIs work this way.
func concatenateString(first: String, withString second: String) -> String {
    return first + second
}
concatenateString("a", withString: "bcd")


//: Sometimes it makes sense to have internal & external names be the same, esp. math, where convetions well established
//: In this case use a '#'
func magnitudeFromComponents(#x: Double, #y: Double) -> Double {
    return sqrt(x▢ + y▢)
}

magnitudeFromComponents(x: 3, y: 4)


//: Sometimes external names don't add any information
//: (Although in this case an array makes more sense and is more general)
func addListOfInts(first: Int, second: Int, third: Int) -> Int {
    return first + second + third
}

addListOfInts(5, -1, 9)

//: With default values, you can leave them out even if they occur in the middle
func quoteLine(line: String, withQuoteChar qc: Character = ">", lineTerminator lc: String) -> String {
    return "\(qc) \(line)\(lc)"
}

print(quoteLine("I agree", withQuoteChar: "*",lineTerminator: "\n\n"))
