//: [Previous](@previous)

import Foundation

struct Book {
    var title: String
    var author: String
}

class Library {
    var availableBooks: [Book]
    var borrowedBooks: [Book]
    
    init(availableBooks: [Book]) {
        self.availableBooks = availableBooks
        self.borrowedBooks = []
    }
    
    func borrowBook(bookTitle: String) -> Book? {
        guard let index = availableBooks.firstIndex(where: { $0.title == bookTitle }) else {
            print("Buku tidak tersedia untuk dipinjam.")
            return nil
        }
        
        let borrowedBook = availableBooks.remove(at: index)
        borrowedBooks.append(borrowedBook)
        
        print("Buku \(borrowedBook.title) berhasil dipinjam.")
        return borrowedBook
    }
    
    func returnBook(book: Book) {
        guard let index = borrowedBooks.firstIndex(where: { $0.title == book.title }) else {
            print("Buku tidak tercatat sebagai dipinjam.")
            return
        }
        
        let returnedBook = borrowedBooks.remove(at: index)
        availableBooks.append(returnedBook)
        
        print("Buku \(returnedBook.title) berhasil dikembalikan.")
    }
    
    func listAvailableBooks() -> [Book] {
        print("Buku yang tersedia:")
        availableBooks.forEach { print("\($0.title) oleh \($0.author)") }
        return availableBooks
    }
    
    func listBorrowedBooks() -> [Book] {
        print("Buku yang sedang dipinjam:")
        borrowedBooks.forEach { print("\($0.title) oleh \($0.author)") }
        return borrowedBooks
    }
}

let book1 = Book(title: "Swift Programming", author: "John Doe")
let book2 = Book(title: "Design Patterns", author: "Jane Doe")
let book3 = Book(title: "Data Structures", author: "Bob Smith")

let library = Library(availableBooks: [book1, book2, book3])

let borrowedBook = library.borrowBook(bookTitle: "Swift Programming")

library.listAvailableBooks()
library.listBorrowedBooks()

library.returnBook(book: borrowedBook!)

library.listAvailableBooks()
library.listBorrowedBooks()
