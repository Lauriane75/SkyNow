//
//  Accessibility.swift
//  weatherUITests
//
//  Created by Lauriane Haydari on 17/02/2020.
//  Copyright © 2020 Lauriane Haydari. All rights reserved.
//

import Foundation

// Make sure this file is updated!

enum Accessibility {

    enum HomeWeatherView {
        static let parisText = "Paris"
        static let nowText = "Now"
        // change the tempText according to the temperature now displayed
        static let tempText = "10 °C"

        // change the selectedDayText and the selectedTempText in which weather's day you want to test
        static let selectedDayText = "Saturday"
        static let selectedTempText = "9 °C"
    }

    enum DetailWeatherDayView {
        // change the descriptionText according to the description of the weahter's day displayed
        static let descriptionText = "Broken clouds"
    }
}
