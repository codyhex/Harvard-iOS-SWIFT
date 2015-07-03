import Foundation

typealias IntCombiner = (Int, Int) -> Int

protocol IntCacheable: class 
{
    // Subtle Point. Must ensure that only a class can adopt the protocol, not a struct or enum,
    // so that the subscript "set" operation, i.e. a[foo] = bar, is allowed to mutate the object
    subscript(index: Int) -> Int? { get set }
}


// Let means that once set at init, cannot be changed. Dispose of entry if no longer needed
struct AgedEntry { 
    let age: Int
    let value: Int 
}


// Exercise: Implement a least-frequently used replacement strategy rather than least-recently-used
class LimitedIntCache: IntCacheable, Printable { // Printable causes the 'description' computed property below for String interpolations.
    // -able/ible is excellent convention for Protocols.
    // At a glance we are  adopting a protocol not extending a class
    
    // EXERCISE: What would happen if we left out IntCacheable? Left out Printable?
    let maxSize: Int
    var cache: [Int: AgedEntry]
    var currentEntryAge: Int
    
    // Constructor must initialize ALL members without an initial value
    
    // EXERCISE (easy): Move all but maxSize of init. Take advantage of type inference.]
    // Need a default parameter value for maxSize (which must be defined as a constant)
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
            return cache[index]?.value // Chaining
        }
        set {
            if let val = newValue {
                if cache.count == maxSize { // Uh-oh, it's full
                    let oldestIndex = findIndexOfOldest()
                    if let entry = cache[oldestIndex] {
                        log("Purged entry #\(oldestIndex) - Value was: \(entry.value), age was: \(entry.age).")
                        cache[oldestIndex] = nil
                    }
                }
                cache[index] = AgedEntry(age: ++currentEntryAge, value: val)
            }
            // if 'nil' is being inserted, the size reduces by 1, but that's calculated by Swift internally
        }
    }
    
    // Good example of a computed property
    var description: String {
        // EXERCISE: Sort the output by age, then by input key, pull it all together. Use sorted() standard library function
        
        // Note string interpolation is far more sophisticated than simple variable names
        return Array(cache.keys).reduce("") { "\($0): input: \($1): val: \(self.cache[$1]!.value) age: \(self.cache[$1]!.age)\n" }
    }
}


// We are now delegating the caching functionality to the class object that obeys the IntCacheable protocol
// Note the default parameter value is inlined code! (A closure block)
func countingFib(operand: Int, withStorage storage: IntCacheable, withCombiner combine: IntCombiner = { $0 + $1 } ) -> (result: Int, calls: Int) {
    if operand < 2 {
        return (result: operand, calls: 1) // We won't bother to memoize the trivial case
    }
    else if let result = storage[operand] { // Cache success
        return (result: result, calls: 1)
    }
    else { // Cache failure
        let fib1 = countingFib(operand - 1, withStorage: storage)
        let fib2 = countingFib(operand - 2, withStorage: storage)
        storage[operand] = combine(fib1.result, fib2.result) // Closure invocation
        log("Memoizing \(operand)")
        return (result: storage[operand]!, calls: fib1.calls + fib2.calls + 1)
    }
}
