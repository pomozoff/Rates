//
//  CurrencyConfig.swift
//  Rates
//
//  Created by Anton Pomozov on 30/09/2018.
//  Copyright © 2018 Anton Pomozov. All rights reserved.
//

import Foundation

struct CurrencyConfig {

    let reusableIdentifier: String
    let fetchPeriod: Int?
    let baseUrl: URL
    let currencyData: CurrencyData
    let amountFormatter: NumberFormatter
    let session: URLSession

}
