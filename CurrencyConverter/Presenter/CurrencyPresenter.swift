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
        dataSource.move(from: row, to: 0)
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
                    self?.view?.updateTable()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.view?.alert(error: error)
                }
            }
        }
    }

}
