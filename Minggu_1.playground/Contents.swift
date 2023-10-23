import UIKit

import Foundation

var name : String = "Faiz Athaya Ramadhan"
var universitas : String = "Gunadarma"

var umur : Int = Int()
umur = 24

print("Hello Nama saya", name.uppercased() ,"dari Universitas", universitas , "umur" , umur)

//Tupel mengelompokkan beberapa nilai menjadi satu nilai gabungan.
let dataMutia = ("muthia dini atikah", 18, 3.57)
let (namaM, umurM, ipkM) = dataMutia

print("Nama Adik saya \(namaM.uppercased()) Berumur \(umurM) Mendapatkan IPK \(ipkM)")

//Mengubah variable
let thisIsString = "123"
let convertToInt = Int(thisIsString)

print(convertToInt)

var serverResponseCode: Int? = 404
serverResponseCode = nil
print(serverResponseCode)
if serverResponseCode != nil {
    print("convertedNumber contains some integer value.")
}

// Guard let adalah penjagaan yang apabila tidak sesuai kondisi maka blok fungsi akan di berhentikan
func cekInt() {
    guard let dataSting = Int(thisIsString) else {
        fatalError("bukan int")
    }
    print(dataSting)
}
cekInt()

//array data

var dataList : [String?] = ["bayu","gunawan","malik",nil]
print(dataList[0])

//switch case

enum Days: String, CaseIterable  {
   case Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday

    func description() -> String {
        switch self {
        case .Sunday, .Saturday:
            return "Hari libur Cuy"
        case .Monday, .Tuesday, .Friday, .Wednesday:
            return "Hari Kerja"
        default:
            return "Cuti Dulu"
        }
    }
}

var namaHari: Days = .Monday

print(Days.allCases.count)

// Iterate through all cases
for direction in Days.allCases {
    print(direction.description())
}

var isKeren: Bool = true
var isArtis: Bool = false
var isKaya: Bool = true
var isFansMU: Bool = true

if (isKeren && isArtis) || isKaya {
    print("dia dipuja puja")
} else if isFansMU {
    print("jangan di hujat")
} else {
    print("gak keren")
}

if let actualNumber = Int(thisIsString) {
    print("tipe data string ini \"\(thisIsString)\" adalah data interger \(actualNumber)")
} else {
    print("ini string \"\(thisIsString)\" bukan data interger")
}

struct Point {
    var x: Int
    var y: Int
}

var originalPoint = Point(x: 1, y: 2)
originalPoint.x = 10
print(originalPoint)
var updatePoint = originalPoint
print(updatePoint.x)
