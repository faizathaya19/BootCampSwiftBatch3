//
//  Model.swift
//  ProdukAwal
//
//  Created by Phincon on 27/10/23.
//

import Foundation

struct UserData: Identifiable {
    var id = UUID()
    var user: String
    var password: String
    var pelajaran: [Pelajaran]
}

struct Pelajaran {
    var namaMatkul: MataPelajaran
}

struct MataPelajaran {
    var nilai: Int
    var guru: String
}
