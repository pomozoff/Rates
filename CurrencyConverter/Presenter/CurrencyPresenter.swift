//
//  CurrencyPresenter.swift
//  CurrencyConverter
//
//  Created by Anton Pomozov on 25/09/2018.
//  Copyright © 2018 Anton Pomozov. All rights reserved.
//

import Foundation

protocol CurrencyPresenter: class {

    func viewDidLoad()
    func moveCurrencyToTop(from row: Int)
    func updateAmountOfBaseCurrency(with amount: Decimal)

}

final class CurrencyPresenterImpl {

    // MARK: - Properties

    weak var view: CurrencyListView?
    var dataSource: CurrencyList!
    var fetcher: CurrencyFetcher!
    var queryBuilder: QueryBuilder!

    // MARK: - Life cycle

    init(fetchPeriod: Int) {
        self.fetchPeriod = fetchPeriod
    }

    // MARK: - Private

    private let fetchPeriod: Int
    private var baseCurrency: Currency?

}

// MARK: - CurrencyPresenter

extension CurrencyPresenterImpl: CurrencyPresenter {

    func viewDidLoad() {
        fetchCurrencyList()
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(self.fetchPeriod)) { [weak self] in
//        }
    }

    func moveCurrencyToTop(from row: Int) {
        dataSource.setAsNewBaseCurrency(at: row)
    }

    func updateAmountOfBaseCurrency(with amount: Decimal) {
        dataSource.amount = amount
        view?.refreshRows()
    }

}

// MARK: - Private

private extension CurrencyPresenterImpl {

    private func fetchCurrencyList() {
        let url = queryBuilder.buildFetchRatesUrl(withBaseCurrency: baseCurrency)

        fetcher.fetchCurrencyList(url: url) { [weak self] result in
            switch result {
            case .success(let rates):
                DispatchQueue.main.async {
                    self?.dataSource.rates = rates
                    self?.view?.reloadTable()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.view?.alert(error: error)
                }
            }
        }
    }

}
