//
//  HTTPEngine.swift
//  weather
//
//  Created by Lauriane Haydari on 12/02/2020.
//  Copyright © 2020 Lauriane Haydari. All rights reserved.
//

import Foundation

typealias HTTPCompletionHander = (Data?, HTTPURLResponse?, Error?) -> Void

enum URLSessionEngineError: Error {
    case invalidURLResponseType
}

final class HTTPEngine {

    // MARK: - Properties

    private let session: URLSession

    // MARK: - Inputs

    init(configuration: URLSessionConfiguration = .default) {
        self.session = URLSession(configuration: configuration)
    }

    func send(request: URLRequest,
              cancelledBy token: Token,
              callback: @escaping HTTPCompletionHander) {
        let task = session.dataTask(with: request) { (data, urlResponse, _) in
            if urlResponse != nil, let httpURLResponse = urlResponse as? HTTPURLResponse {
                callback(data, httpURLResponse, nil)
            } else {
                callback(data, nil, URLSessionEngineError.invalidURLResponseType)
            }
        }
        task.resume()
        token.willDealocate = {
            task.cancel()
        }
    }

    deinit {
        session.invalidateAndCancel()
    }
}
