//
//  Counterparty.swift
//  bankrs-ios-example
//
//  Created by Ingmar.Stein on 10.03.17.
//  Copyright © 2017 Bankrs. All rights reserved.
//

import Foundation

struct Counterparty {
    let name: String
    let merchant: String?
    
    init?(json: Any) {
        guard let dict = json as? [AnyHashable: Any] else { return nil }
        
        name = dict["name"] as! String
        merchant = dict["merchant"] as? String
    }
}
