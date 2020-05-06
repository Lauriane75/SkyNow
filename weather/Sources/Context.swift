//
//  Context.swift
//  weather
//
//  Created by Lauriane Haydari on 12/02/2020.
//  Copyright © 2020 Lauriane Haydari. All rights reserved.
//

import Foundation

final class Context {

    let client: HTTPClientType
    let stack: CoreDataStack

    init(client: HTTPClientType, stack: CoreDataStack) {
        self.client = client
        self.stack = stack
    }
}
