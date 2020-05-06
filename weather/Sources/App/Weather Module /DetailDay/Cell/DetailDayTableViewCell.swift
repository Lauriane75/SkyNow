//
//  DetailWeatherTableViewCell.swift
//  weather
//
//  Created by Lauriane Haydari on 12/02/2020.
//  Copyright © 2020 Lauriane Haydari. All rights reserved.
//

import UIKit

final class DetailDayTableViewCell: UITableViewCell {

    // MARK: - Outlet

    @IBOutlet private weak var tempMinLabel: UILabel!
    @IBOutlet private weak var tempMaxLabel: UILabel!
    @IBOutlet private weak var pressureLabel: UILabel!
    @IBOutlet private weak var feelsLikeLabel: UILabel!
    @IBOutlet private weak var humidityLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!

    // MARK: - Configure

    func configure(with visibleWeather: WeatherWeekItem) {
        pressureLabel.text = visibleWeather.pressure
        feelsLikeLabel.text = visibleWeather.feelsLike
        humidityLabel.text = visibleWeather.humidity
        timeLabel.text = "\(visibleWeather.time.hourFormat)h"
        tempMinLabel.text = visibleWeather.temperatureMin
        tempMaxLabel.text = visibleWeather.temperatureMax
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        tempMinLabel.text = nil
        tempMaxLabel.text = nil
        pressureLabel.text = nil
        feelsLikeLabel.text = nil
        humidityLabel.text = nil
        timeLabel.text = nil
    }
}
