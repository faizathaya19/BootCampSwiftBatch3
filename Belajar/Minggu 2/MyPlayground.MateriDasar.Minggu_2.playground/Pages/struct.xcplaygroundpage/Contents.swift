//: [Previous](@previous)

import Foundation

//: [Previous](@previous)

import Foundation

struct Point {
    var x: Int
    var y: Int
}

var originalPoint = Point(x: 1, y: 2)
originalPoint.x = 10
print(originalPoint)
var updatePoint = originalPoint
print(updatePoint.x)


enum Weekday: String {
    case monday = "Monday"
    case tuesday = "Tuesday"
    case wednesday = "Wednesday"
    case thursday = "Thursday"
    case friday = "Friday"
    case saturday = "Saturday"
    case sunday = "Sunday"
}

struct MyStruct {
    var id: Int = 0
    var namaKampus: String
    var akreditasi: String
    var dayOfWeek: Weekday
    
    // Inisialisasi struct dengan variable bebas
    init(id: Int, namaKampus: String, akreditasi: String, dayOfWeek: Weekday) {
        self.id = id
        self.namaKampus = namaKampus
        self.akreditasi = akreditasi
        self.dayOfWeek = dayOfWeek
    }
    
    // Method untuk menentukan apakah suatu hari adalah hari libur
    func isHoliday() -> Bool {
        return dayOfWeek == .saturday || dayOfWeek == .sunday
    }
}

// Penggunaan struct dengan enum
let myInstance = MyStruct(id: 1, namaKampus: "UI", akreditasi: "B", dayOfWeek: .friday)

// Mengakses properti
print("id: \(myInstance.id)")
print("namaKampus \(myInstance.namaKampus)")
print("akreditasi: \(myInstance.akreditasi)")
print("Day of Week: \(myInstance.dayOfWeek.rawValue)")

// Memanggil method isHoliday
if myInstance.isHoliday() {
    print("It's a holNiday!")
} else {
    print("It's a working day.")
}

enum EmploymentStatus: String {
    case fullTime = "Full Time"
    case partTime = "Part Time"
    case contractor = "Contractor"
}

struct Employee {
    var name: String
    var age: Int
    var jobTitle: String
    var employmentStatus: EmploymentStatus
    
    init(name: String, age: Int, jobTitlee: String, employmentStatus: EmploymentStatus) {
        self.name = name
        self.age = age
        self.jobTitle = jobTitlee
        self.employmentStatus = employmentStatus
    }
    
    func printEmployeeInfo() {
        print("Name: \(name)")
        print("Age: \(age)")
        print("Job Title: \(jobTitle)")
        print("Employment Status: \(employmentStatus.rawValue)")
    }
}

let employee1 = Employee(name: "Faiz Athaya Ramadhan", age: 30, jobTitlee: "iOS Dev", employmentStatus: .fullTime)
let employee2 = Employee(name: "Dono", age: 25, jobTitlee: "Graphic Designer", employmentStatus: .partTime)

employee1.printEmployeeInfo()
print("\n")
employee2.printEmployeeInfo()

