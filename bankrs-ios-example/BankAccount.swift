//
//  BankAccount.swift
//  bankrs-ios-example
//
//  Created by Ingmar.Stein on 13.03.17.
//  Copyright © 2017 Bankrs. All rights reserved.
//

import Foundation

struct BankAccount: Decodable {

    let id: Int
    let name: String
    let number: String
    let balance: Decimal
    let balanceDate: Date?
    let enabled: Bool
    let currency: String
    let iban: String
    let supported: Bool

    enum CodingKeys : String, CodingKey {
        case id
        case name
        case number
        case balance
        case balanceDate = "balance_date"
        case enabled
        case currency
        case iban
        case supported
    }

}
