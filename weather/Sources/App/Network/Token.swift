//
//  RequestCancelationToken.swift
//  weather
//
//  Created by Lauriane Haydari on 12/02/2020.
//  Copyright © 2020 Lauriane Haydari. All rights reserved.
//

import Foundation

final class Token {

    init() {}

    deinit {
        willDealocate?()
    }

    var willDealocate:(() -> Void)?
}
