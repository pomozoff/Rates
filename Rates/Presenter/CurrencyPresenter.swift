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
    var queueRunner: QueueRunner!

    // MARK: - Life cycle

    init(fetchPeriod: Int? = nil) {
        self.fetchPeriod = fetchPeriod
    }

    // MARK: - Private

    private let fetchPeriod: Int?

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
        view?.updateTable(with: changeset)
    }

}

// MARK: - Presenter

extension CurrencyPresenterImpl: Presenter {

    func didFinishAssemble() {
    }

}

// MARK: - Private

private extension CurrencyPresenterImpl {

    private func fetchCurrencyList(after: DispatchTime) {
        queueRunner.runOnMain(deadline: after) { [weak self] in
            guard let strongSelf = self else { return }

            let url = strongSelf.queryBuilder.buildFetchRatesUrl(withBaseCurrency: strongSelf.dataSource.baseCurrency)

            strongSelf.fetcher.fetchCurrencyList(url: url) { result in
                switch result {
                case .success(let rates):
                    strongSelf.queueRunner.runOnMain {
                        let changeset = strongSelf.dataSource.updateCurrencyList(with: rates)
                        strongSelf.view?.updateTable(with: changeset)
                    }
                case .failure(let error):
                    strongSelf.queueRunner.runOnMain {
                        strongSelf.view?.alert(error: error)
                    }
                }

                guard let fetchPeriod = strongSelf.fetchPeriod else { return }
                strongSelf.fetchCurrencyList(after: .now() + .seconds(fetchPeriod))
            }
        }
    }

}
