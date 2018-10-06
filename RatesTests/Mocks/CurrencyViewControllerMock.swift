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

final class CurrencyViewControllerMock: CurrencyViewController {

    // MARK: - Properties

    var changeset: Changeset<[Currency]>?
    var alertError: Error?

    // MARK: - CurrencyListView

    override func updateTable(with changeset: Changeset<[Currency]>) {
        self.changeset = changeset
    }

    override func alert(error: Error) {
        alertError = error
    }

}
