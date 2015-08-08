//: Type inference has some oddities. In some examples you saw Doubles and Ints combining without error, and some you didn't. Here's what was going on.

//: Here, `3` is inferred to be an Int, as would `3 + 7` or any expression with all integers
var x = 3
//: Inferencing for `x` is now locked in place

// var y1 = x * 5.05 
//: Results in: **Binary operator `*` cannot be applied to operands of type 'Int' and 'Double'**
//: Instead we must say:
var y1 = Double(x) * 5.05

//: But the following are just fine! Inference is taking place at the time of declaration and Swift can decide the whole expression is of type `Double`; the constant `3` has an opportunity to be *promoted*
var y2 = 3 * 5.05            // 3 is promoted to Double
var y3 = 3 / 5.05            // 3 is promoted to Double
var fivePointOhFive = 5.05   // fivePointOhFive inferred to be Double
var y4 = 3 / fivePointOhFive // 3 is promoted to Double
//: Don't worry about why...an intellectual argument could go either way...just learn it



//: The super-abbreviated inlined (anonymous) closure syntax also has some oddities.
//: Here, let's figure out what's happening.

//: What does Swift know?
//: 1. `map` takes an array where all elements have a common type. In this case, `Int`.
//: 2. `map` also takes a closure where the input parameter must match that type. So the input parameter [which we don't bother naming because it gets a built-in name `$0`] is inferred to be of type `Int`
//: 3. `Int * Int` results in an `Int`, so that's the type of the single expression `$0 * $0`
//: 4. When there is only one expression, it's implicitly a `return` statement
//: 5. When there is a single `return` statement *and no other statements*, the function implicitly declared to return that type.
//: 6. Now that the input parameter **and** the return type have been determined, *the "signature" of the closure is fully inferred and need not be stated.*
map([2,4,6,8], { $0 * $0 })

//: The following was tried in class in response to a question, and failed.
// map([2, 4, 6, 8], { println("I'm busy multiplying \($0)"); return $0 * $0 })
//: Why?? All the logic is there right? Well, step 5 is violated, and rules are rules, so: no.

//: To fix it, we must have *most* of a complete function signature. We lose the ability to have our nice Perl-style `$0`, so we patch it all up thusly:
map([2, 4, 6, 8], { (x) -> Int in println("I'm busy multiplying \(x)"); return x * x })

//: This isn't as nice because now this line of code is now explicitly talking about `Int`. If we update the array to contain `Double`s, we also have to update the signature. Oh well. It's **possible** to solve this with Generics, but that's beyond the scope of this class unless there's tremendous interest in generics. We have iOS and Xcode to get to! We're willing to help curious students online.


//: Let's do the super-verbose version so we can really see all the work swift is doing for us
//: Admittedly, I went a little overboard to prove a point. I'm even putting in superfluous but valid
//: semicolons and whitespace
let two: Int = 2
let four: Int = 4
let six: Int = 6
let eight: Int = 8

var inputArray: [Int] = [Int]() // Start it off empty. Since we need to mutate it, it cannot be a "let"
inputArray.append(two)
inputArray.append(four)
inputArray.append(six)
inputArray.append(eight)

map(inputArray, {
    (sourceValue: Int) -> Int in

    let returnVal = sourceValue * sourceValue;
    return returnVal;
})


//: One more important piece of syntax. It's conceptually very easy & minor, but you'll see it all the time. When you have a long inlined closure, the open paren and close paren are separated by quite a few lines. To avoid this, there's a special syntax rule:
//: *When the closure is the **last** parameter, it can go **outside** the closing parenthesis.*
//: So, always practice it this way:
map(inputArray) {
    (sourceValue: Int) -> Int in
    
    let returnVal = sourceValue * sourceValue;
    return returnVal;
}
//: And remind yourself again and again that the `{ ... }` is an *input parameter* to the `map` (or whatever) function. This special syntax does **not** apply if the closure is not the last parameter.






//: We also got hung up for a few minutes on an error that was hard to find. Teachable moment:

//: 1. The entire lecture was one playground. When looked at as software, this violates the modularity constraint. It's a lot easier to find a broken piece in a small box than a big one.
//: 2. Playgrounds have a minor behavioral quirk where some edits cause the buffer to scroll to the very end. It may seem like only a minor annoyance, but this caused some formatting codes (###, meaning a large font heading) to go at the very bottom and hide there for a while
//: 3. Good error message reporting, and **consistency** are incredibly important. Big **F** to Xcode for gracefully handling some errors, and creating an expectation that compile errors will show up in the Error console, but then completely silent on various basic syntax errors such as accidental gibberish.
//: 4. This is a pet peeve of mine, because working professionally in IT for 10 years and semi-professionally for 10 years before that, I have spent a great deal of time chasing down horribly obscure error messages.
//: 5. If you're not a natural visual designer, you can score a lot of points with us with great error messages that handle every case.
//: 6. Rest assured that **real** Xcode is much more stable and happily catalogs all errors from every file in your Project, all in one place, clickable directly to the problem



