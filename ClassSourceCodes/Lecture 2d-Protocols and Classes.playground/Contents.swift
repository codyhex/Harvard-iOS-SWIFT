//: The Fibonacci sequence is a rite of passage in any new language. These classical functions are one of the few places we'll allow short variable names

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
fib(1)
// fib(18) // Forget it. Watch the wheel go around and around.

//: Let's use TUPLES to do some performance tracking

//: We will return as the second value the NUMBER of times fib has been called recursively
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

//: That's terrible. As we know this way of calculating Fib is horribly inefficient. Let's do some memo-izing and practice using a dictionary
var memoized = [Int: Int]() // Why can this not be a `let`?
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

memoizedCountingFib(15)

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
memoizedCountingFib(10, withCombiner: { ($0 * 2) + $1 })


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

//: But we can do better than that syntactically
let smallest = arr.reduce(Int.max) { min($0, $1) }
smallest


//: Introducing protocols, and the subscript operator, predefined to be []
protocol IntCache: class { // Must ensure it's a reference type so can assign into it; subtle!!
    subscript(index: Int) -> Int? { get set }
}

//: And time to get into structs and classes
struct AgedEntry { let age: Int; let value: Int }

class LimitedIntCache: IntCache, Printable {
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
            return Array(cache.keys).reduce("") { $0 + " f(\($1)) = \(self.cache[$1]!.value);" }
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

"\(storage)"
