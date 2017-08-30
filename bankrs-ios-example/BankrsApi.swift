//
//  BankrsApi.swift
//  bankrs-ios-example
//
//  Created by Ingmar.Stein on 10.03.17.
//  Copyright © 2017 Bankrs. All rights reserved.
//

import Foundation
import Alamofire

enum BankrsRouter {

    fileprivate static let baseURL = URL(string: "https://api.staging.bankrs.com")!

    case login
    case logout
    case getTransactions
    case getCategories
    case getBankAccesses
    case getBankAccess(Int)
    case createBankAccess
    case getProviders

    var url: URL {
        return URL(string: path, relativeTo: BankrsRouter.baseURL)!
    }

    var route: (path: String, method: Alamofire.HTTPMethod) {
        switch self {
        case .login:                         return ("/v1/users/login", .post)
        case .logout:                        return ("/v1/users/logout", .post)
        case .getTransactions:               return ("/v1/transactions", .get)
        case .getCategories:                 return ("/v1/categories", .get)
        case .getBankAccesses:               return ("/v1/accesses", .get)
        case .getBankAccess(let identifier): return ("/v1/accesses/\(identifier)", .get)
        case .createBankAccess:              return ("/v1/accesses", .post)
        case .getProviders:                  return ("/v1/providers", .get)
        }
    }

    var path: String {
        return route.path
    }

    var method: Alamofire.HTTPMethod {
        return route.method
    }

    /*
    func asURLRequest() throws -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }
     */

}

class BankrsApi {


    static var sessionToken: String?

    // It is fine to hardcode the application ID in your application. We consider it some kind of long-living token.
    // When you delete an existing applciation ID you make all builds that using it unable to access API. Be sure that you
    // properly process the applciation ID error response by offering user to update the application with newer version.
    private static let applicationId = "7b270c43-a516-4e63-b89d-d5bebddf6811"

    static func login(username: String, password: String, _ result: @escaping (Error?) -> Void) {
        let headers = [
            "X-Application-Id": applicationId
        ]

        let body: [String : Any] = [
            "username": username,
            "password": password
        ]

        let route = BankrsRouter.login
        Alamofire.request(route.url, method: route.method, parameters: body, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { response in
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

        let route = BankrsRouter.logout
        Alamofire.request(route.url, method: route.method, headers: headers).validate().response { response in
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

        let route = BankrsRouter.getTransactions
        Alamofire.request(route.url, method: route.method, headers: headers)
            .validate()
            .responseJSON { response in
                if response.result.error == nil {
                    debugPrint("HTTP Response Body: \(String(describing: response.data))")
                    if let jsonResult = response.result.value as? [String: Any], let array = jsonResult["data"] as? [Any] {
                        result(array.flatMap { Transaction(json: $0) }, nil)
                    } else {
                        result([], nil)
                    }
                } else {
                    debugPrint("HTTP Request failed: \(String(describing: response.result.error))")
                    result([], response.result.error)
                }
        }
    }

    static func categories(_ result: @escaping ([Int: String], Error?) -> Void) {
        let headers = [
            "X-Application-Id": applicationId
        ]

        let route = BankrsRouter.getCategories
        Alamofire.request(route.url, method: route.method, headers: headers)
            .validate()
            .responseJSON { response in
                if response.result.error == nil {
                    debugPrint("HTTP Response Body: \(String(describing: response.data))")
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
                    debugPrint("HTTP Request failed: \(String(describing: response.result.error))")
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

        let route = BankrsRouter.getBankAccesses
        Alamofire.request(route.url, method: route.method, headers: headers)
            .validate()
            .responseJSON { response in
                if response.result.error == nil {
                    debugPrint("HTTP Response Body: \(String(describing: response.data))")
                    if let jsonAccesses = response.result.value as? [[String: Any]] {
                        let accesses = jsonAccesses.flatMap { return BankAccess(json: $0) }
                        result(accesses, nil)
                        return
                    }
                    result([], nil)
                } else {
                    debugPrint("HTTP Request failed: \(String(describing: response.result.error))")
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

        let route = BankrsRouter.getBankAccess(identifier)
        Alamofire.request(route.url, method: route.method, headers: headers)
            .validate()
            .responseJSON { response in
                if response.result.error == nil {
                    debugPrint("HTTP Response Body: \(String(describing: response.data))")
                    if let jsonAccess = response.result.value {
                        let access = BankAccess(json: jsonAccess)
                        result(access, nil)
                        return
                    }
                    result(nil, nil)
                } else {
                    debugPrint("HTTP Request failed: \(String(describing: response.result.error))")
                    result(nil, response.result.error)
                }
        }
    }

    static func providers(query: String, _ result: @escaping ([Provider], Error?) -> Void) {
        guard let sessionToken = sessionToken else {
            result([], nil)
            return
        }

        let headers = [
            "X-Application-Id": applicationId,
            "X-Token": sessionToken
        ]

        let parameters = [
            "q": query
        ]

        let route = BankrsRouter.getProviders
        Alamofire.request(route.url, method: route.method, parameters: parameters, headers: headers)
            .validate()
            .responseJSON { response in
                if response.result.error == nil {
                    debugPrint("HTTP Response Body: \(String(describing: response.data))")
                    if let jsonResult = response.result.value as? [[String: Any]] {
                        // query results sorted by score
                        let providers = jsonResult.flatMap { Provider(json: $0["provider"]!) }
                        result(providers, nil)
                        return
                    }
                    result([], nil)
                } else {
                    debugPrint("HTTP Request failed: \(String(describing: response.result.error))")
                    result([], response.result.error)
                }
        }
    }

    static func addAccess(providerId: String, answers: [ChallengeAnswer], _ result: @escaping (URL?, Error?) -> Void) {
        guard let sessionToken = sessionToken else {
            result(nil, nil)
            return
        }

        let headers = [
            "X-Application-Id": applicationId,
            "X-Token": sessionToken
        ]

        let parameters: Parameters = [
            "provider_id": providerId,
            "challenge_answers": answers.map { $0.asJSON() }
        ]

        let route = BankrsRouter.createBankAccess
        Alamofire.request(route.url, method: route.method, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                if response.result.error == nil {
                    debugPrint("HTTP Response Body: \(String(describing: response.data))")
                    if let jsonResult = response.result.value as? [String: Any], let jobURI = jsonResult["uri"] as? String {
                        result(URL(string: jobURI, relativeTo: BankrsRouter.baseURL), nil)
                        return
                    }
                    result(nil, nil)
                } else {
                    debugPrint("HTTP Request failed: \(String(describing: response.result.error))")
                    result(nil, response.result.error)
                }
        }
    }

}
