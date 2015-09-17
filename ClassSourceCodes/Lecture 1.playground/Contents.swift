/*:
## CSCI S-65: Mobile Applications using Swift and iOS
### Lecture 1 22 June 2015
### Harvard Summer School
#### Daniel Bromberg -- bromberg@fas.harvard.edu
*/

import UIKit

// In playground, unlike real projects, you can create any expression, and have it immediately evaluated
3 + 4 + 2
12 - 3 * (4 - 18)
var w: String
w = "world"
"Hello" + ", " + w

// Let's make some real statements now, and rely on type inteference
var anInferredInt = 3
var anInferredDouble = 0.1

// Swift is much stricter than other languages about combining types
// anInferredInt / anInferredDouble // Understand this error
Double(anInferredInt)/anInferredDouble

//: Let's dive right in to iOS (UIKit in particular) and just get a flavor.
let labelWidth = 120

//: Try to ignore any confusing jargon (you will learn the two capital conventions) and just focus on results
// Swift code is designed to be self-explanatory as much as possible, so method names strongly tend towards the verbose
let helloSwift = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: 30))
// 'let' means helloSwift can never be re-assigned
//helloSwift = UILabel() // Understand this error

helloSwift.text = "Hello, Swift!"
helloSwift.backgroundColor = UIColor.blueColor()
// First appearance of Optionals and force-unwrapping. For now just know that '!' is needed to get at underlying color object before
// computing with it
helloSwift.backgroundColor = helloSwift.backgroundColor!.colorWithAlphaComponent(0.5)
helloSwift.textColor = UIColor.yellowColor().colorWithAlphaComponent(1.0)
helloSwift.textAlignment = .Center
helloSwift.font = UIFont.boldSystemFontOfSize(24.0)
helloSwift.sizeToFit()
helloSwift.bounds
helloSwift.bounds = CGRect(x: 0, y: 0, width: CGFloat(helloSwift.bounds.width * 1.2), height: helloSwift.bounds.height)
helloSwift.superview

// These numbers are non-sensical but they are irrelevant until placed in a parent
helloSwift.frame

var littleSquare = UIView(frame: CGRect(x: 10, y: 10, width: 25, height: 15))
littleSquare.backgroundColor = UIColor.greenColor()
helloSwift.addSubview(littleSquare)
littleSquare.superview
littleSquare.superview == helloSwift
littleSquare.alpha = 0.5
littleSquare.opaque = false

helloSwift

var dot = UIView(frame: CGRect(x: 2, y: 2, width: 5, height: 5))
dot.backgroundColor = UIColor.redColor()

littleSquare.addSubview(dot)
helloSwift

// A syntax error will prevent compilation of earlier changes!
for offset in stride(from: 0, through: 120, by: 6) {
    littleSquare.frame = CGRect(x: offset, y: 10, width: 25, height: 15)
    //littleSquare.transform = CGAffineTransformMakeRotation(CGFloat(Double(offset) / 50.0))
    // Playground trick: include a value just to track changes. If it doesn't update, close and re-open it
    helloSwift
}

helloSwift
littleSquare.transform = CGAffineTransformMakeRotation(CGFloat(M_PI / 4))
helloSwift


//: Let's come down out of iOS and get back to basics. We need functions!
func square(x: Int) -> Int {
    return x * x
}

square(3)
square(12)

//: This is a slightly tongue-in-cheek example that shows you can use arbitrary unicode in all identifier names
postfix operator ⎕ { }

postfix func ⎕(x: Int) -> Int {
    return x * x
}


3⎕

var y = 5
// Let's find out why this variation doesnm't work
// y⎕⎕
(y⎕)⎕

if (y⎕)⎕ < 3126 {
    println("y to the 6th power is \(((y⎕)⎕)⎕)")
}


let a = [ 1, 2, 3, 4, 5, 6, 7 ] // What is the inferred type?
// Let's do it in two explicit steps (teaching purposes only: failing to use inference when it's possible will have points taken off)


let a1: [Int] = [Int]()
// a1.append(3) // Important to understand why this fails

// Let's dive into some functional programming style. Functional programming revolves around two principles:
// A. Calculating new values, rather than mutating existing values
// B. Using functions the same way all other types are used: passing as parameters, creating dynamically

// Demonstrates the 'map' Swift Standard library function, and BLOCKS
// BLOCKS are anonymous (unnamed) functions.  They also act as CLOSURES in that they capture and store values in their environment which would otherwise be temporary.
// They are often referred to as such, but we'll get to that much later

// Version 1:
let b1 = map(a, { (x: Int) in return x * x })

// Take advantage of implicit return: single-expression blocks implicitly return the value
let b2 = map(a, { (x: Int) in x * x })
b2

// Take advantage of automatic parameter naming
let b3 = map(a, { $0 * $0 })
b3

// Take advantage of block-as-last-param-can-go-after-close-paren syntax
let b4 = map(a) { $0 * $0 }
b4

// Take advantage of our new operator
let b5 = map(a) { $0⎕ }
b5

