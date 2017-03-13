//
//  BankAccount.swift
//  bankrs-ios-example
//
//  Created by Ingmar.Stein on 13.03.17.
//  Copyright © 2017 Bankrs. All rights reserved.
//

import Foundation

struct BankAccount {
    let id: Int
    let name: String
    let number: String
    let balance: NSDecimalNumber
    let balanceDate: Date
    let enabled: Bool
    let currency: String
    let iban: String
    let supported: Bool

    init?(json: Any) {
        guard let dict = json as? [AnyHashable: Any] else { return nil }

        id = dict["id"] as! Int
        name = dict["name"] as! String
        number = dict["number"] as! String
        balance = NSDecimalNumber(string: dict["balance"] as? String)
        balanceDate = Date.iso8601Formatter.date(from: dict["balance_date"] as! String)!
        enabled = dict["enabled"] as? Bool ?? false
        currency = dict["currency"] as? String ?? ""
        iban = dict["iban"] as? String ?? ""
        supported = dict["supported"] as? Bool ?? false
    }

}
