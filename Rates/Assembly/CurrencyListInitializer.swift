//
//  CurrencyListInitializer.swift
//  Rates
//
//  Created by Anton Pomozov on 24/09/2018.
//  Copyright © 2018 Anton Pomozov. All rights reserved.
//

import UIKit
import SwiftyJSON

class CurrencyListInitializer: NSObject {

    @IBOutlet weak var currencyListViewController: CurrencyListViewController!

    override func awakeFromNib() {
        super.awakeFromNib()

        let currencyData = loadCurrency()

        let amountFormatter = NumberFormatter()
        amountFormatter.numberStyle = .decimal

        // TODO: Update to Moya
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let baseUrl = URL(string: "https://revolut.duckdns.org/")!

        let dataSource = CurrencyDataSourceImpl(currencyData: currencyData)
        let presenter = CurrencyPresenterImpl(fetchPeriod: 1)
        let queryBuilder = QueryBuilderImpl(baseUrl: baseUrl)

        currencyListViewController.reusableIdentifier = "CurrencyCellIdentifier"
        currencyListViewController.presenter = presenter
        currencyListViewController.dataSource = dataSource
        currencyListViewController.amountFormatter = amountFormatter

        presenter.view = currencyListViewController
        presenter.dataSource = dataSource
        presenter.fetcher = CurrencyFetcherImpl(session: session)
        presenter.queryBuilder = queryBuilder
    }

}

private extension CurrencyListInitializer {

    private func loadCurrency() -> [String : (String, String)] {
        guard let asset = NSDataAsset(name: "CurrencyData", bundle: Bundle.main),
            let json = try? JSON(data: asset.data),
            let countries = json.dictionary
        else { return [:] }

        return countries.reduce(into: [:]) { result, country in
            guard let countryCode = country.value["Country"].string else { return }
            guard let currencyName = country.value["Name"].string else { return }

            result[country.key] = (countryCode, currencyName)
        }
    }

}
