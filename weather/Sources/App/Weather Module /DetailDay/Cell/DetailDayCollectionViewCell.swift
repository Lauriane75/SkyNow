//
//  DetailWeatherCollectionViewCell.swift
//  weather
//
//  Created by Lauriane Haydari on 12/02/2020.
//  Copyright © 2020 Lauriane Haydari. All rights reserved.
//

import UIKit

final class DetailDayCollectionViewCell: UICollectionViewCell {

    // MARK: - Outlet

    @IBOutlet private weak var timeLabel: UILabel!

    @IBOutlet private weak var iconImageView: UIImageView!

    @IBOutlet private weak var tempLabel: UILabel!

    // MARK: - Configure

    func configure(with visibleWeather: WeatherWeekItem) {
        timeLabel.text = "\(visibleWeather.time.hourFormat)h"
        iconImageView.image = UIImage(named: visibleWeather.iconID)
        tempLabel.text = visibleWeather.temperature
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        timeLabel.text = nil
        iconImageView.image = nil
        tempLabel.text = nil
    }
}
