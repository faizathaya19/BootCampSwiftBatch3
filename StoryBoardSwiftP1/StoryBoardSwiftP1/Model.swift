//
//  Model.swift
//  StoryBoardSwiftP1
//
//  Created by Phincon on 27/10/23.
//

import Foundation

struct JenisKelamin{
    var L: String = "Laki - Laki"
    var P: String = "Perempuan"
}

struct DataKelas {
    var kelas: String
    var dataSiswa: DataSiswa
    
}

struct DataSiswa {
    var namaSiswa: String
    var emailSiswa: String
    var mataKuliah: String
    var jenisKelaminSiswa: JenisKelamin
}

struct MovieData{
    let sectionType: String
    let Movies: [String]
}


