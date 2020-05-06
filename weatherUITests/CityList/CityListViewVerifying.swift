//
//  CityListViewVerifying.swift
//  weatherUITests
//
//  Created by Lauriane Haydari on 06/03/2020.
//  Copyright © 2020 Lauriane Haydari. All rights reserved.
//

import XCTest

protocol CityListViewVerifying {

    func cityListViewWaitForExistence()
    func cityListViewExists() -> Bool

    // MARK: - Properties

    var navBarTitle: XCUIElement { get }
    var titleLabel: XCUIElement { get }
    var weatherChanelButton: XCUIElement { get }
    var itemPlus: XCUIElement { get }

}

extension CityListViewVerifying {

//    func cityListViewWaitForExistence() {
//        _ = navBarTitle.waitForExistence(timeout: 1)
//        _ = titleLabel.waitForExistence(timeout: 1)
//        _ = weatherChanelButton.waitForExistence(timeout: 1)
//        _ = itemPlus.waitForExistence(timeout: 1)
//    }
//
//    func cityListViewExists() -> Bool {
//        return navBarTitle.exists
//            && titleLabel.exists
//            && weatherChanelButton.exists
//            && itemPlus.exists
//    }
//
//    // MARK: - Properties
//
//    var navBarTitle: XCUIElement {
//        return XCUIApplication().navigationBar
//        [Accessibility.CityList.navBarTitle].staticTexts[Accessibility.CityList.navBarTitle]
//    }
//
//    var titleLabel: XCUIElement {
//        return XCUIApplication().staticTexts[Accessibility.CityList.titleLabel]
//    }
//
//    var weatherChanelButton: XCUIElement {
//        return   XCUIApplication().buttons[Accessibility.CityList.weatherChanelButton]
//    }
//
//    var itemPlus: XCUIElement {
//        return XCUIApplication().tabBars.buttons["plus.circle"]
//    }

}
