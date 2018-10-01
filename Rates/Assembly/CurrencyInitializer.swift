//
//  CurrencyInitializer.swift
//  Rates
//
//  Created by Anton Pomozov on 24/09/2018.
//  Copyright © 2018 Anton Pomozov. All rights reserved.
//

import UIKit

final class CurrencyInitializer: NSObject {

    // MARK: - Outlets

    @IBOutlet weak var currencyViewController: CurrencyViewController!

    // MARK: - Life cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        configureApplication()
    }

}

// MARK: - Private

private extension CurrencyInitializer {

    private func configureApplication() {
        let amountFormatter = NumberFormatter()
        amountFormatter.numberStyle = .decimal

        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)

        let currencyConfig = CurrencyConfig(reusableIdentifier: "CurrencyCellIdentifier",
                                            fetchPeriod: 5,
                                            baseUrl: URL(string: "https://revolut.duckdns.org/")!,
                                            currencyData: Currency.data,
                                            amountFormatter: amountFormatter,
                                            session: session)
        CurrencyAssembler(view: currencyViewController,
                          resolver: CurrencyResolver(factory: DependenciesStorage.shared, config: currencyConfig),
                          config: currencyConfig).assemble()
    }

}
