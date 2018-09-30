//
//  CurrencyData.swift
//  Rates
//
//  Created by Anton Pomozov on 30/09/2018.
//  Copyright © 2018 Anton Pomozov. All rights reserved.
//

import UIKit
import SwiftyJSON

extension Currency {

    static var data: CurrencyData {
        guard let asset = NSDataAsset(name: "CurrencyData", bundle: Bundle.main),
            let json = try? JSON(data: asset.data),
            let countries = json.dictionary
            else { return [:] }

        return countries.reduce(into: [:]) { result, country in
            guard let countryCode = country.value["Country"].string else { return }
            guard let currencyName = country.value["Name"].string else { return }

            result[country.key] = (countryCode, currencyName)
        }
    }

}
