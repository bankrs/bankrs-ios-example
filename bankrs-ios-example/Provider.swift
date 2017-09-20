//
//  Provider.swift
//  bankrs-ios-example
//
//  Created by Ingmar.Stein on 29.03.17.
//  Copyright © 2017 Bankrs. All rights reserved.
//

import Foundation

struct Provider {

    let id: String
    let name: String?
    let description: String?
    let country: String?
    let url: URL?
    let address: String?
    let postalCode: String?
    let challenges: [Challenge]

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case country
        case url
        case address
        case postalCode = "postal_code"
        case challenges
    }

}
