// Intro comments:

// The immediate payoff for this lesson is low. It will not help you add interactive features to your iOS App.

// One approach is to ignore the issue, and just copy opaque boilerplate code where we tell you to, especially
// with regard to closures that are used within classes.

// The long term payoff is two-fold: You are learning important Comp. Sci. fundamentals that span most or all
// programming languages; and your Apps will not leak memory, vastly increasing their long-term stability
// and commercial viability. (Here, 'leak' is a technical term meaning "to waste memory such that it can never be reclaimed nor used during the lifetime of the App process")


// To the topic!

// init, if it exists, is called the moment after an object is ALLOCATED in memory
// deinit, if it exists, is called the moment before an object is RELEASED from memory

class SimpleClass {
    // static means there is a single instance of this property for the entire class
    // that is, for ALL instances of it
    static var instanceCounter = 0
    
    // whereas normal (no static) means the usual: one instance of the property PER object instance
    var myID: Int
    
    init() {
        // Having the name of the class is required to access static variables	
        myID = ++SimpleClass.instanceCounter // remember the semantics of the PRE-increment operator
        println("init: SimpleClass instance initialized with ID \(myID)")
    }
    
    deinit {
        println("deinit: SimpleClass instance released with ID \(myID)\n")
    }
}

// Note the errors demonstrated in these comments!
// 'nil' does not work like NULL in C or null in Java/PHP/JavaScript
// If you want to be able to assign any class or struct to nil, it MUST be wrapped in an Optional
// var badCode: SimpleClass = nil // COMPILE ERROR
// var another = SimpleClass()
// another = nil // COMPILE ERROR

println("Creating firstObj")
var firstObj: SimpleClass? = SimpleClass()

println("\nCreating secondObj")
var secondObj: SimpleClass? = SimpleClass()

println("\nCurrent state of affairs after simply creating the objects")
println("firstObj ID: \(firstObj!.myID) secondObj ID: \(secondObj!.myID)\n")

println("Setting firstObj to nil, note what happens in the console")
firstObj = nil

println("Setting firstObj to point to secondObj")
firstObj = secondObj

println("Current state of affairs after making firstObj variable point to same object as secondObj:")
println("firstObj ID: \(firstObj!.myID) secondObj ID: \(secondObj!.myID)\n")

println("Setting secondObj to nil. How many references are there to object ID #2?")
secondObj = nil
println("Setting firstObj to nil. Now how many references are there to #2?")
firstObj = nil



class LoopLeft {
    var right: LoopRight?
    deinit {
        println("This instance of LoopLeft's memory was released")
    }
}

class LoopRight {
    var left: LoopLeft?
    deinit {
        println("This instance of LoopRight's memory was released")
    }
}

println("Creating two objects referenced by 'left' and 'right' in an intentional reference loop")
var left: LoopLeft? = LoopLeft()
var right: LoopRight? = LoopRight()
left!.right = right
right!.left = left

println("Removing all accessible references to the objects by setting the variables to nil")
left = nil
right = nil

println("\nDid you see the deinit method called?\n")

println("Now let's fix the issue using a weak reference\n")
class Container {
    // This is NOT a weak reference, intentionally.
    // As long as the Container instance exists, this 'Contained' instance will continue to exist
    var contained: Contained?
    deinit {
        println("This instance of Container's memory was released")
    }
}

class Contained {
    // Introducing the concept of a 'weak' reference, that is NOT counted in the reference count algorithm
    // The Contained should not be able to keep the Container alive if there are no other references to the Container
    weak var container: Container?
    deinit {
        println("This instance of Contained's memory was released")
    }
}

var myContainer: Container? = Container()
var myContained: Contained? = Contained()
myContainer!.contained = myContained
myContained!.container = myContainer

println("Setting myContained variable to nil.")
println("Now, only reference to the 'Contained' instance is the 'contained' property inside the myContainer instance.\n")
myContained = nil

println("Setting myContainer to nil. Now, there's no references to myContainer, except the weak one! See diagram.")
println("Watch everything get collected.\n")
myContainer = nil

// This is groundwork to understand *capture lists* in closures. Closures are NOT just code -- 
// they're also objects that automatically capture references to objects in their environment.
// So a closure that sticks around for a while creates reference loop problems.
// It is subtle. First understand this and we'll get to capture lists next week.