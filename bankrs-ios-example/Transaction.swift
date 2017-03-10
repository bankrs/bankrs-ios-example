//
//  Transaction.swift
//  bankrs-ios-example
//
//  Created by Ingmar.Stein on 10.03.17.
//  Copyright © 2017 Ingmar.Stein. All rights reserved.
//

import Foundation

struct Transaction {
    let id: String
    let userBankAccountId: String
    let categoryId: String
    let repeatedTransactionId: String
    //let counterparties: [Counterparty]
    let entryDate: Date?
    let settlementDate: Date?
    let amount: Amount?
    let usage: String?

    init?(json: Any) {
        guard let dict = json as? [AnyHashable: Any] else { return nil }

        let dateFormatter = ISO8601DateFormatter()

        id = dict["id"] as! String
        userBankAccountId = dict["user_bank_account_id"] as! String
        categoryId = dict["categoryId"] as! String
        repeatedTransactionId = dict["repeated_transaction_id"] as! String
        //counterparties = [] // TODO
        entryDate = dateFormatter.date(from: dict["entry_date"] as! String)
        settlementDate = dateFormatter.date(from: dict["entry_date"] as! String)
        amount = Amount(json: dict["amount"]!)
        usage = dict["usage"] as? String
    }
}
