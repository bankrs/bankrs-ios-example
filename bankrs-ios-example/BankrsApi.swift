//
//  BankrsApi.swift
//  bankrs-ios-example
//
//  Created by Ingmar.Stein on 10.03.17.
//  Copyright © 2017 Bankrs. All rights reserved.
//

import Foundation
import Alamofire

class BankrsApi {

    static let endpoint = "https://api-staging.bankrs.com/v1"
    static let applicationId = "8f80d33b-26ee-4f69-ba7b-6859dde5e207"
    static let username = "john.doe@bankworld.com"
    static let password = "F6hC>dEgAWNnmRg.7xBE"

    static var sessionToken: String?
    
    static let sessionManager = SessionManager(serverTrustPolicyManager: ServerTrustPolicyManager(policies: ["api-staging.bankrs.com" : .disableEvaluation]))

    static func login(_ result: @escaping (Error?) -> Void) {
        let headers = [
            "X-Application-Id": applicationId
        ]

        let body: [String : Any] = [
            "username": username,
            "password": password
        ]

        sessionManager.request("\(endpoint)/users/login", method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success:
                print("Login successful")
                guard let data = response.result.value as? [AnyHashable: Any] else { return }
                self.sessionToken = data["token"] as? String
                print(data)
                result(nil)
            case .failure(let error):
                print(error)
                result(error)
            }
        }
    }

    static func logout(_ result: @escaping (Error?) -> Void) {
        guard let sessionToken = sessionToken else {
            result(nil)
            return
        }
        
        let headers = [
            "X-Application-Id": applicationId,
            "X-Token": sessionToken
        ]
        
        sessionManager.request("\(endpoint)/users/logout", method: .post, headers: headers).validate().response { response in
            result(response.error)
        }
    }

    static func transactions(_ result: @escaping ([Transaction], Error?) -> Void) {
        guard let sessionToken = sessionToken else {
            result([], nil)
            return
        }
        
        let headers = [
            "X-Application-Id": applicationId,
            "X-Token": sessionToken
        ]

        // Fetch Request
        sessionManager.request("\(endpoint)/transactions", method: .get, headers: headers)
            .validate()
            .responseJSON { response in
                if response.result.error == nil {
                    debugPrint("HTTP Response Body: \(response.data)")
                    if let array = response.result.value as? [Any] {
                        result(array.flatMap { Transaction(json: $0) }, nil)
                    } else {
                        result([], nil)
                    }
                } else {
                    debugPrint("HTTP Request failed: \(response.result.error)")
                    result([], response.result.error)
                }
        }
    }
}
