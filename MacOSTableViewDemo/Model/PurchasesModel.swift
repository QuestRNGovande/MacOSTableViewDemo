//
//  PurchasesModel.swift
//  MacOSTableViewDemo
//
//  Created by Ratnadeep Govande on 8/6/19.
//  Copyright © 2019 Ratnadeep Govande. All rights reserved.
//

import Foundation

struct Purchases: Codable {
    var id: Int?
    var userInfo: UserInfo?
    var paymentInfo: PaymentInfo?
}

struct UserInfo: Codable{
    var id: Int?
    var username: String?
}

struct PaymentInfo: Codable{
    var creditCard: String?
    var creditCardType: String?
    var amount: String?
    var purchaseTypes: [String]?
}
