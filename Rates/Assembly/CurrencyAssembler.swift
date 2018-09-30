//
//  CurrencyAssembler.swift
//  Rates
//
//  Created by Anton Pomozov on 30/09/2018.
//  Copyright © 2018 Anton Pomozov. All rights reserved.
//

import UIKit

typealias CurrencyData = [String : (String, String)]

final class CurrencyAssembler {

    // MARK: - Life cycle

    init(view: CurrencyViewController, factory: DependenciesFactory, config: CurrencyConfig) {
        self.view = view
        self.factory = factory
        self.config = config
    }

    // MARK: - Private

    private let view: CurrencyViewController
    private let factory: DependenciesFactory
    private let config: CurrencyConfig

}

// MARK: - Assembler

extension CurrencyAssembler: Assembler {

    func assemble() {
        view.reusableIdentifier = config.reusableIdentifier
        view.amountFormatter = config.amountFormatter
        view.presenter = resolve() as CurrencyPresenterImpl
        view.dataSource = resolve() as CurrencyDataSourceImpl

        let presenter = resolve() as CurrencyPresenterImpl

        presenter.view = view
        presenter.dataSource = resolve() as CurrencyDataSourceImpl
        presenter.fetcher = resolve() as CurrencyFetcherImpl
        presenter.queryBuilder = resolve() as QueryBuilderImpl

        presenter.didFinishAssemble()
    }

    func resolve<T>() -> T where T: AnyObject {
        switch T.self {
        case is CurrencyPresenterImpl.Type:
            return factory.resolveObject { return CurrencyPresenterImpl(fetchPeriod: config.fetchPeriod) } as! T
        case is CurrencyDataSourceImpl.Type:
            return factory.resolveObject { return CurrencyDataSourceImpl(currencyData: config.currencyData) } as! T
        case is QueryBuilderImpl.Type:
            return factory.resolveObject { return QueryBuilderImpl(baseUrl: config.baseUrl) } as! T
        case is CurrencyFetcherImpl.Type:
            return factory.resolveObject { return CurrencyFetcherImpl(session: config.session) } as! T
        default:
            fatalError("Invalid type sent: \(T.self)")
        }
    }

}
