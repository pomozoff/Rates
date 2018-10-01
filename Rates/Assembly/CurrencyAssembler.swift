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

    init(view: CurrencyViewController, resolver: Resolver, config: CurrencyConfig) {
        self.view = view
        self.resolver = resolver
        self.config = config
    }

    // MARK: - Private

    private let view: CurrencyViewController
    private let resolver: Resolver
    private let config: CurrencyConfig

}

// MARK: - Assembler

extension CurrencyAssembler: Assembler {

    func assemble() {
        view.reusableIdentifier = config.reusableIdentifier
        view.amountFormatter = config.amountFormatter
        view.presenter = resolver.resolve()
        view.dataSource = resolver.resolve()

        let presenter = resolver.resolve() as CurrencyPresenterImpl

        presenter.view = view
        presenter.dataSource = resolver.resolve()
        presenter.fetcher = resolver.resolve()
        presenter.queryBuilder = resolver.resolve()
        presenter.queueRunner = resolver.resolve()

        presenter.didFinishAssemble()
    }

}
