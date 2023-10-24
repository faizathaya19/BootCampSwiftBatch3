import Foundation

enum ATMError: Error {
    case invalidInput(message: String)
    case invalidAmount(message: String)
    case insufficientFunds(message: String)
}

class ATMMachine {
    var accountBalance: Double
    
    init(initialBalance: Double) {
        self.accountBalance = initialBalance
    }
    
    func deposit() throws {
        print("Masukkan jumlah deposit:")
        guard let depositAmount = readDoubleInput() else {
            throw ATMError.invalidInput(message: "Input tidak valid. Masukkan angka.")
        }

        guard depositAmount > 0 else {
            throw ATMError.invalidAmount(message: "Jumlah harus lebih dari 0.")
        }

        accountBalance += depositAmount
        print("Deposit berhasil. Saldo akun sekarang \(accountBalance).")
    }
    
    func withdraw() throws {
        print("Masukkan jumlah penarikan:")
        guard let withdrawAmount = readDoubleInput() else {
            throw ATMError.invalidInput(message: "Input tidak valid. Masukkan angka.")
        }

        guard withdrawAmount > 0 else {
            throw ATMError.invalidAmount(message: "Jumlah harus lebih dari 0.")
        }

        guard withdrawAmount <= accountBalance else {
            throw ATMError.insufficientFunds(message: "Saldo tidak mencukupi untuk penarikan tersebut.")
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

        do {
            switch choice {
            case 1:
                try deposit()
            case 2:
                try withdraw()
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
        switch error {
        case .invalidInput(let message),
             .invalidAmount(let message),
             .insufficientFunds(let message):
            print(message)
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
