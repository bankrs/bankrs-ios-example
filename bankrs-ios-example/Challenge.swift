//
//  Challenge.swift
//  bankrs-ios-example
//
//  Created by Ingmar.Stein on 29.03.17.
//  Copyright © 2017 Bankrs. All rights reserved.
//

import Foundation

struct Challenge: Decodable {

    let id: String
    let description: String?
    let type: String?
    let secure: Bool
    let unstoreable: Bool

}
