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

        assembler.assemble()
    }

    // MARK: - Private

    private lazy var config: CurrencyConfig = {
        let amountFormatter = NumberFormatter()
        amountFormatter.numberStyle = .decimal

        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)

        let config = CurrencyConfig(reusableIdentifier: "CurrencyCellIdentifier",
                                    fetchPeriod: 1,
                                    baseUrl: URL(string: "https://revolut.duckdns.org/")!,
                                    currencyData: Currency.data,
                                    amountFormatter: amountFormatter,
                                    session: session)
        return config
    }()

    private lazy var resolver = CurrencyResolver(factory: DependenciesStorage.shared, config: config)
    private lazy var assembler = CurrencyAssembler(view: currencyViewController, resolver: resolver, config: config)

}
