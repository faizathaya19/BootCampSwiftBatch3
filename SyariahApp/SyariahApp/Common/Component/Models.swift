//
//  File.swift
//  SyariahApp
//
//  Created by Phincon on 30/10/23.
//

import Foundation
import UIKit

//HOME

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

// DialogDetails.swift
struct DialogDetails {
    var title: String
    var message: String
    var isSuccess: Bool
}

