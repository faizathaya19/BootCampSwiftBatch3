//: [Previous](@previous)
import Foundation

func printer() -> () -> Void {
    var count = 0
    
    let printClosure: () -> Void = {
        count += 1
        print("Count is \(count)")
    }
    
    return printClosure
}

let myPrinter = printer()
myPrinter() // Output: Count is 1
myPrinter() // Output: Count is 2


func doSomething(completion: () -> Void) {
    // Melakukan sesuatu
    completion()
}

// Tanpa trailing closure
doSomething(completion: {
    print("Closure executed")
})

// Dengan trailing closure
doSomething {
    print("Trailing closure executed")
}

