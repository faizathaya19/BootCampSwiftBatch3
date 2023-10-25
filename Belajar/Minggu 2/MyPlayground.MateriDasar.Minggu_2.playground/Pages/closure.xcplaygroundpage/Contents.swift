// Contoh 1: Closure sebagai variabel
let simpleClosure = {
    print("Ini adalah contoh closure sederhana.")
}

// Memanggil closure
simpleClosure()

// Contoh 2: Closure dengan parameter dan return value
let addClosure: (Int, Int) -> Int = { (a, b) in
    return a + b
}

let result = addClosure(3, 5)
print("Hasil penjumlahan: \(result)")

// Contoh 3: Menggunakan closure sebagai argument fungsi
func operateOnNumbers(_ a: Int, _ b: Int, operation: (Int, Int) -> Int) {
    let result = operation(a, b)
    print("Hasil operasi: \(result)")
}

operateOnNumbers(10, 5, operation: addClosure)

// Contoh 4: Trailing Closure
operateOnNumbers(8, 3) { (a, b) in
    // Ini adalah trailing closure
    return a - b
}

// Contoh 5: Trailing Closure dengan sintaks pendek
operateOnNumbers(6, 2) { $0 * $1 }

// Contoh 6: Escaping Closure
var completionHandlers: [() -> Void] = []

func someFunctionWithEscapingClosure(completionHandler: @escaping () -> Void) {
    completionHandlers.append(completionHandler)
}

// Memanggil closure yang disimpan dalam array
someFunctionWithEscapingClosure {
    print("Closure yang disimpan dipanggil.")
}

// Contoh 7: Autoclosure
func printResult(_ result: @autoclosure () -> Void) {
    print("Hasil:")
    result()
}

// Memanggil fungsi dengan autoclosure
printResult(print("Autoclosure dijalankan"))

// Contoh 8: Capture Values
func makeIncrementer(incrementAmount: Int) -> () -> Int {
    var total = 0
    
    let incrementer: () -> Int = {
        // Menangkap nilai incrementAmount dan menggunakannya
        total += incrementAmount
        return total
    }
    
    return incrementer
}

let incrementByTwo = makeIncrementer(incrementAmount: 2)
print("Nilai pertama: \(incrementByTwo())") // Output: 2
print("Nilai kedua: \(incrementByTwo())")  // Output: 4
