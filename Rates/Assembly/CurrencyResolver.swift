//
//  CurrencyResolver.swift
//  Rates
//
//  Created by Anton Pomozov on 30/09/2018.
//  Copyright © 2018 Anton Pomozov. All rights reserved.
//

import Foundation

class CurrencyResolver: Resolver {

    // MARK: - Properties

    let factory: DependenciesFactory
    let config: CurrencyConfig

    // MARK: - Life cycle

    init(factory: DependenciesFactory, config: CurrencyConfig) {
        self.factory = factory
        self.config = config
    }

    // MARK: - Resolver

    func resolve<T>() -> T where T: Any {
        if T.self == CurrencyPresenter?.self || T.self == CurrencyPresenterImpl.self {
            return factory.resolveObject { return CurrencyPresenterImpl(fetchPeriod: config.fetchPeriod) } as! T
        } else if T.self == CurrencyDataSource?.self || T.self == CurrencyList?.self {
            return factory.resolveObject { return CurrencyDataSourceImpl(currencyData: config.currencyData) } as! T
        } else if T.self == QueryBuilder?.self {
            return factory.resolveObject { return QueryBuilderImpl(baseUrl: config.baseUrl) } as! T
        } else if T.self == CurrencyFetcher?.self || T.self == CurrencyFetcherImpl.self {
            return factory.resolveObject { return CurrencyFetcherImpl(session: config.session) } as! T
        } else if T.self == QueueRunner?.self {
            return factory.resolveObject { return QueueRunnerImpl() } as! T
        } else {
            fatalError("Invalid type sent: \(T.self)")
        }
    }

}
