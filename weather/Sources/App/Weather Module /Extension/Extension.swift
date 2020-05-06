//
//  Extension.swift
//  weather
//
//  Created by Lauriane Haydari on 12/02/2020.
//  Copyright © 2020 Lauriane Haydari. All rights reserved.
//

import UIKit

extension Int {
    var fahrenheit: Int { return self * 9 / 5 + 32 }
}

extension String {
    var dayPlainTextFormat: String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("HH:mm a")
        dateFormatter.amSymbol = ""
        dateFormatter.pmSymbol = ""
        dateFormatter.locale = Locale(identifier: "en_US")

        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        guard let convertedDate = dateFormatter.date(from: self) else { return "" }
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: convertedDate)
    }

    var hourFormat: String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("HH:mm a")
        dateFormatter.amSymbol = ""
        dateFormatter.pmSymbol = ""
        dateFormatter.locale = Locale(identifier: "en_US")

        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        guard let convertedDate = dateFormatter.date(from: self) else { return "" }
        dateFormatter.dateFormat = "HH"
        return dateFormatter.string(from: convertedDate)
    }

    var dayFormat: String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("HH:mm a")
        dateFormatter.amSymbol = ""
        dateFormatter.pmSymbol = ""
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        guard let convertedDate = dateFormatter.date(from: self) else { return "" }
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: convertedDate)
    }
}

extension StringProtocol {
    var firstCapitalized: String {
        return String(prefix(1)).capitalized + dropFirst()
    }
}

extension UIColor {
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }
    }
}

extension WeatherListItem {
    init(list: List, isCelsius: Bool) {
        self.id = "\(list.id)"
        self.country = list.sys.country.capitalized
        self.nameCity = list.name

        if isCelsius { self.temperature = "\(Int(list.main.temp)) °C"
        } else { self.temperature = "\(Int(list.main.temp).fahrenheit) °F" }
    }
}

extension WeatherListItem {
    init(object: WeatherListObject) {
        self.id = object.idCityListObject ?? ""
        self.country = object.countryCityList?.capitalized ?? ""
        self.nameCity = object.nameCityList?.capitalized ?? ""
        self.temperature = object.tempCityList ?? ""
    }
}

extension CityItem {
    init(object: CityObject) {
        self.id = object.idCity ?? ""
        self.nameCity = object.nameCity?.lowercased() ?? ""
        self.country = object.countryCity?.lowercased() ?? ""
    }
}

extension CityVerif {
    init(object: CityObject) {
        self.nameCity = object.nameCity?.lowercased() ?? ""
        self.country = object.countryCity?.lowercased() ?? ""
    }
}

extension WeatherWeekItem {
    init(list: ListElement, city: CityElement, isCelsius: Bool) {
        self.cityId = "\(city.id)"
        self.nameCity = city.name
        self.time = list.dtTxt
        self.iconID = list.weather.first?.icon ?? "01d"
        self.pressure = "\(list.main.pressure) hPa"
        self.humidity = "\(list.main.humidity) %"
        self.description = list.weather.first?.weatherDescription ?? "sunny"

        if isCelsius {
            self.feelsLike = "\(Int(list.main.feelsLike)) °C"
            self.temperature = "\(Int(list.main.temp)) °C"
            self.temperatureMin = "\(Int(list.main.tempMin)) °C"
            self.temperatureMax = "\(Int(list.main.tempMax)) °C"
        } else {
            self.feelsLike = "\(Int(list.main.feelsLike).fahrenheit) °F"
            self.temperature = "\(Int(list.main.temp).fahrenheit) °F"
            self.temperatureMin = "\(Int(list.main.tempMin).fahrenheit) °F"
            self.temperatureMax = "\(Int(list.main.tempMax).fahrenheit) °F"
        }
    }
}

extension WeatherWeekItem {
    init(object: WeatherWeekObject) {
        self.cityId = object.cityIDWeek ?? ""
        self.nameCity = object.nameCityWeek ?? ""
        self.time = object.timeWeek ?? ""
        self.iconID = object.iconIDWeek ?? ""
        self.temperature = object.tempWeek ?? ""
        self.temperatureMin = object.tempMinWeek ?? ""
        self.temperatureMax = object.tempMinWeek ?? ""
        self.pressure = object.pressureWeek ?? ""
        self.humidity = object.humidityWeek ?? ""
        self.feelsLike = object.feelsLikeWeek ?? ""
        self.description = object.descriptionWeek ?? ""
    }
}