// Or we can use an already defined function, rather than declaring a new one inline
let b6 = map(a, ⎕)
let b7 = map(a, square)


// Parameter naming: note the "invisible" internal names, versus external names
func concatenateString(first: String, withString second: String) -> String {
    return first + second
}

// Try to read it like a sentence, starting with the function name and continuing with parameter namnes
// Like it or not, that's how the entire Swift / iOS API is built
concatenateString("a", withString: "bcd")

// Now let's demonstrate some operator overloading
postfix func ⎕(x: Double) -> Double {
    return x * x
}

// Sometimes it makes sense to have internal & external names be the same, esp. math where outside conventions override
func magnitudeByComponents(#x: Double, #y: Double) -> Double {
    return sqrt(x⎕ + y⎕)
}

magnitudeByComponents(x: 3, y: 4) // not magntitudeByComponents(3, 4) -- no more guesswork!

// If you insist on nameless parameters:
func addListOfInts(first: Int, second: Int, third: Int) -> Int {
    return first + second + third
}

addListOfInts(5, -1, 9)


// OPTIONALS
// A sentinel value embedded into the type, with simple syntax to unwrap when you need
var x: Int?

println("\(x)")

x = 3
println("\(x) \(x!)")

// Use in expressions:
x! + 5

// But now:
x = nil

// OOPS -- note playground evaluation halts
// x! + 5

if let okx = x {
    println("\(okx)")
}
else {
    println("no value")
}

// Example:
func optsqrt(operand: Double) -> Double? {
    if operand >= 0 {
        return sqrt(operand)
    }
    else {
        return nil
    }
}

optsqrt(-3)

// But wouldn't it be nice to be able to chain?
func betterSqrt(operand: Double?) -> Double? {
    if let oper = operand where oper >= 0 {
        return sqrt(oper) // Note that "FIX-It" isn't very bright: try "operand" here
    }
    else {
        return nil
    }
}

betterSqrt(betterSqrt(-3))
sqrt(3.0)

// Actually, Doubles/Floats are the only primitive types that has a built-in sentinel value for these situations: nan
let impossible = sqrt(-3.0)
// However it's a very confusing one, so stay clear unless you're a floating point geek. Bet a beer over this one!
if Double.NaN == Double.NaN { println("normally, you'd expect to see this.") } else { println("but, you don't") }
// You actually have to say
if impossible.isNaN { println("NaN NaN-na NaN nah!") }


var nCalls = 0
// Let's develop a more interesting example
// Fib is a rite of passage in any new language. These classical functions are one of the few places we'll allow short variable names
func fib(n: Int) -> Int {
    if n < 2 {
        return n
    }
    else {
        return fib(n - 1) + fib(n - 2)
    }
}
fib(3) // Fine
fib(7) // OK
// fib(18) // Forget it. Watch the wheel go around and around.

// Let's use TUPLES to do some performance tracking
// We will return as the second value the NUMBER of times fib has been called recursively
func countingFib(operand: Int) -> (result: Int, calls: Int) {
    if operand < 2 {
        return (result: operand, calls: 1)
    }
    else {
        let fib1 = countingFib(operand - 1)
        let fib2 = countingFib(operand - 2)
        return (result: fib1.result + fib2.result, calls: fib1.calls + fib2.calls + 1)
    }
}


let (c: Int, d: Int) = countingFib(15)
println("\(c) \(d)")

// That's terrible. As we know this way of calculating Fib is horribly inefficient. Let's do some memo-izing and practice using a dictionary
var memoized = [Int: Int]()
func memoizedCountingFib(operand: Int) -> (result: Int, calls: Int) {
    if operand < 2 {
        return (result: operand, calls: 1) // We won't bother to memoize the trivial case
    }
    else if let result = memoized[operand] {
        return (result: result, calls: 1)
    }
    else {
        let fib1 = memoizedCountingFib(operand - 1)
        let fib2 = memoizedCountingFib(operand - 2)
        memoized[operand] = fib1.result + fib2.result
        println("Memoizing \(operand)")
        return (result: memoized[operand]!, calls: fib1.calls + fib2.calls + 1) // WHy is this force-unwrapping safe?
    }
}

// memoizedCountingFib(10)

memoized.removeAll()
typealias IntCombiner = (Int, Int) -> Int
func memoizedCountingFib(operand: Int, withCombiner combine: IntCombiner) -> (result: Int, calls: Int) {
    if operand < 2 {
        return (result: operand, calls: 1) // We won't bother to memoize the trivial case
    }
    else if let result = memoized[operand] {
        return (result: result, calls: 1)
    }
    else {
        let fib1 = memoizedCountingFib(operand - 1, withCombiner: combine)
        let fib2 = memoizedCountingFib(operand - 2, withCombiner: combine)
        memoized[operand] = combine(fib1.result, fib2.result)
        println("Memoizing \(operand)")
        return (result: memoized[operand]!, calls: fib1.calls + fib2.calls + 1)
    }
}
memoizedCountingFib(10) { ($0 * 2) + $1 }


