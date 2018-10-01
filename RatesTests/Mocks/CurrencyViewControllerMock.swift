//
//  CurrencyViewControllerMock.swift
//  RatesTests
//
//  Created by Anton Pomozov on 01/10/2018.
//  Copyright © 2018 Anton Pomozov. All rights reserved.
//

import Changeset
import UIKit
@testable import Rates

final class CurrencyViewControllerMock {

    var updatedChangeset: Changeset<[Currency]>?
    var alertError: Error?

    init(currencyViewController: CurrencyViewController) {
        self.currencyViewController = currencyViewController
    }

    func viewDidLoad() {
        currencyViewController.viewDidLoad()
    }

    private let currencyViewController: CurrencyViewController

}

// MARK: - CurrencyListView

extension CurrencyViewControllerMock: CurrencyListView {

    func updateTable(with changeset: Changeset<[Currency]>) {
        updatedChangeset = changeset
    }

    func alert(error: Error) {
        alertError = error
    }

}
