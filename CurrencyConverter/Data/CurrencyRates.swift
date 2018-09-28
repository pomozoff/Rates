//
//  CurrencyRates.swift
//  CurrencyConverter
//
//  Created by Anton Pomozov on 25/09/2018.
//  Copyright © 2018 Anton Pomozov. All rights reserved.
//

import Foundation

struct CurrencyRates: Decodable {

    let base: Currency.ID
    let date: String
    let rates: [String : Decimal]

    enum CodingKeys : String, CodingKey {
        case base
        case date
        case rates
    }

}
