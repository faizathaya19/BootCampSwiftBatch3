//: [Previous](@previous)

import Foundation

func family(with name : String, umur : Int){
    print(name, umur)
}

family(with : "faiz", umur : 12)



func greetAgain(person: String) -> String {
    return "Hello again, " + person + "!"
}

print(greetAgain(person: "faiz"))
// Prints "Hello again, Anna!"

enum Day: String {
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday
}

func isWeekend(day: Day) -> Bool {
    switch day {
    case .saturday, .sunday:
        return true
    default:
        return false
    }
}

let today = Day.saturday

if isWeekend(day: today) {
    print("Hari ini adalah hari libur!")
} else {
    print("Hari ini bukan hari libur.")
}



//: [Next](@next)
