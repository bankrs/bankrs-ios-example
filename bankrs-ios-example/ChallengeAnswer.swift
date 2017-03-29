//
//  ChallengeAnswer.swift
//  bankrs-ios-example
//
//  Created by Ingmar.Stein on 29.03.17.
//  Copyright © 2017 Bankrs. All rights reserved.
//

import Foundation

struct ChallengeAnswer {

    let id: String
    let value: String
    let store: Bool

    func asJSON() -> [String: Any] {
        return [
            "id": id,
            "value": value,
            "store": store
        ]
    }

}
