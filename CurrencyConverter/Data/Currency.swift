//
//  Currency.swift
//  CurrencyConverter
//
//  Created by Anton Pomozov on 24/09/2018.
//  Copyright © 2018 Anton Pomozov. All rights reserved.
//

import Foundation

protocol CurrencyView {

    var id: Currency.ID { get }
    var name: String { get }
    var amount: Decimal { get }
    var country: String { get }

}

struct Currency {

    typealias ID = String

    var id: ID // USD
    var name: String // US Dollar
    var rate: Decimal
    var amount: Decimal
    var country: String

}

// MARK: - CurrencyView

extension Currency: CurrencyView {}

// MARK: - Equatable

extension Currency: Equatable {

    static func == (lhs: Currency, rhs: Currency) -> Bool {
        return lhs.id == rhs.id
    }

}
