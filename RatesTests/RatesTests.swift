//
//  RatesTests.swift
//  RatesTests
//
//  Created by Anton Pomozov on 24/09/2018.
//  Copyright © 2018 Anton Pomozov. All rights reserved.
//

import XCTest
@testable import Rates

class RatesTests: XCTestCase {

    // MARK: - XCTestCase

    override func setUp() {
        viewMock = CurrencyViewControllerMock()
        XCTAssertNotNil(viewMock, "View mock is nil")

        DependenciesStorage.shared.flush()
        CurrencyAssembler(view: viewMock, resolver: resolverMock, config: RatesTests.testCurrencyConfig).assemble()

        viewMock.viewDidLoad()
    }

    override func tearDown() {
        viewMock = nil
    }

    // MARK: - Tests

    func testLoadInitialRates() {
        XCTAssertNil(viewMock.alertError, "Error fetching changes: \(viewMock.alertError!)")

        let expectedNumberOfLoadedRows = 5
        XCTAssert(viewMock.changeset!.edits.count == expectedNumberOfLoadedRows, "Invalid number of loaded rows")
        XCTAssert(viewMock.dataSource.count == viewMock.changeset!.edits.count, "Invalid number of changed rows")
    }

    func testUpdateInitialRates() {
        resolverMock.assetName = "CurrencyRatesUpdateBaseEUR"
        CurrencyAssembler(view: viewMock, resolver: resolverMock, config: RatesTests.testCurrencyConfig).assemble()

        viewMock.viewDidLoad()
        XCTAssertNil(viewMock.alertError, "Error fetching changes: \(viewMock.alertError!)")

        let expectedNumberOfUpdatedRows = 3
        XCTAssert(viewMock.changeset!.edits.count == expectedNumberOfUpdatedRows, "Invalid number of updated rows")
    }

    func testSetNewBaseCurrency() {
        let rowFrom = 3
        viewMock.presenter.moveCurrencyToTop(fromRow: rowFrom, completion: {})

        let expectedNumberOfUpdatedRows = 1
        let edits = viewMock.changeset!.edits
        XCTAssert(edits.count == expectedNumberOfUpdatedRows, "Invalid number of updated rows")

        let firstEdit = edits.first!
        if case .move(let origin) = firstEdit.operation {
            XCTAssert(origin == rowFrom, "Invalid number of updated rows")
            XCTAssert(firstEdit.destination == 0, "Invalid number of updated rows")
        } else {
            XCTFail("Invalid operation")
        }
    }

    func testUpdateBaseCurrencyAmount() {
        let newBaseAmount: Decimal = 10.0
        viewMock.presenter.updateAmountOfBaseCurrency(with: newBaseAmount)

        let expectedNumberOfUpdatedRows = 4
        let edits = viewMock.changeset!.edits
        XCTAssert(edits.count == expectedNumberOfUpdatedRows, "Invalid number of loaded rows")

        edits.forEach {
            XCTAssert($0.value.amount == $0.value.rate * newBaseAmount, "Invalid amount of \($0.value.id)")
        }
    }

    func testSetNewBaseCurrencyAndUpdateItsAmount() {
        var newBaseAmount: Decimal = 10.0
        viewMock.presenter.updateAmountOfBaseCurrency(with: newBaseAmount)

        let rowFrom = 3
        viewMock.presenter.moveCurrencyToTop(fromRow: rowFrom, completion: {})

        newBaseAmount = 20.0
        viewMock.presenter.updateAmountOfBaseCurrency(with: newBaseAmount)

        let expectedNumberOfUpdatedRows = 4
        let edits = viewMock.changeset!.edits
        XCTAssert(edits.count == expectedNumberOfUpdatedRows, "Invalid number of loaded rows")

        edits.forEach {
            XCTAssert($0.value.amount == $0.value.rate * newBaseAmount, "Invalid amount of \($0.value.id)")
        }
    }

    // MARK: - Private

    private var viewMock: CurrencyViewControllerMock!

    private lazy var resolverMock = CurrencyResolverMock(factory: DependenciesStorage.shared,
                                                         config: RatesTests.testCurrencyConfig,
                                                         assetName: "CurrencyRatesInitBaseEUR")

}

// MARK: - Public

extension RatesTests {

    static var testCurrencyConfig: CurrencyConfig {
        let amountFormatter = NumberFormatter()
        amountFormatter.numberStyle = .decimal

        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)

        return CurrencyConfig(reusableIdentifier: "CurrencyCellIdentifier",
                              fetchPeriod: nil,
                              baseUrl: URL(string: "https://revolut.duckdns.org/")!,
                              currencyData: Currency.data,
                              amountFormatter: amountFormatter,
                              session: session)
    }

}
