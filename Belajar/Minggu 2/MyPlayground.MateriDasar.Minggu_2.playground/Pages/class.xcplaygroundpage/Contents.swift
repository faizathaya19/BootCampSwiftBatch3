// Class Induk (Parent)
class Animal {
    var name: String
    var sound: String
    
    // Inisialisasi (Constructor)
    init(name: String, sound: String) {
        self.name = name
        self.sound = sound
    }
    
    // Method untuk memproduksi suara
    func makeSound() {
        print("\(name) makes a sound: \(sound)")
    }
}

// Class Anak (Child) yang mewarisi dari class Induk
class Dog: Animal {
    // Property tambahan hanya untuk kelas Dog
    var breed: String
    
    // Inisialisasi kelas anak dengan memanggil inisialisasi kelas induk
    init(name: String, sound: String, breed: String) {
        self.breed = breed
        // Memanggil inisialisasi kelas induk
        super.init(name: name, sound: sound)
    }
    
    // Override method makeSound dari kelas induk
    override func makeSound() {
        print("\(name) barks loudly: \(sound)")
    }
}

// Contoh penggunaan kelas Induk
let genericAnimal = Animal(name: "Generic Animal", sound: "Generic Sound")
genericAnimal.makeSound()

// Contoh penggunaan kelas Anak (Dog)
let myDog = Dog(name: "Buddy", sound: "Woof", breed: "Golden Retriever")
myDog.makeSound()

// Extension untuk menambahkan properti computed (get-only) pada class Animal
extension Animal {
    var description: String {
        return "This is a \(name) and it sounds like \(sound)"
    }
}

// Contoh penggunaan properti computed dari extension
print(myDog.description)

// Extension untuk menambahkan method pada class Animal
extension Animal {
    func greet() {
        print("Hello, I'm \(name)!")
    }
}

// Contoh penggunaan method dari extension
genericAnimal.greet()
