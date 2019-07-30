//
//  AuthenticationAPI.swift
//  CTNetworking
//
//  Created by Canh Tran Wizeline on 5/5/19.
//  Copyright © 2019 Canh Tran. All rights reserved.
//

import Foundation
import Combine

enum Authentication {
    case signUp(email: String, password: String, grantType: String)
    case logIn(email: String, password: String)
}

extension Authentication: Endpoint {
    
    typealias LoginResponse = AnyPublisher<Result<Login, NetworkError>, Never>
    typealias SignUpResponse = AnyPublisher<Result<SignUp, NetworkError>, Never>
    
    // MARK: Confirm protocol Endpoint
    var method: HTTPMethod {
        return .post
    }
    
    var base: String {
        return "https://nimble-survey-api.herokuapp.com"
    }
    
    var path: String {
        switch self {
        case .logIn: return "/oauth/token"
        case .signUp: return "/oauth/token"
        }
    }
    
    var parameters: Any {
        switch self {
        case let .logIn(email, password):
            return ["email": email,
                    "password": password]
            
        case let .signUp(email, password, _):
            var urlParser = URLComponents()
            urlParser.queryItems = [
                URLQueryItem(name: "email", value: email),
                URLQueryItem(name: "password", value: password),
                URLQueryItem(name: "grant_type", value: "password")
            ]
            return urlParser
        }
    }
    
    var headers: HTTPHeaders {
        return ["Content-Type": "application/x-www-form-urlencoded"]
    }
    
    /// Creates a new user account
    ///
    /// - Parameters:
    ///   - email: The user's email, which is the username after a successful signup
    ///   - password: The user's password
    ///   - parameters: The additional parameters that will be attached to the request
    ///   - completion: The completion handler
    func signUp() -> SignUpResponse {
         
        guard let urlParser = self.parameters as? URLComponents else { return .empty() }
        
        let requestBody = urlParser.percentEncodedQuery?.data(using: .utf8)
        let networkClient = NetworkClient()
        guard let request = networkClient.buildRequest(from: self,
                                         requestBody: requestBody) else { return .empty() }
        return networkClient.fetch(request: request)
            .eraseToAnyPublisher()
    }
    
}

extension NetworkClient {
    
//    /// Login with username and password
//    ///
//    /// - Parameters:
//    ///   - email: The user's email/username
//    ///   - password: The user's password
//    ///   - parameters: The additional parameters for the request
//    ///   - completion: The completion handler
//    func logIn(email: String,
//               password: String,
//               parameters: JSON?,
//               completion: @escaping (Result<Login, NetworkError>) -> Void) {
//
//        let endpoint: Authentication = .logIn
//
//        let data = "grant_type=password&password=\(password)&username=\(email)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
//        let requestBody = data?.data(using: .utf8)
//
//        guard let request = buildRequest(from: endpoint,
//                                         requestBody: requestBody) else { return }
//
//        fetch(request: request, decode: { (loginResult) -> Login? in
//            return loginResult as? Login
//        }, completion: completion)
//    }
}
