// Contoh Generic Function
func printArray<T>(array: [T]) {
    for element in array {
        print(element)
    }
}

// Contoh Generic Class
class Box<T> {
    var item: T
    
    init(item: T) {
        self.item = item
    }
}

// Penggunaan Generic Function
let stringArray = ["Apple", "Banana", "Orange"]
let intArray = [1, 2, 3, 4, 5]

printArray(array: stringArray)
printArray(array: intArray)

// Penggunaan Generic Class
let stringBox = Box(item: "Hello, Swift!")
let intBox = Box(item: 42)

print(stringBox.item)
print(intBox.item)

