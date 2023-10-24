import Foundation

// Enum untuk representasi error
enum ATMError: Error {
    case invalidInput
    case invalidAmount
    case errorGetMoney
    
    var message: String {
        switch self {
        case .invalidInput:
            return "Input tidak valid. Masukkan angka."
        case .invalidAmount:
            return "Jumlah harus lebih dari 0."
        case .errorGetMoney:
            return "Saldo tidak mencukupi untuk penarikan tersebut."
        }
    }
}

// Protokol untuk transaksi ATM
protocol ATMTransaction {
    func deposit(amount: Double) throws
    func withdraw(amount: Double) throws
    func checkBalance()
    func exit()
}

// Kelas ATM yang mengadopsi protokol ATMTransaction
class ATMMachine: ATMTransaction {
    var accountBalance: Double
    
    init(initialBalance: Double) {
        self.accountBalance = initialBalance
    }
    
    func deposit(amount: Double) throws {
        guard amount > 0 else {
            throw ATMError.invalidAmount
        }

        accountBalance += amount
        print("Deposit berhasil. Saldo akun sekarang \(accountBalance).")
    }
    
    func withdraw(amount: Double) throws {
        guard amount > 0 else {
            throw ATMError.invalidAmount
        }

        guard amount <= accountBalance else {
            throw ATMError.errorGetMoney
        }

        accountBalance -= amount
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

        do {
            switch choice {
            case 1:
                try deposit(amount: readAmountInput())
            case 2:
                try withdraw(amount: readAmountInput())
            case 3:
                checkBalance()
            case 4:
                exit()
            default:
                print("Pilihan tidak valid.")
            }
        } catch let error as ATMError {
            handleError(error)
        } catch {
            print("Terjadi kesalahan: \(error.localizedDescription)")
        }
    }

    private func handleError(_ error: ATMError) {
        print(error.message)
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

    private func readAmountInput() -> Double {
        print("Masukkan jumlah:")
        while true {
            if let amount = readDoubleInput(), amount > 0 {
                return amount
            } else {
                print("Jumlah harus lebih dari 0. Silakan coba lagi.")
            }
        }
    }
}

// Contoh penggunaan ATM Machine
let atm = ATMMachine(initialBalance: 1000.0)
atm.startTransaction()
