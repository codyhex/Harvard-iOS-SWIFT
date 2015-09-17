//:### Lecture 3 Interactive session 06 29 2015 Daniel Bromberg CSCI S-65

//: Help with the map function:

// Arbitrary input data
let sillyArray = [ "One", "Seven", "Twelve" ]

// The verbose version of using 'map' on the above, using a multi-line closure
let transformedArray = map(sillyArray, {
    (input: String) -> String in
    let transformedString = "\(input)-\(input)-\(input)"
    return transformedString
})

// A variation that returns an Optional, just to show how that would work
let transformedArray2 = map(sillyArray, {
    (input: String) -> String? in
    if input != "One" {
        return "\(input)-\(input)-\(input)"
    }
    else {
        return nil
    }
})

// The super-concise version, but it must only contain a single expression
let transformedArray3 = map(sillyArray) {
    return "\($0)-\($0)-\($0)"
}

// The ultra-concise version, packing the super-concise version onto one line and
// leaving out the implied 'return'
let anotherArray = map(sillyArray) { "\($0)-\($0)-\($0)" }
// To see the value in Playground, we have to just re-state the value after the computation
anotherArray

// Another ultra-concise version that uses the Object-oriented syntax. Either syntax is fine.
let yetAnother = sillyArray.map { "\($0)-\($0)-\($0)" }
yetAnother


//: Some work with structs. 

// Contains some write-once read-many "let" members, and a computed property that uses them
struct AbcStruct {
    let member1: Int
    let member2: String
    var combinedMembers: String {
        return "\(member1) - \(member2)"
    }
}

// How to initialize the struct
var abcInstance = AbcStruct(member1: 4, member2: "Hello")

// When you evaluate the object in playground, note you don't see the computed properties
abcInstance

// But we can explicitly request the computed property, causing the computation to occur
abcInstance.combinedMembers


//: More work with stored properties.

// Let's have storedProp2 track changes to storedProp with a 'didSet' property change observer.
class PropertyDemo {
    var storedProp1: Int? = nil {
        didSet {
            println("storedProp1 was set to \(storedProp1)")
            if let prop1 = storedProp1 {
                storedProp2 = prop1 * 2
            }
        }
    }
    
    var storedProp2: Int? // goal is to observe changes to storedProp1 and always have storedProp2 be storedProp1 * 2
}

var pDemo = PropertyDemo()

pDemo.storedProp1

// Be sure to enable the console by turning on the Assistant Editor from the View menu
pDemo.storedProp1 = 5

pDemo.storedProp2

// Note how it's using 'Some' to show an Optional that's full with an Int value in side
pDemo.storedProp1 = 10
