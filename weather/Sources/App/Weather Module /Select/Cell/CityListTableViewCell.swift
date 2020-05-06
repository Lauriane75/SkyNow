//
//  CityTableViewCell.swift
//  weather
//
//  Created by Lauriane Haydari on 02/03/2020.
//  Copyright © 2020 Lauriane Haydari. All rights reserved.
//

import UIKit

final class CityListTableViewCell: UITableViewCell {

    // MARK: - Outlet

    @IBOutlet weak var cityLabel: UILabel!

    @IBOutlet weak var countryLabel: UILabel!

    @IBOutlet weak var tempLabel: UILabel!

    // MARK: - Configure

    func configure(with visibleWeather: WeatherListItem) {
        cityLabel.text = visibleWeather.nameCity
        countryLabel.text = visibleWeather.country
        tempLabel.text = visibleWeather.temperature
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        cityLabel.text = nil
        countryLabel.text = nil
        tempLabel.text = nil
    }
}
