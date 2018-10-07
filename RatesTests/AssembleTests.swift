//
//  AssembleTests.swift
//  RatesTests
//
//  Created by Anton Pomozov on 07/10/2018.
//  Copyright © 2018 Anton Pomozov. All rights reserved.
//

import XCTest
@testable import Rates

class AssembleTests: XCTestCase {

    // MARK: - XCTestCase

    override func setUp() {
        viewMock = CurrencyViewControllerMock()
        XCTAssertNotNil(viewMock, "View mock is nil")

        DependenciesStorage.shared.flush()
    }

    override func tearDown() {
        viewMock = nil
    }

    // MARK: - Tests

    func testAssembly() {
        let resolver = CurrencyResolver(factory: DependenciesStorage.shared, config: RatesTests.testCurrencyConfig)
        XCTAssertNotNil(resolver, "Currency resolver is nil")

        CurrencyAssembler(view: viewMock, resolver: resolver, config: RatesTests.testCurrencyConfig).assemble()
        checkCurrencyViewIsReady(viewMock)
    }

    // MARK: - Private

    private var viewMock: CurrencyViewControllerMock!

}

// MARK: - Private

private extension AssembleTests {

    private func checkCurrencyViewIsReady(_ view: CurrencyViewController) {
        XCTAssert(view.reusableIdentifier == "CurrencyCellIdentifier", "Invalid reuse identifier")
        XCTAssertNotNil(view.presenter, "Presenter is nil")
        XCTAssertNotNil(view.dataSource, "Data source is nil")
        XCTAssertNotNil(view.amountFormatter, "Amount formatter is nil")
    }

}
