//
//  StoreKIt.swift
//  weather
//
//  Created by Lauriane Haydari on 03/06/2020.
//  Copyright © 2020 Lauriane Haydari. All rights reserved.
//

import StoreKit

enum AppStoreReviewManager {
    static func requestReviewIfAppropriate() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else {
            print("version under 10.3")
        }
    }
}
