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

    init?(json: Any) {
        guard let dict = json as? [AnyHashable: Any] else { return nil }

        id = dict["id"] as! String
        name = dict["name"] as? String
        description = dict["description"] as? String
        country = dict["country"] as? String
        if let urlString = dict["url"] as? String {
            url = URL(string: urlString)
        } else {
            url = nil
        }
        address = dict["address"] as? String
        postalCode = dict["postal_code"] as? String
        if let challengesJSON = dict["challenges"] as? [Any] {
            challenges = challengesJSON.flatMap { Challenge(json: $0) }
        } else {
            challenges = []
        }
    }

}
