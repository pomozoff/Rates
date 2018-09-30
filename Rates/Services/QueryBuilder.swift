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
        var components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: false)!
        components.path = "/latest"

        repeat {
            guard let value = currency?.id else {
                break
            }

            let item = URLQueryItem(name: "base", value: value)
            components.queryItems = [item]
        } while false

        return components.url!
    }

}
