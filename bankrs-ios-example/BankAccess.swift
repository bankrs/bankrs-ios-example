//
//  BankAccess.swift
//  bankrs-ios-example
//
//  Created by Ingmar.Stein on 13.03.17.
//  Copyright © 2017 Bankrs. All rights reserved.
//

import Foundation

struct BankAccess {
    let id: Int
    let bankId: String
    let name: String?
    let enabled: Bool
    let accounts: [BankAccount]

    init?(json: Any) {
        guard let dict = json as? [AnyHashable: Any] else { return nil }

        id = dict["id"] as! Int
        bankId = String(describing: dict["bank_id"])
        name = dict["name"] as? String
        enabled = dict["enabled"] as? Bool ?? false

        if let bankAccounts = dict["accounts"] as? [Any] {
            accounts = bankAccounts.flatMap { return BankAccount(json: $0) }
        } else {
            accounts = []
        }
    }
}
