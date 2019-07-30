//
//  APIEndpoint.swift
//  CTNetworking
//
//  Created by Canh Tran Wizeline on 5/5/19.
//  Copyright © 2019 Canh Tran. All rights reserved.
//

import Foundation 

typealias JSON = [String: Any]
typealias HTTPHeaders = [String: String]

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}

/// A definition of an valid endpoint to create a URLRequest
protocol Endpoint {
    var base: String { get }
    var environment: String { get }
    var path: String { get }
    var headers: HTTPHeaders { get }
    var parameters: Any { get }
    var method: HTTPMethod { get }
}

extension Endpoint {
    
    var headers: HTTPHeaders {
        return ["Accept": "application/json"]
    }
    
    /// Default environment
    var environment: String {
        return ""
    }
    
    /// Default parameters
    var parameters: Any {
        return ["": ""]
    }
    
    /// A computed property to return a instance of a URLComponents
    var urlComponents: URLComponents? {
        guard var url = URL(string: base) else { return nil }
        url.appendPathComponent(environment)
        url.appendPathComponent(path)
        
        return URLComponents(url: url, resolvingAgainstBaseURL: false)
    }
}
