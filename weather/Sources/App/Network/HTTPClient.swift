//
//  HTTPClient.swift
//  weather
//
//  Created by Lauriane Haydari on 12/02/2020.
//  Copyright © 2020 Lauriane Haydari. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(value: T)
    case error(error: Error)
}

enum NetworkError: Error {
    case unknown
}

protocol HTTPClientType {
    func request<T>(type: T.Type,
                    requestType: RequestType,
                    url: URL,
                    cancelledBy token: Token,
                    completion: @escaping (Result<T>) -> Void) where T: Decodable
}

enum RequestType: String {
    case GET
    case POST
}

final class HTTPClient: HTTPClientType {

    // MARK: - Properties

    private let engine: HTTPEngine

    private let jsonDecoder: JSONDecoder

    // MARK: - Initializer

    init(engine: HTTPEngine = HTTPEngine.init(configuration: .default)) {
        self.engine = engine
        self.jsonDecoder = JSONDecoder()
    }

    func request<T>(type: T.Type,
                    requestType: RequestType,
                    url: URL,
                    cancelledBy token: Token,
                    completion: @escaping (Result<T>) -> Void) where T: Decodable {
        var request = URLRequest(url: url)
        request.httpMethod = requestType.rawValue
        engine.send(request: request, cancelledBy: token) { (data, _, error) in
            if let error = error {
                completion(.error(error: error))
            } else if let data = data {
                guard let weather = try? self.jsonDecoder.decode(T.self, from: data) else { return }
                completion(.success(value: weather))
            } else {
                completion(.error(error: NetworkError.unknown))
            }
        }
    }
}
