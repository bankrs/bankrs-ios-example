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

    private static let endpoint = "https://api.staging.bankrs.com/v1"
    private static let applicationId = "8f80d33b-26ee-4f69-ba7b-6859dde5e207"

    static var sessionToken: String?

    private static let sessionManager = SessionManager(serverTrustPolicyManager: ServerTrustPolicyManager(policies: ["api.staging.bankrs.com": .disableEvaluation]))

    static func login(username: String, password: String, _ result: @escaping (Error?) -> Void) {
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
            self.sessionToken = nil
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

    static func categories(_ result: @escaping ([Int: String], Error?) -> Void) {
        let headers = [
            "X-Application-Id": applicationId
        ]

        // Fetch Request
        sessionManager.request("\(endpoint)/categories", method: .get, headers: headers)
            .validate()
            .responseJSON { response in
                if response.result.error == nil {
                    debugPrint("HTTP Response Body: \(response.data)")
                    if let json = response.result.value as? [String: Any] {
                        if let jsonCategories = json["categories"] as? [[String: Any]] {
                            var categories = [Int: String]()
                            for category in jsonCategories {
                                if let id = category["id"] as? Int, let names = category["names"] as? [String: String], let name = names["en"] {
                                    categories[id] = name
                                }
                            }
                            result(categories, nil)
                            return
                        }
                    }
                    result([:], nil)
                } else {
                    debugPrint("HTTP Request failed: \(response.result.error)")
                    result([:], response.result.error)
                }
        }
    }

    static func bankAccesses(_ result: @escaping ([BankAccess], Error?) -> Void) {
        guard let sessionToken = sessionToken else {
            result([], nil)
            return
        }

        let headers = [
            "X-Application-Id": applicationId,
            "X-Token": sessionToken
        ]

        // Fetch Request
        sessionManager.request("\(endpoint)/accesses", method: .get, headers: headers)
            .validate()
            .responseJSON { response in
                if response.result.error == nil {
                    debugPrint("HTTP Response Body: \(response.data)")
                    if let json = response.result.value as? [String: Any] {
                        if let jsonAccesses = json["accesses"] as? [[String: Any]] {
                            let accesses = jsonAccesses.flatMap { return BankAccess(json: $0) }
                            result(accesses, nil)
                            return
                        }
                    }
                    result([], nil)
                } else {
                    debugPrint("HTTP Request failed: \(response.result.error)")
                    result([], response.result.error)
                }
        }
    }

    static func bankAccess(identifier: Int, _ result: @escaping (BankAccess?, Error?) -> Void) {
        guard let sessionToken = sessionToken else {
            result(nil, nil)
            return
        }

        let headers = [
            "X-Application-Id": applicationId,
            "X-Token": sessionToken
        ]

        // Fetch Request
        sessionManager.request("\(endpoint)/accesses/\(identifier)", method: .get, headers: headers)
            .validate()
            .responseJSON { response in
                if response.result.error == nil {
                    debugPrint("HTTP Response Body: \(response.data)")
                    if let json = response.result.value as? [String: Any], let jsonAccess = json["access"] {
                        let access = BankAccess(json: jsonAccess)
                        result(access, nil)
                        return
                    }
                    result(nil, nil)
                } else {
                    debugPrint("HTTP Request failed: \(response.result.error)")
                    result(nil, response.result.error)
                }
        }
    }

}
