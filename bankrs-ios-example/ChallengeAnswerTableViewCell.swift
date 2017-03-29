//
//  ChallengeAnswerTableViewCell.swift
//  bankrs-ios-example
//
//  Created by Ingmar.Stein on 29.03.17.
//  Copyright © 2017 Bankrs. All rights reserved.
//

import UIKit

class ChallengeAnswerTableViewCell: UITableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var textField: UITextField!

    func configureForChallenge(_ challenge: Challenge) {
        descriptionLabel.text = challenge.description
        textField.isSecureTextEntry = challenge.secure
        if let type = challenge.type {
            switch type {
            case "alphanumeric":
                textField.keyboardType = .default
            case "alpha":
                textField.keyboardType = .alphabet
            case "numeric":
                textField.keyboardType = .numberPad
            default:
                textField.keyboardType = .default
            }
        }
    }

}
