//
//  Transaction.swift
//  bankrs-ios-example
//
//  Created by Ingmar.Stein on 10.03.17.
//  Copyright © 2017 Bankrs. All rights reserved.
//

import Foundation

struct Transaction {
    let id: Int
    let userBankAccountId: Int
    let categoryId: Int?
    let repeatedTransactionId: Int?
    let counterparty: Counterparty?
    let entryDate: Date?
    let settlementDate: Date?
    let amount: Amount?
    let usage: String?
    let type: String?

    init?(json: Any) {
        guard let dict = json as? [AnyHashable: Any] else { return nil }

        let dateFormatter = ISO8601DateFormatter()

        id = dict["id"] as! Int
        userBankAccountId = dict["user_bank_account_id"] as! Int
        categoryId = dict["category_id"] as? Int
        repeatedTransactionId = dict["repeated_transaction_id"] as? Int
        counterparty = dict["counterparty"].flatMap { Counterparty(json: $0) }
        entryDate = dateFormatter.date(from: dict["entry_date"] as! String)
        settlementDate = dateFormatter.date(from: dict["entry_date"] as! String)
        amount = Amount(json: dict["amount"]!)
        usage = dict["usage"] as? String
        type = dict["type"] as? String
    }

}
