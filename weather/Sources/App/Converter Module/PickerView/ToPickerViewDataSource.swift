//
//  ToPickerViewDataSource.swift
//  weather
//
//  Created by Lauriane Haydari on 17/05/2020.
//  Copyright © 2020 Lauriane Haydari. All rights reserved.
//

import UIKit

final class ToPickerViewDataSource: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: - Properties

    var items: [String] = []

    var name: String = ""

    var frenchName: String = ""

    // MARK: - Public

    func update(with items: [String]) {
        self.items = items
    }

    var didSelectItemAt: ((Int) -> Void)?

    // MARK: - UIPickerViewDataSource

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        return items.count
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int,
                    forComponent component: Int, reusing view: UIView?) -> UIView {

        name = items[row]

        setItemName(index: row)

        var label = UILabel()

        customLabel(view, &label)

        label.text = frenchName

        return label
    }

    // MARK: - UIPickerViewDelegate

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        didSelectItemAt?(row)
    }

    // MARK: - Private Functions

    fileprivate func customLabel(_ view: UIView?, _ label: inout UILabel) {
        if let uiLabel = view {
            label = uiLabel as! UILabel
        }

        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .white
        label.textAlignment = .center
    }

    private func setItemName(index: Int) {
        if name == "EUR" {
            frenchName = "Euro €"
        }
        if name == "USD" {
            frenchName = "Dollar Américain $"
        }
        if name == "GBP" {
            frenchName = "Livre Sterling £"
        }
        if name == "JPY" {
            frenchName = "Yen ¥"
        }
    }
}
// if you need other currencies
//        if name == "AED" {
//            frenchName = "Dirham des Émirats Arabes Unis"
//        }
//        if name == "AFN" {
//            frenchName = "Afghani Afghan"
//        }
//        if name == "ALL" {
//            frenchName = "Lek Albanais"
//        }
//        if name == "AMD" {
//            frenchName = "Dram Arménien"
//        }
//        if name == "ANG" {
//            frenchName = "Florin Néerlandais"
//        }
//        if name == "AOA" {
//            frenchName = "Kwanza Angola"
//        }
//        if name == "ARS" {
//            frenchName = "Kwanza Angolais"
//        }
//        if name == "AUD" {
//            frenchName = "Dollar Australien"
//        }
//        if name == "AWG" {
//            frenchName = "Florin Arubais"
//        }
//        if name == "AZN" {
//            frenchName = "Azerbaïdjan Manat d'Azerbaïdjan"
//        }
//        if name == "BAM" {
//            frenchName = "Bosnie-Herzégovine Mark convertible"
//        }
//        if name == "BBD" {
//            frenchName = "Dollar barbadien"
//        }
//        if name == "BDT" {
//            frenchName = "Bangladesh Taka"
//        }
//        if name == "BGN" {
//            frenchName = "Bulgarie Lev"
//        }
//        if name == "BHD" {
//            frenchName = "Bahreïn Dinar du Bahreïn"
//        }
//        if name == "BIF" {
//            frenchName = "Burundi Franc du Burundi"
//        }
//        if name == "BMD" {
//            frenchName = "Bermudes Dollar bermudien"
//        }
//        if name == "BND" {
//            frenchName = "Brunei Dollar de Brunei"
//        }
//        if name == "BOB" {
//            frenchName = "Bolivie Boliviano"
//        }
//        if name == "BRL" {
//            frenchName = "Brésil Réal"
//        }
//        if name == "BTC" {
//            frenchName = "Bitcoin Bitcoin"
//        }
//        if name == "BTN" {
//            frenchName = "Bhoutan Ngultrum"
//        }
//        if name == "BWP" {
//            frenchName = "Botswana Pula"
//        }
//        if name == "BYN" {
//            frenchName = "Rouble biélorusse"
//        }
//        if name == "BZD" {
//            frenchName = "Dollar Bélizien"
//        }
//        if name == "CAD" {
//            frenchName = " Dollar Canadien"
//        }
//        if name == "CDF" {
//            frenchName = "Franc Congolais"
//        }
//        if name == "CHF" {
//            frenchName = "Franc suisse"
//        }
//        if name == "CLP" {
//            frenchName = "Peso Chilien"
//        }
//        if name == "CNY" {
//            frenchName = "Renminbi"
//        }
//        if name == "COP" {
//            frenchName = "Peso Colombien"
//        }
//        if name == "CRC" {
//            frenchName = "Colón Costaricien"
//        }
//        if name == "CUP" {
//            frenchName = "Peso Cubain"
//        }
//        if name == "CVE" {
//            frenchName = "Escudo Cap-Verdien"
//        }
//        if name == "CZK" {
//            frenchName = "Couronne Tchèque"
//        }
//        if name == "DJF" {
//            frenchName = "Franc Djibouti"
//        }
//        if name == "DKK" {
//            frenchName = "Couronne Danoise"
//        }
//        if name == "DOP" {
//            frenchName = "Peso dominicain"
//        }
//        if name == "DZD" {
//            frenchName = "Dinar Algérien"
//        }
//        if name == "EGP" {
//            frenchName = "Livre Égyptienne"
//        }
//        if name == "ERN" {
//            frenchName = "Nakfa Érythréen"
//        }
//        if name == "ETB" {
//            frenchName = "Birr de l'Éthiopie"
//        }
//        if name == "FJD" {
//            frenchName = "Dollar de Fidji"
//        }
//        if name == "FKP" {
//            frenchName = "Livre des Îles Malouines"
//        }
//        if name == "GEL" {
//            frenchName = "Lari de Géorgie"
//        }
//        if name == "GHS" {
//            frenchName = "Cédi du Ghana"
//        }
//        if name == "GIP" {
//            frenchName = "Livre de Gibraltar"
//        }
//        if name == "GMD" {
//            frenchName = "Dalasi de la Gambie"
//        }
//        if name == "GNF" {
//            frenchName = "Franc Guinéen"
//        }
//        if name == "GTQ" {
//            frenchName = "Quetzal Guatémaltèque"
//        }
//        if name == "GYD" {
//            frenchName = "Dollar guyanien"
//        }
//        if name == "HKD" {
//            frenchName = "Dollar de Hong Kong"
//        }
//        if name == "HNL" {
//            frenchName = "Lempira Hondurien"
//        }
//        if name == "HRK" {
//            frenchName = "Kuna Croate"
//        }
//        if name == "HTG" {
//            frenchName = "Gourde d'Haïti"
//        }
//        if name == "HUF" {
//            frenchName = "Forint Hongrois"
//        }
//        if name == "IDR" {
//            frenchName = "Roupie indonésienne"
//        }
//        if name == "ILS" {
//            frenchName = "Shekel d’Israël"
//        }
//        if name == "INR" {
//            frenchName = "Roupie Indienne"
//        }
//        if name == "IQD" {
//            frenchName = "Dinar irakien"
//        }
//        if name == "IRR" {
//            frenchName = "Rial Iranien"
//        }
//        if name == "ISK" {
//            frenchName = "Couronne islandaise"
//        }
//        if name == "JEP" {
//            frenchName = "Livre de Jersey"
//        }
//        if name == "JMD" {
//            frenchName = "Burundi Franc du Burundi"
//        }
//        if name == "JOD" {
//            frenchName = "Dinar jordanien"
//        }
//        if name == "KES" {
//            frenchName = "Shilling Kényan"
//        }
//        if name == "KGS" {
//            frenchName = "Som du Kirghizistan"
//        }
//        if name == "KHR" {
//            frenchName = "Riel"
//        }
//        if name == "KMF" {
//            frenchName = "Franc Comorien"
//        }
//        if name == "KPW" {
//            frenchName = "Won Nord-Coréen"
//        }
//        if name == "KRW" {
//            frenchName = "Won Sud-Coréen"
//        }
//        if name == "KWD" {
//            frenchName = "Dinar Koweïtien"
//        }
//        if name == "KYD" {
//            frenchName = "Dollar des îles Caïmans"
//        }
//        if name == "KZT" {
//            frenchName = "Tenge Kazakh"
//        }
//        if name == "LAK" {
//            frenchName = "Kip Laotien"
//        }
//        if name == "LBP" {
//            frenchName = "Livre libanaise"
//        }
//        if name == "LKR" {
//            frenchName = "Roupie Srilankaise"
//        }
//        if name == "LSL" {
//            frenchName = "Loti de Lesotho"
//        }
//        if name == "LTL" {
//            frenchName = "Litas Lituanien"
//        }
//        if name == "LVL" {
//            frenchName = "Lats de Lettonie"
//        }
//        if name == "LYD" {
//            frenchName = "Dinar Libyen"
//        }
//        if name == "MAD" {
//            frenchName = "Dirham Marocain"
//        }
//        if name == "MDL" {
//            frenchName = "Leu `Moldave"
//        }
//        if name == "MGA" {
//            frenchName = "Ariary de Madagascar"
//        }
//        if name == "MKD" {
//            frenchName = "Denar Macédonien"
//        }
//        if name == "MMK" {
//            frenchName = "Kyat de Myanmar"
//        }
//        if name == "MNT" {
//            frenchName = "Tugrik de Mongolie"
//        }
//        if name == "MOP" {
//            frenchName = "Pataca"
//        }
//        if name == "MRO" {
//            frenchName = "Ouguiya"
//        }
//        if name == "MUR" {
//            frenchName = "Roupie Mauricienne"
//        }
//        if name == "MVR" {
//            frenchName = "Rufiyaa"
//        }
//        if name == "MWK" {
//            frenchName = "Kwacha Malawien"
//        }
//        if name == "MXN" {
//            frenchName = "Peso Mexicain"
//        }
//        if name == "MYR" {
//            frenchName = "Ringgit"
//        }
//        if name == "MZN" {
//            frenchName = "Metical"
//        }
//        if name == "NAD" {
//            frenchName = "Naira"
//        }
//        if name == "NGN" {
//            frenchName = "Brunei Dollar de Brunei"
//        }
//        if name == "NIO" {
//            frenchName = "Couronne Norvégienne"
//        }
//        if name == "NOK" {
//            frenchName = "Brésil Réal"
//        }
//        if name == "NPR" {
//            frenchName = "Roupie Népalaise"
//        }
//        if name == "NZD" {
//            frenchName = "Dollar Néo-zélandais"
//        }
//        if name == "OMR" {
//            frenchName = "Rial Omanais"
//        }
//        if name == "PAB" {
//            frenchName = "Balboa"
//        }
//        if name == "PEN" {
//            frenchName = "Sol Péruvien"
//        }
//        if name == "PGK" {
//            frenchName = "Kina"
//        }
//        if name == "PHP" {
//            frenchName = "Peso Philippin"
//        }
//        if name == "PKR" {
//            frenchName = "Roupie Pakistanaise"
//        }
//        if name == "PLN" {
//            frenchName = "Złoty"
//        }
//        if name == "PYG" {
//            frenchName = "Guaraní"
//        }
//        if name == "QAR" {
//            frenchName = "Riyal Qatarien"
//        }
//        if name == "RON" {
//            frenchName = "Dinar Serbe"
//        }
//        if name == "RSD" {
//            frenchName = "Bhoutan Ngultrum "
//        }
//        if name == "RUB" {
//            frenchName = "Rouble Russe"
//        }
//        if name == "RWF" {
//            frenchName = "Franc Rwandais"
//        }
//        if name == "SAR" {
//            frenchName = "Riyal Saoudien"
//        }
//        if name == "SBD" {
//            frenchName = "Dollar des Salomon"
//        }
//        if name == "SCR" {
//            frenchName = "Roupie Seychelloise"
//        }
//        if name == "SDG" {
//            frenchName = "Livre Soudanaise"
//        }
//        if name == "SEK" {
//            frenchName = "Couronne Suédoise"
//        }
//        if name == "SGD" {
//            frenchName = "Dollar de Singapour"
//        }
//        if name == "SLL" {
//            frenchName = "Leone de Sierra Leone"
//        }
//        if name == "SOS" {
//            frenchName = "Shilling Somalien"
//        }
//        if name == "SRD" {
//            frenchName = "Dollar du Suriname"
//        }
//        if name == "STD" {
//            frenchName = "Dobra de Sao Tomé-et-Principe"
//        }
//        if name == "SVC" {
//            frenchName = "Colon Salvadorien"
//        }
//        if name == "SYP" {
//            frenchName = "Livre syrienne"
//        }
//        if name == "SZL" {
//            frenchName = "Baht de Thaïlande"
//        }
//        if name == "THB" {
//            frenchName = "Bermudes Dollar bermudien "
//        }
//        if name == "TJS" {
//            frenchName = "Somoni du Tadjikistan"
//        }
//        if name == "TMT" {
//            frenchName = "Manat Turkmène"
//        }
//        if name == "SHP" {
//            frenchName = "Livre de Sainte-Hélène"
//        }
//        if name == "TND" {
//            frenchName = "Dinar tunisien"
//        }
//        if name == "TRY" {
//            frenchName = "Livre turque"
//        }
//        if name == "TTD" {
//            frenchName = "Dollar de Trinité-et-Tobago"
//        }
//        if name == "TWD" {
//            frenchName = "Nouveau dollar de Taïwan"
//        }
//        if name == "TZS" {
//            frenchName = "Shilling tanzanien"
//        }
//        if name == "UAH" {
//            frenchName = "Hryvnia d’Ukraine"
//        }
//        if name == "UGX" {
//            frenchName = "Shilling Ougandais"
//        }
//        if name == "UYU" {
//            frenchName = "Peso Uruguayen"
//        }
//        if name == "VND" {
//            frenchName = "Dong Vietnamien"
//        }
//        if name == "VUV" {
//            frenchName = "Vatu Vanuatu"
//        }

//        if name == "XAF" {
//            frenchName = "Franc CFA"
//        }

//        if name == "XCD" {
//            frenchName = "Bermudes Dollar bermudien"
//        }
//        if name == "XOF" {
//            frenchName = "Franc CFA"
//        }
//        if name == "XPF" {
//            frenchName = "Franc Pacifique"
//        }
//        if name == "YER" {
//            frenchName = "Riyal yéménite"
//        }
//        if name == "ZAR" {
//            frenchName = "Rand Sud Africain"
//        }
