//
//  QueryBuilder.swift
//  Rates
//
//  Created by Anton Pomozov on 25/09/2018.
//  Copyright © 2018 Anton Pomozov. All rights reserved.
//

import Foundation

protocol QueryBuilder: class {

    func buildFetchRatesUrl(withBaseCurrency currency: Currency?) -> URL

}

final class QueryBuilderImpl {

    // MARK: - Life cycle

    init(baseUrl: URL) {
        self.baseUrl = baseUrl
    }

    // MARK: - Private

    private let baseUrl: URL

}

// MARK: - QueryBuilder

extension QueryBuilderImpl: QueryBuilder {

    func buildFetchRatesUrl(withBaseCurrency currency: Currency? = nil) -> URL {
        let query = "latest" + (currency == nil ? "" : "?base=\(currency!.id)")
        return baseUrl.appendingPathComponent(query)
    }

}
