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

    override func setUp() {
        currencyViewController = CurrencyViewController()
        XCTAssertNotNil(currencyViewController, "View is nil")

        currencyResolver = CurrencyResolver(factory: DependenciesStorage.shared, config: currencyConfig)
        XCTAssertNotNil(currencyResolver, "Currency resolver is nil")

        DependenciesStorage.shared.flush()
    }

    override func tearDown() {
    }

    func testAssembly() {
        CurrencyAssembler(view: currencyViewController,
                          resolver: currencyResolver,
                          config: currencyConfig).assemble()

        XCTAssert(currencyViewController.reusableIdentifier == "CurrencyCellIdentifier", "Invalid reuse identifier")
        XCTAssertNotNil(currencyViewController.presenter, "Presenter is nil")
        XCTAssertNotNil(currencyViewController.dataSource, "Data source is nil")
        XCTAssertNotNil(currencyViewController.amountFormatter, "Amount formatter is nil")
    }

    func testViewDidLoad() {
        // Load initial rates
        let viewMock = createMockedViewController()
        viewMock.viewDidLoad()

        XCTAssertNil(viewMock.alertError, "Error fetching changes: \(viewMock.alertError!)")

        // FIXME: XCTAssertNil crashes here
        XCTAssert(viewMock.updatedChangeset != nil, "Changest to update table is nil")

        let presenter = currencyViewController.presenter as! CurrencyPresenterImpl
        let changes = viewMock.updatedChangeset!
        let fetcher = presenter.fetcher as! CurrencyFetcherMock

        XCTAssert(changes.edits.count == fetcher.numberOfLoadedRates, "Invalid number of loaded rates")
    }

    func testChangeBaseCurrency() {
        // Load initial rates
        let viewMock = createMockedViewController()
        viewMock.viewDidLoad()

        XCTAssertNil(viewMock.alertError, "Error fetching changes: \(viewMock.alertError!)")

        // FIXME: XCTAssertNil crashes here
        XCTAssert(viewMock.updatedChangeset != nil, "Changest to update table is nil")

        let presenter = currencyViewController.presenter as! CurrencyPresenterImpl
        let changes = viewMock.updatedChangeset!
        let fetcher = presenter.fetcher as! CurrencyFetcherMock

        XCTAssert(changes.edits.count == fetcher.numberOfLoadedRates, "Invalid number of loaded rates")

        // Load updated rates
        fetcher.assetName = "CurrencyRatesUpdateBaseEUR"
        presenter.viewDidLoad()

        XCTAssertNil(viewMock.alertError, "Error fetching changes: \(viewMock.alertError!)")
        XCTAssert(changes.edits.count == fetcher.numberOfLoadedRates, "Invalid number of loaded rates")
    }

    // MARK: - Private

    private var currencyViewController: CurrencyViewController!
    private var currencyResolver: CurrencyResolver!

    private var currencyConfig: CurrencyConfig = {
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
    }()

}

// MARK: - Private

private extension RatesTests {

    private func createMockedViewController() -> CurrencyViewControllerMock {
        CurrencyAssembler(view: currencyViewController,
                          resolver: CurrencyResolverMock(factory: DependenciesStorage.shared, config: currencyConfig),
                          config: currencyConfig).assemble()

        let viewMock = CurrencyViewControllerMock(currencyViewController: currencyViewController)
        let presenter = currencyViewController.presenter as! CurrencyPresenterImpl
        presenter.view = viewMock

        return viewMock
    }

}
