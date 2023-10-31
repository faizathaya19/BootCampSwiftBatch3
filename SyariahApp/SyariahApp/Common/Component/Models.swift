//
//  File.swift
//  SyariahApp
//
//  Created by Phincon on 30/10/23.
//

import Foundation
import UIKit



struct PaymentList {
    let id: Int
    let listData: PaymentListData
}

struct PaymentListData {
    let title: String
    let image: String
}

struct Item {
    var name: String
    var imageName: String
}
