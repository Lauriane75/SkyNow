//
//  ConverterRepository.swift
//  weather
//
//  Created by Lauriane Haydari on 16/05/2020.
//  Copyright © 2020 Lauriane Haydari. All rights reserved.
//

import Foundation

protocol ConverterRepositoryType: class {
    func getCurrency(callback: @escaping (Result<Currency>) -> Void, onError: @escaping (String) -> Void)
}

final class ConverterRepository: ConverterRepositoryType {

    // MARK: - Properties

    private let client: HTTPClientType

    private let token = Token()

    // MARK: - Initializer

    init(client: HTTPClientType) {
        self.client = client
    }

    // MARK: - Requests

    func getCurrency(callback: @escaping (Result<Currency>) -> Void, onError: @escaping (String) -> Void) {
        let apiKey = "5f3d531bcfe0d265036a1aa20e889301&format=1&base=EUR&symbols=EUR,USD,GBP,JPY"
        let stringUrl = "http://data.fixer.io/api/latest?access_key=\(apiKey)"
        guard let url = URL(string: stringUrl) else { return }
        client.request(type: Currency.self,
                       requestType: .GET,
                       url: url,
                       cancelledBy: token) { currency in
                        switch currency {
                        case .success(value: let currencyItem):
                            let result: Currency = currencyItem
                            callback(.success(value: result))
                        case .error(error: let error):
                            onError(error.localizedDescription)
                        }
        }
    }
}
