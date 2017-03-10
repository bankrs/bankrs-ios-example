//
//  BankrsApi.swift
//  bankrs-ios-example
//
//  Created by Ingmar.Stein on 10.03.17.
//  Copyright © 2017 Ingmar.Stein. All rights reserved.
//

import Foundation
import Alamofire

class BankrsApi {

    let endpoint = "https://api-staging.bankrs.com/v1"
    let applicationId = "8f80d33b-26ee-4f69-ba7b-6859dde5e207"
    let username = "john.doe@bankworld.com"
    let password = "F6hC>dEgAWNnmRg.7xBE"

    var sessionToken: String?

    func login() {
        let headers = [
            "X-Application-Id": applicationId
        ]

        let body: [String : Any] = [
            "username": username,
            "password": password
        ]

        Alamofire.request("\(endpoint)/users/login", method: .post, parameters: body, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success:
                print("Login successful")
                guard let data = response.result.value as? [AnyHashable: Any] else { return }
                self.sessionToken = data["token"] as? String
                print(data)
            case .failure(let error):
                print(error)
            }
        }
    }

    func logout() {
        Alamofire.request("\(endpoint)/users/logout").validate()
    }

    func transactions(_ result: ([Transaction]) -> Void) {
        let headers = [
            "X-Application-Id": applicationId
        ]

        // Fetch Request
        Alamofire.request("\(endpoint)/transactions", method: .get, headers: headers)
            .validate()
            .responseJSON { response in
                if response.result.error == nil {
                    debugPrint("HTTP Response Body: \(response.data)")
                } else {
                    debugPrint("HTTP Request failed: \(response.result.error)")
                }
        }
    }
}
