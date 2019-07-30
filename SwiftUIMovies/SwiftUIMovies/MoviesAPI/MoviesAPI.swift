//
//  MoviesAPI.swift
//  SwiftUIMovies
//
//  Created by Canh Tran Wizeline on 7/29/19.
//  Copyright © 2019 Canh Tran. All rights reserved.
//

import Foundation
import Combine

enum MoviesAPI {
    case fetchData
}

extension MoviesAPI: Endpoint {
    
    typealias MovieAPIResponse = AnyPublisher<Result<PaginatedResponse<Movie>, NetworkError>, Never>
    
    // MARK: Confirm protocol Endpoint
    var method: HTTPMethod {
        return .get
    }
    
    var base: String {
        return "https://api.themoviedb.org/3/"
    }
    
    var path: String {
        switch self {
        case .fetchData: return "movie/popular"
        }
    }
    
    var parameters: Any {
        switch self {
        case .fetchData:
            return [
                URLQueryItem(name: "api_key", value: Keys.apiKey),
                URLQueryItem(name: "language", value: Locale.preferredLanguages[0]),
                URLQueryItem(name: "page", value: "\(1)")
            ]
        }
    }
    
    var headers: HTTPHeaders {
        return ["Content-Type": "application/json"]
    }
    
    func fetchMovies(at page: Int) -> MovieAPIResponse {
        
        guard let queryItems = self.parameters as? [URLQueryItem] else { return .empty() }
                
        let networkClient = NetworkClient()
        guard let request = networkClient.buildRequest(from: self, queryItems: queryItems) else { return .empty() }
        return networkClient.fetch(request: request)
            .eraseToAnyPublisher()
    }
    
}
