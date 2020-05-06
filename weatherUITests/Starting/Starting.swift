//
//  Starting.swift
//  weatherUITests
//
//  Created by Lauriane Haydari on 17/02/2020.
//  Copyright © 2020 Lauriane Haydari. All rights reserved.
//

import XCTest

protocol AppStarting {
    func startApp()
}

extension AppStarting {
    func startApp() {
        XCUIApplication().launch()
    }
}
