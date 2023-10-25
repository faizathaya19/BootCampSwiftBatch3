import Foundation

class ATMMachine {
    var accountBalance: Double
    
    init(initialBalance: Double) {
        self.accountBalance = initialBalance
    }
    
    func deposit() {
        print("Masukkan jumlah deposit:")
        guard let depositAmount = readDoubleInput() else {
            print("Input tidak valid. Masukkan angka.")
            return
        }

        guard depositAmount > 0 else {
            print("Jumlah deposit harus lebih dari 0.")
            return
        }

        accountBalance += depositAmount
        print("Deposit berhasil. Saldo akun sekarang \(accountBalance).")
    }
    
    func withdraw() {
        print("Masukkan jumlah penarikan:")
        guard let withdrawAmount = readDoubleInput() else {
            print("Input tidak valid. Masukkan angka.")
            return
        }

        guard withdrawAmount > 0 else {
            print("Jumlah penarikan harus lebih dari 0.")
            return
        }

        guard withdrawAmount <= accountBalance else {
            print("Saldo tidak mencukupi untuk penarikan tersebut.")
            return
        }

        accountBalance -= withdrawAmount
        print("Penarikan berhasil. Saldo akun sekarang \(accountBalance).")
    }
    
    func checkBalance() {
        print("Saldo akun Anda saat ini adalah \(accountBalance).")
    }
    
    func exit() {
        print("Terima kasih telah menggunakan ATM. Sampai jumpa!")
    }
    
    func startTransaction() {
        print("Selamat datang di ATM Machine")
        print("Pilih Transaksi:")
        print("1. Deposit")
        print("2. Withdraw")
        print("3. Balance Inquiry")
        print("4. Exit")

        guard let choice = readIntInput() else {
            print("Input tidak valid. Masukkan angka.")
            return
        }

        switch choice {
        case 1:
            deposit()
        case 2:
            withdraw()
        case 3:
            checkBalance()
        case 4:
            exit()
        default:
            print("Pilihan tidak valid.")
        }
    }

    private func readIntInput() -> Int? {
        guard let input = readLine(), let intValue = Int(input) else {
            return nil
        }
        return intValue
    }

    private func readDoubleInput() -> Double? {
        guard let input = readLine(), let doubleValue = Double(input) else {
            return nil
        }
        return doubleValue
    }
}

// Contoh penggunaan ATM Machine
let atm = ATMMachine(initialBalance: 1000.0)
atm.startTransaction()
