//
//  CurrencyPresenter.swift
//  Rates
//
//  Created by Anton Pomozov on 25/09/2018.
//  Copyright © 2018 Anton Pomozov. All rights reserved.
//

import Foundation
import Changeset

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

}

// MARK: - CurrencyPresenter

extension CurrencyPresenterImpl: CurrencyPresenter {

    func viewDidLoad() {
        fetchCurrencyList(after: .now())
    }

    func moveCurrencyToTop(from row: Int) {
        dataSource.setAsNewBaseCurrency(at: row)
    }

    func updateAmountOfBaseCurrency(with amount: Decimal) {
        let changeset = dataSource.updateCurrencyList(with: amount)
        view?.updateCurrencyTable(with: changeset)
    }

}

// MARK: - Private

private extension CurrencyPresenterImpl {

    private func fetchCurrencyList(after: DispatchTime) {
        DispatchQueue.main.asyncAfter(deadline: after) { [weak self] in
            guard let strongSelf = self else { return }

            let url = strongSelf.queryBuilder.buildFetchRatesUrl(withBaseCurrency: strongSelf.dataSource.baseCurrency)

            strongSelf.fetcher.fetchCurrencyListWithRandomRates(url: url) { result in
                switch result {
                case .success(let rates):
                    DispatchQueue.main.async {
                        let changeset = strongSelf.dataSource.updateCurrencyList(with: rates)
                        strongSelf.view?.updateCurrencyTable(with: changeset)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        strongSelf.view?.alert(error: error)
                    }
                }

                strongSelf.fetchCurrencyList(after: startedAt + .seconds(strongSelf.fetchPeriod))
            }
        }
    }

}
