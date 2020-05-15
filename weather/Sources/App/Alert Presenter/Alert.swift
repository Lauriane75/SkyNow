//
//  Alert.swift
//  weather
//
//  Created by Lauriane Haydari on 12/02/2020.
//  Copyright © 2020 Lauriane Haydari. All rights reserved.
//

import Foundation

enum AlertType {
    case errorService
    case nonUniqueCity
    case wrongSpelling
    case userlocation
}

struct Alert {
    let title: String
    let message: String
}

extension Alert {
    init(type: AlertType) {
        switch type {
        case .errorService:
            self = Alert(title: "Error", message: "No internet connection")
        case .nonUniqueCity:
            self = Alert(title: "Same city", message: "You've already added this city")
        case .wrongSpelling:
            self = Alert(title: "Wrong spelling", message: "Make sure there is no space in the city or country name")
        case .userlocation:
            self = Alert(title: "Can't access to your geolocation", message: "Please make sure you allowed this in your settings and get acces to internet")
        }
    }
}
