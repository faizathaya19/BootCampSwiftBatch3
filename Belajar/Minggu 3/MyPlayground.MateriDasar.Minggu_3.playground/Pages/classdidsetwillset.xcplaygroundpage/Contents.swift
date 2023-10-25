class Person {
    // Properti dengan getter dan setter
    var name: String {
        didSet {
            // Akan dipanggil saat nilai name berubah
            print("Nama telah diubah menjadi \(name)")
        }
    }
    
    var age: Int {
        willSet(newAge) {
            // Akan dipanggil sebelum nilai age berubah
            print("Akan mengubah umur dari \(age) menjadi \(newAge)")
        }
        didSet {
            // Akan dipanggil saat nilai age berubah
            if age < 0 {
                print("Umur tidak valid. Tetapkan nilai umur positif.")
                age = oldValue
            }
        }
    }
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

// Contoh penggunaan class dengan getter dan setter
let person = Person(name: "John Doe", age: 30)

print("Nama: \(person.name)")
print("Umur: \(person.age)")

// Mengubah nilai properti dengan setter
person.name = "Jane Doe"
person.age = 25

print("Nama setelah perubahan: \(person.name)")
print("Umur setelah perubahan: \(person.age)")