// This cache might get very large; let's limit it and program it WIHTOUT changing the syntax of its use as a fundamental type

// First some practice with array-combining fundamentals
let arr = [ 5, 3, 4, 5 ]

// The "C" way
var sum = 0
for var i = 0; i < arr.count; i++ {
    sum = sum + arr[i]
}
sum

// The Swift way
let swiftySum = arr.reduce(0, combine: { (runningSum: Int, currentVal: Int) -> Int in return runningSum + currentVal })

// Now a slightly less obvious example
let smallestVerbose = arr.reduce(Int.max) { (prevVal: Int, currentVal: Int) -> Int in
    if prevVal < currentVal {
        return prevVal
    }
    else {
        return currentVal
    }
}

// But we can do better than that syntactically
let smallest = arr.reduce(Int.max) { min($0, $1) }
smallest

protocol IntCache: class { // Must ensure it's a reference type so can assign into it; subtle!!
    subscript(index: Int) -> Int? { get set }
}

struct AgedEntry { let age: Int; let value: Int }

class LimitedIntCache: IntCache {
    let maxSize: Int
    var cache: [Int: AgedEntry]
    var currentEntryAge: Int
    
    init(maxSize: Int) {
        self.maxSize = maxSize
        currentEntryAge = 0
        cache = [Int: AgedEntry]()
    }
    
    func findIndexOfOldest() -> Int {
        // Limited context helper functions are perfectly fine to
        // declare within. This is still a *CLOSURE* Even though it's
        // not anonymous (a "block", or anonymous function, or "lambda
        // expression) In particular, it captures 'self' from its
        // context of the enclosing function, which is implicitly used
        // to access 'cache'
        func youngerOf(firstKey: Int, secondKey: Int) -> Int {
            if cache[firstKey]!.age < cache[secondKey]!.age {
                return firstKey
            }
            else {
                return secondKey
            }
        }
        
        let arrayOfKeys = Array(cache.keys)
        let smallestIndex = arrayOfKeys.reduce(arrayOfKeys[0], combine: youngerOf)
        
        return smallestIndex
        
        // EXERCISE: Rewrite this function as a one-liner using as much "syntactic sugar" as possible
    }
    
    subscript(index: Int) -> Int? {
        get {
            return cache[index]?.value // Chaining!
        }
        set {
            if let val = newValue {
                if cache.count == maxSize { // Uh-oh, it's full
                    let indexOfOldest = findIndexOfOldest()
                    println("Purged entry \(indexOfOldest)")
                    println("value was \(cache[indexOfOldest]!.value) age was \(cache[indexOfOldest]!.age)")
                    cache[indexOfOldest] = nil
                }
                cache[index] = AgedEntry(age: ++currentEntryAge, value: val)
            }
            // if 'nil' is being inserted, the size reduces by 1, but that's calculated by Swift internally
        }
    }
    
    // Good example of a computed property
    var description: String {
        get {
            return Array(cache.keys).reduce("") { $0 + " \($1): \(self.cache[$1]!.value))" }
        }
    }
}


func countingFib(operand: Int, withCombiner combine: IntCombiner, andStorage storage: IntCache) -> (result: Int, calls: Int) {
    if operand < 2 {
        return (result: operand, calls: 1) // We won't bother to memoize the trivial case
    }
    else if let result = storage[operand] {
        return (result: result, calls: 1)
    }
    else {
        let fib1 = countingFib(operand - 1, withCombiner: combine, andStorage: storage)
        let fib2 = countingFib(operand - 2, withCombiner: combine, andStorage: storage)
        storage[operand] = combine(fib1.result, fib2.result)
        println("Memoizing \(operand)")
        return (result: storage[operand]!, calls: fib1.calls + fib2.calls + 1)
    }
}

var storage = LimitedIntCache(maxSize: 20)
countingFib(25, withCombiner: { $0 + $1 }, andStorage: storage)

storage
3
println("foo")

// Now let's practice a little with closures
// Maybe we want to experiment with variations on the combining function


// Although Views are front and center to the user, they are largely behind the scenes in programming. Instead you mostly deal with Controllers.

// The contract is:

// Initialize static, BUILD-time information in Storyboard, e.g. font, initial content, constraint, view hierarchy

// Intialize dynamic, RUN-time views in code in the controller: specify where it goes, what its dimensions are

// Views ask for additional information as they need it, e.g. "What goes on row 2? What goes on row 3?"
// Views send user interactions to the controller as they happen, e.g. "user just tapped on me! User just zoomed into my upper right!"
// Controllers update attributes to respond to user interactions, e.g. "make your text say 'Message Sent'! Change your color to red!"
// Controllers dismiss the view in response to user navigation events (a sort of extreme form of update) or layer / replace / PRESENT a NEW view

// Sending user interactions from views to controllers happens via delegation which is defined via protocols


extension Int {
    func plus2Of() -> Int {
        return self + 2
    }
}

println("\(4.plus2Of())")


