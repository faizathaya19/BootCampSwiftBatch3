//: [Previous](@previous)

import Foundation


func greet(person: String, greeting: (String) -> String) {
    let message = greeting(person)
    print(message)
}

func simpleGreeting(name: String) -> String {
    return "Hello, \(name)!"
}

// memasukan function kedalam parameter function
greet(person: "Alice", greeting: simpleGreeting)

// atau bisa di masukan setelah fungsi nama lainya adalah trailing closure
greet(person: "kholis") { name in
    return  "Hello, \(name)!"
}


// fungsi yang mereturn fungsi lagi
func makeIncrementer(incrementAmount: Int) -> () -> Int {
    var total = 0
    let incrementer: () -> Int = {
        total += incrementAmount
        return total
    }
    return incrementer
}

let incrementByTwo = makeIncrementer(incrementAmount: 2)
print(incrementByTwo())  // 2
print(incrementByTwo())  // 4

// variable closure
typealias SumTwoInt = (Int, Int) -> Int
let addClosure: SumTwoInt = { (a, b) in
    return a + b
}

// Use the closure
let result = addClosure(3, 5) // result is now 8
print(result)
//: [Next](@next)


let names = ["John", "Alice", "Bob", "Charlie"]

// Menggunakan closure untuk mengurutkan array berdasarkan panjang nama
let sortedNames = names.sorted { $0.count < $1.count }

print(sortedNames)  // Output: ["Bob", "John", "Alice", "Charlie"]
let numbers = [1, 2, 3, 4, 5]

// Menggunakan closure untuk mengubah setiap elemen array
let squaredNumbers = numbers.map { $0 * $0 }

print(squaredNumbers)  // Output: [1, 4, 9, 16, 25]


func fetchData(completionHandler: @escaping (Result<String, Error>) -> Void) {
    // Simulasi asynchronus operation
    DispatchQueue.global().async {
        // Data berhasil diambil
        if Bool.random() {
            completionHandler(.success("Data berhasil diambil"))
        } else {
            completionHandler(.failure(NSError(domain: "com.example", code: 42, userInfo: nil)))
        }
    }
}

// Memanggil fungsi fetchData dengan menggunakan closure
fetchData { result in
    switch result {
    case .success(let data):
        print(data)
    case .failure(let error):
        print("Error: \(error.localizedDescription)")
    }
}

//---------------------------------------------------------------------------

// Contoh 1: Closure sebagai parameter fungsi
let greetClosure: () -> Void = {
    print("Hello, World!")
}

func executeClosure(closure: () -> Void) {
    closure()
}

executeClosure(closure: greetClosure)

// Contoh 2: Penulisan closure langsung dalam parameter fungsi
executeClosure {
    print("Hi there!")
}

// Fungsi dengan trailing closure
func performOperation(_ operation: () -> Void) {
    print("Performing operation...")
    operation()
}

// Panggil fungsi dengan trailing closure
performOperation {
    print("Operation completed.")
}


struct Task {
    var title: String
    var isCompleted: Bool
}

class TodoList {
    var tasks: [Task] = []

    // Fungsi untuk menambahkan tugas dengan menggunakan closure
    func addTask(title: String, completionHandler: () -> Void) {
        let newTask = Task(title: title, isCompleted: false)
        tasks.append(newTask)

        // Panggil closure untuk memberi tahu bahwa tugas telah ditambahkan
        completionHandler()
    }
}

let myTodoList = TodoList()

// Panggil fungsi addTask dengan menggunakan trailing closure
myTodoList.addTask(title: "Membaca Buku") {
    print("Tugas telah ditambahkan ke dalam daftar.")
}

// Cetak daftar tugas setelah penambahan
print("Daftar Tugas: \(myTodoList.tasks)")

