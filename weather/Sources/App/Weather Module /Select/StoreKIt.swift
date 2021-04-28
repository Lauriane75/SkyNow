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
        if #available(iOS 14.0, *) {
            if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
            }
        } else {
            SKStoreReviewController.requestReview()
        }
    }
}
