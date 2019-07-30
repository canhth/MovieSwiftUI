//
//  NetworkClient.swift
//  CTNetworking
//
//  Created by Canh Tran Wizeline on 5/5/19.
//  Copyright © 2019 Canh Tran. All rights reserved.
//

import Foundation
import Combine

/// A definition of a NetworkClient
protocol NetworkRequestable {
    init(session: URLSession)
    func fetch<T>(request: URLRequest) -> NetworkClient.NetworkClientResponse<T> where T: Decodable
}

/// A type represents network client
struct NetworkClient: NetworkRequestable {
    
    typealias NetworkClientResponse<T> = AnyPublisher<Result<T, NetworkError>, Never>
    typealias PublisherFlatMap = Publishers.FlatMap<AnyPublisher<Data, NetworkError>, Publishers.MapError<URLSession.DataTaskPublisher, NetworkError>>
    
    private enum StatusCodes: Int {
        case OK = 200
        case MultipleChoices = 300
    }
    
    private let session: URLSession
    
    /// Creates an instance of network client
    ///
    /// - Parameter session: The URLSession that coordinates a group of related network data transfer tasks
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
 
    /// Fetches a network request with a relevant decodable type to decode the response.
    ///
    /// - Parameters:
    ///   - request: The request to fetch
    ///   - decode: The decode closure that expects a `Decodable` object and returns a relevant type
    func fetch<T>(request: URLRequest) -> NetworkClient.NetworkClientResponse<T> where T: Decodable {
        let dataTaskPublisher = session.dataTaskPublisher(for: request)
            .mapError { NetworkError.fetchError(error: $0) }
            .flatMap { (data, response) -> AnyPublisher<Data, NetworkError> in
                guard let httpResponse = response as? HTTPURLResponse else { return .fail(.invalidResponse) }
                guard StatusCodes.OK.rawValue..<StatusCodes.MultipleChoices.rawValue ~= httpResponse.statusCode else {
                    return .fail(.noSuccessResponse(code: httpResponse.statusCode))
                }
                return .just(data)
        }
        return decodingTask(dataTaskPublisher: dataTaskPublisher, decodingType: T.self)
    }
    
    /// Decoding data into the Decodable model
    /// - Parameter data: data response
    /// - Parameter decodingType: `Decodable` object type
    private func decodingTask<T: Decodable>(dataTaskPublisher: PublisherFlatMap, decodingType: T.Type) -> NetworkClientResponse<T> {
        dataTaskPublisher.decode(type: T.self, decoder: JSONDecoder())
            .map { Result<T, NetworkError>.success($0) }
            .catch { (error) -> NetworkClientResponse<T> in
                return .just(.failure(.fetchError(error: error)))
        }
        .eraseToAnyPublisher()
    }
    
    /// Fetches a network request then parse the response with `JSONSerialization`
    ///
    /// - Parameters:
    ///   - request: The request to fetch
    ///   - completion: The completion handler of the request
    func fetch(request: URLRequest, completion: @escaping(JSON?, NetworkError?) -> Void) {
        let task = session.dataTask(with: request) { data, _, _ in
            guard let data = data else {
                completion(nil, .emptyResponse)
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? JSON
                completion(json, nil)
            } catch {
                completion(nil, .badDeserialization)
            }
        }
        task.resume()
    } 
}

extension NetworkClient {
    
    /// Build an URLRequest with queryItems, use for GET method
    ///
    /// FYI: on iOS13, it is not allowed to add a body in GET request: https://stackoverflow.com/a/56973866/3933094
    /// - Parameter endpoint: An instance of `Endpoint`
    /// - Parameter queryItems: The list of query items (parameters)
    func buildRequest(from endpoint: Endpoint, queryItems: [URLQueryItem]) -> URLRequest? {
        guard let urlString = endpoint.urlComponents?.url?.absoluteString else { return nil }
        
        var components = URLComponents(string: urlString)
        components?.queryItems = queryItems
        
        guard let url = components?.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        endpoint.headers.forEach { request.addValue( $0.value, forHTTPHeaderField: $0.key) }
        
        return request
    }
    
    /// Build an URLRequest that can use with HTTPBody
    ///
    /// - Parameters:
    ///   - endpoint: An instance of `Endpoint`
    ///   - requestHeaders: The info of request's HTTP header
    ///   - requestBody: The request body
    /// - Returns: An URLRequest
    func buildRequest(from endpoint: Endpoint,
                      requestBody: Data?) -> URLRequest? {
        guard let url = endpoint.urlComponents?.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        endpoint.headers.forEach { request.addValue( $0.value, forHTTPHeaderField: $0.key) }
        request.httpBody = requestBody
        return request
    }
     
    /// Converts a JSON object into Data to use as the HTTPBody
    ///
    /// - Parameter parameters: The parameters to be converted
    /// - Returns: The converted data
    func parametersToHttpBody(_ parameters: JSON) -> Data? {
        let data = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        return data
    }
}
