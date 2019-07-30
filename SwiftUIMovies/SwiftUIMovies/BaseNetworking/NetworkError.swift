//
//  NetworkError.swift
//  CTNetworking
//
//  Created by Canh Tran Wizeline on 5/5/19.
//  Copyright © 2019 Canh Tran. All rights reserved.
//

import Foundation 

enum NetworkError: Error {
    /// Unable to generate the URL request for the given options.
    case unableToGenerateURLRequest
    
    /// Expected deserialization of the response failed.
    case badDeserialization
    
    /// The parser was unable to parse the received response.
    case unableToParse
    
    /// There was an empty response from the network
    case emptyResponse
    
    /// There was an invalid response from the network
    case invalidResponse
    
    /// Unable to fetch with the specified underlying error.
    case fetchError(error: Error)
    
    /// The status code does not indicate success for the specified response.
    case noSuccessResponse(code: Int)
}

extension NetworkError {
    // swiftlint:disable line_length
    var localizedDescription: String {
        switch self {
        case .badDeserialization:
            return NSLocalizedString("Deserialization failed.", comment: "Expected deserialization of the response failed.")
        case .unableToParse:
            return NSLocalizedString("Parsing failed.", comment: "The parser was unable to parse the received response")
        case .emptyResponse:
            return NSLocalizedString("Fetch error. Found empty response.", comment: "There was an empty response from the network.")
        case .invalidResponse:
            return NSLocalizedString("Fetch error. Found invalid response.", comment: "There was an invalid response from the network.")
        case .noSuccessResponse(let code):
            return NSLocalizedString("Server did not return success status. Code: \(code)", comment: "The status code does not indicate success for the specified response.")
        case .fetchError(let error):
            return String(format: NSLocalizedString("Error occured. No item found in local cache. Error: %@", comment: "Unable to fetch with the specified underlying error."), "\(error)")
        case .unableToGenerateURLRequest:
            return NSLocalizedString("Unable to generate the URL request for the given options.", comment: "Unable to generate the URL request for the given options.")
        }
    }
}
