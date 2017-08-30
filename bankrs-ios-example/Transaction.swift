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

    enum CodingKeys: String, CodingKey {
        case id
        case userBankAccountId = "user_bank_account_id"
        case categoryId = "category_id"
        case repeatedTransactionId = "repeated_transaction_id"
        case counterparty
        case entryDate = "entry_date"
        case settlementDate = "settlement_date"
        case amount
        case usage
        case type
    }

}
