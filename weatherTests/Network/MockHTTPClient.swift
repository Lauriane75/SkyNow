//
//  MockHTTPClient.swift
//  weather
//
//  Created by Lauriane Haydari on 05/05/2020.
//  Copyright © 2020 Lauriane Haydari. All rights reserved.
//

import XCTest
@testable import weather

    // MARK: - Mock

class MockHTTPClient: HTTPClientType {

    func request<T>(type: T.Type, requestType: RequestType, url: URL, cancelledBy token: Token, completion: @escaping (Result<T>) -> Void) where T: Decodable {
        do {
            let data = try Data(contentsOf: url)
            let jsonDecoder = JSONDecoder()
            guard let decodedData = try? jsonDecoder.decode(type.self, from: data) else { return }
            completion(.success(value: decodedData))
        } catch {
            completion(.error(error: error))
        }
    }
}
