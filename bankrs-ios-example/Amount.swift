//
//  Amount.swift
//  bankrs-ios-example
//
//  Created by Ingmar.Stein on 10.03.17.
//  Copyright © 2017 Bankrs. All rights reserved.
//

import Foundation

struct Amount: Decodable {

    let value: Decimal
    let currency: String

}
