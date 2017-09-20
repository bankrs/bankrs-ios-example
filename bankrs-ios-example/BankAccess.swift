//
//  BankAccess.swift
//  bankrs-ios-example
//
//  Created by Ingmar.Stein on 13.03.17.
//  Copyright © 2017 Bankrs. All rights reserved.
//

import Foundation

struct BankAccess: Decodable {

    let id: Int
    let bankId: String
    let name: String?
    let enabled: Bool
    let accounts: [BankAccount]

    enum CodingKeys: String, CodingKey {
        case id
        case bankId = "bank_id"
        case name
        case enabled
        case accounts
    }

}
