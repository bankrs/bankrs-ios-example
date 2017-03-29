//
//  Challenge.swift
//  bankrs-ios-example
//
//  Created by Ingmar.Stein on 29.03.17.
//  Copyright © 2017 Bankrs. All rights reserved.
//

import Foundation

struct Challenge {

    let id: String
    let description: String?
    let type: String?
    let secure: Bool
    let unstoreable: Bool

    init?(json: Any) {
        guard let dict = json as? [AnyHashable: Any] else { return nil }

        id = dict["id"] as! String
        description = dict["desc"] as? String
        type = dict["type"] as? String
        secure = dict["secure"] as? Bool ?? true
        unstoreable = dict["secure"] as? Bool ?? false
    }

}
