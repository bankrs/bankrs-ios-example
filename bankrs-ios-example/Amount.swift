//
//  Amount.swift
//  bankrs-ios-example
//
//  Created by Ingmar.Stein on 10.03.17.
//  Copyright © 2017 Ingmar.Stein. All rights reserved.
//

import Foundation

struct Amount {
    let value: NSDecimalNumber
    let currency: String

    init?(json: Any) {
        guard let dict = json as? [AnyHashable: Any] else { return nil }

        value = NSDecimalNumber(string: dict["value"] as? String)
        currency = dict["currency"] as! String
    }
}
