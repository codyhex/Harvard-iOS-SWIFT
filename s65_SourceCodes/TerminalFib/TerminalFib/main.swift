func getIntRangeFromTerminal(min: Int, max: Int) -> (Range<Int>) {
    let lower = Int.fromTerminal("the lower index of the Fibonacci range", min: min, max: max)
    let higher = Int.fromTerminal("the upper index of the Fibonacci range", min: lower + 1, max: max)
    
    return lower...higher
}

// For Fib, a small cache goes a long way. Think about why.
let storage = LimitedIntCache(maxSize: 10)

func fib(val: Int) -> (result: Int, calls: Int) {
    return countingFib(val, withStorage: storage)
}

// MARK: Main
for i in lazy(getIntRangeFromTerminal(1, 1000)).reverse() {
    let (ans, count) = fib(i)
    println("The \(i.cardinal()) Fibonacci number is \(ans.spacePad(10)) iterations: \(count.spacePad(8))")
}
