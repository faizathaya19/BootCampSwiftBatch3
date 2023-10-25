// Contoh Penggunaan 'as' untuk Casting
let anyValue: Any = 42

// Casting dari Any ke Int
if let intValue = anyValue as? Int {
    print("Nilai adalah \(intValue)")
} else {
    print("Tidak dapat melakukan casting ke Int")
}

// Casting dari Any ke String
let stringValue = "Hello, Swift!"
let anyStringValue: Any = stringValue

if let strValue = anyStringValue as? String {
    print("Nilai adalah \(strValue)")
} else {
    print("Tidak dapat melakukan casting ke String")
}
