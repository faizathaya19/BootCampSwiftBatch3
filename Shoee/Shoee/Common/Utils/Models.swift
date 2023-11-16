import UIKit

struct Product {
    struct Category {
        let id: Int
        let name: String
    }

    struct Gallery {
        let id: Int
        let products_id: Int
        let url: String
    }

    let id: Int
    let name: String
    let price: Double
    let description: String
    let tags: [String]?
    let categories_id: Int
    let category: Category
    let galleries: [Gallery]
}

let products: [Product] = [
    Product(
        id: 1,
        name: "Adidas NMD",
        price: 200,
        description: "Ini adalah sepatu sport",
        tags: nil,
        categories_id: 1,
        category: Product.Category(id: 1, name: "Sport"),
        galleries: []
    ),
    Product(
        id: 2,
        name: "Ultra 4D 5 Shoes",
        price: 285,
        description: "When the adidas Ultraboost debuted back in 2015, it had an impact that spilled beyond the world of running. For this version of t...",
        tags: nil,
        categories_id: 5,
        category: Product.Category(id: 5, name: "Running"),
        galleries: [
            Product.Gallery(id: 1, products_id: 2, url: "https://shoesez.000webhostapp.com/storage/gallery/sW4VtliQPYnwvlbpxL5x6ZhKvbgBWT84OoiDyRsE.png"),
            Product.Gallery(id: 2, products_id: 2, url: "https://shoesez.000webhostapp.com/storage/gallery/ESsUP5CCJDFU9M2VENusfqpNTMnTmhaBJ1aXgObY.png"),
            // ... (Tambahkan entri galeri lainnya)
        ]
    ),
    Product(
        id: 3,
        name: "SL 20 Shoes",
        price: 123,
        description: "These adidas SL20 Shoes will back your play. Lightweight cushioning gives you a faster push-off and a snappy feel.",
        tags: nil,
        categories_id: 5,
        category: Product.Category(id: 5, name: "Running"),
        galleries: [
            Product.Gallery(id: 7, products_id: 3, url: "https://shoesez.000webhostapp.com/storage/gallery/MUwSao1nhz93t143rnGukQ3n3zsQOzT7bds6LaNL.png"),
            Product.Gallery(id: 8, products_id: 3, url: "https://shoesez.000webhostapp.com/storage/gallery/ypjT3Q93S4m4JJZU1AmFSvKGlYkzEozgquMuDlEl.png"),
            // ... (Tambahkan entri galeri lainnya)
        ]
    ),
    // ... (Tambahkan entri produk lainnya)
]
