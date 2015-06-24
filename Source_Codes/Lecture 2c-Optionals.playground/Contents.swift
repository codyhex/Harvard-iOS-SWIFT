import Foundation

//: An Optional is a new type: a box around an existing type
//: The Box is empty or full, and has a status indicator you can check

//: Rationale: often a value cannot be computed in an exceptional case.
//: The convention in other languages is to allow an object to be a NULL or nil pointer
//: However, the compiler cannot provide support for invalid operations on null objects
//: How many times have you encountered a segmentation violation in C because you forgot to
//: check if a returned pointer was nil, or a NullPointerException in Java because an object reference
//: was nil?

//: In Swift we have this "boxing" mechanism to say "this might be nil, enforce an unwrap operation"
var optionalInt: Int?

//: Optionals *do not require initialization*. By syntactic sugar, they start out empty:
println("\(optionalInt)")

//: They also do not require extra work to store something in the box, again syntatic sugar:
optionalInt = 3

//: If you print out an Optional, its boxiness becomes clear:
println("\(optionalInt)")

// ! is the unwrapping operator, but will cause a crash if the box is empty. This is similar to
// the aforementioned crashes in other languages, but at least you know every '!' is dangerous
// and must be thought through carefully.
optionalInt! + 5

// But now:
optionalInt = nil

// OOPS -- note playground evaluation halts
// optionalInt! + 5

// This is much more common: the step-carefully unwrapping syntax.
if let unwrappedInt = optionalInt {
    println("\(unwrappedInt + 12)")
}
else {
    println("optionalInt has no value")
}

// Example:
func carefulSqrt(operand: Double) -> Double? {
    if operand >= 0 {
        return sqrt(operand)
    }
    else {
        return nil
    }
}

carefulSqrt(3)
carefulSqrt(-3)

// But if we also accept an Optional, we can chain inputs from previous outputs that may have failed
func betterSqrt(operand: Double?) -> Double? {
    if let oper = operand where oper >= 0 {
        return sqrt(oper) // Note that "FIX-It" isn't very bright: try "operand" here
    }
    else {
        return nil
    }
}

//: An error
// carefulSqrt(carefulSqrt(-3))

//: But this works:
betterSqrt(betterSqrt(-256))
betterSqrt(betterSqrt(256))


//: How are Optionals actually implemented? Enumerated types and generics
//: The `enum` is the box. It enumerates two possible states: full or empty

//: enums in Swift are rather elaborate and allow an *associated value* to be stored with the state

//: The associated value with the "empty" state is hard-coded to be 'nil'
//: The associated value with the "full" state is set when the Optional is assigned

//: The generic aspect allows the full part to be able to contain whatever preceeds the '?'
var s: String? // A box specialized to contain Strings
var i: Int? // A Box specialized to contain Ints
var ohNo: Int?? // A box specialzed to contain boxes that contain Ints

//: Very idiomatic use of Optionals: Dictionaries (a.k.a. Hash tables)
var myTable = [ "Austin": "Wedsnesday", "Van": "Tuesday", "Alex": "Thursday"]
//: Since a key *might* not be in a dictionary, the return type is always Optional:
var forcedS: String = myTable["Austin"]!
if let safeS = myTable["Austin"] {
    println("Austin has a section on \(safeS)")
}
myTable["Daniel"]

