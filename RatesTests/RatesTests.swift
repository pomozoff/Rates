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
        view = CurrencyViewController()
        XCTAssertNotNil(view, "View is nil")

        currencyResolver = CurrencyResolver(factory: DependenciesStorage.shared, config: currencyConfig)
        XCTAssertNotNil(currencyResolver, "Currency resolver is nil")

        DependenciesStorage.shared.flush()
    }

    override func tearDown() {
        viewMock = nil
    }

    func testAssembly() {
        CurrencyAssembler(view: view,
                          resolver: currencyResolver,
                          config: currencyConfig).assemble()

        XCTAssert(view.reusableIdentifier == "CurrencyCellIdentifier", "Invalid reuse identifier")
        XCTAssertNotNil(view.presenter, "Presenter is nil")
        XCTAssertNotNil(view.dataSource, "Data source is nil")
        XCTAssertNotNil(view.amountFormatter, "Amount formatter is nil")
    }

    func testLoadUpdatedRates() {
        fetchInitialRateList()

        let presenter = getPresenter(from: view)
        let updatedChanges = viewMock.updatedChangeset!
        let fetcher = getFetcherMock(from: presenter)

        XCTAssert(updatedChanges.edits.count == fetcher.numberOfLoadedRates, "Invalid number of loaded rates")

        // Load updated rates
        // There should be only 3 changes comparing to CurrencyRatesInitBaseEUR
        let expectedNumberOfChanges = 3
        fetcher.assetName = "CurrencyRatesUpdateBaseEUR"
        presenter.viewDidLoad()

        let updateChanges = viewMock.updatedChangeset!

        XCTAssertNil(viewMock.alertError, "Error fetching changes: \(viewMock.alertError!)")
        XCTAssert(updateChanges.edits.count == expectedNumberOfChanges, "Invalid number of modified rates")
    }

    func testMoveCurrencyToTop() {
        fetchInitialRateList()

        let presenter = getPresenter(from: view)
        let updatedChanges = viewMock.updatedChangeset!
        let fetcher = getFetcherMock(from: presenter)

        XCTAssert(updatedChanges.edits.count == fetcher.numberOfLoadedRates, "Invalid number of loaded rates")

        let dataSource = getDataSource(from: presenter)
        let currencyOnThirdRow = dataSource[2] as! Currency
        presenter.moveCurrencyToTop(fromRow: 2)
        let currencyOnTop = dataSource[0] as! Currency

        XCTAssert(currencyOnThirdRow == currencyOnTop, "Failed to move on top")
    }

    func testChangeBaseCurrency() {
        fetchInitialRateList()

        let presenter = getPresenter(from: view)
        let updatedChanges = viewMock.updatedChangeset!
        let fetcher = getFetcherMock(from: presenter)

        XCTAssert(updatedChanges.edits.count == fetcher.numberOfLoadedRates, "Invalid number of loaded rates")

        // Change base currency EUR -> BRL
        // There should be only 2 changes (one insertion and one deletion) comparing to CurrencyRatesInitBaseEUR
        let expectedNumberOfChanges = 2
        fetcher.assetName = "CurrencyRatesInitBaseBRL"
        presenter.viewDidLoad()

        let baseChanges = viewMock.updatedChangeset!

        XCTAssertNil(viewMock.alertError, "Error fetching changes: \(viewMock.alertError!)")
        XCTAssert(baseChanges.edits.count == expectedNumberOfChanges, "Invalid number of modified rates")
    }

    func testBaseCurrencyWasChanged() {
        fetchInitialRateList()

        let presenter = getPresenter(from: view)
        let updatedChanges = viewMock.updatedChangeset!
        let fetcher = getFetcherMock(from: presenter)

        XCTAssert(updatedChanges.edits.count == fetcher.numberOfLoadedRates, "Invalid number of loaded rates")

        // Change base currency EUR -> BRL
        // There should be only 2 changes (one insertion and one deletion) comparing to CurrencyRatesInitBaseEUR
        let expectedNumberOfChanges = 2
        fetcher.assetName = "CurrencyRatesInitBaseBRL"
        presenter.viewDidLoad()

        let baseChanges = viewMock.updatedChangeset!

        XCTAssertNil(viewMock.alertError, "Error fetching changes: \(viewMock.alertError!)")
        XCTAssert(baseChanges.edits.count == expectedNumberOfChanges, "Invalid number of modified rates")
    }

    // MARK: - Private

    private var viewMock: CurrencyViewControllerMock!
    private var view: CurrencyViewController!
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

    private func fetchInitialRateList() {
        // Load initial rates
        viewMock = createMockedViewController()
        viewMock.viewDidLoad()

        XCTAssertNil(viewMock.alertError, "Error fetching changes: \(viewMock.alertError!)")

        // FIXME: XCTAssertNil crashes here
        XCTAssert(viewMock.updatedChangeset != nil, "Changest to update table is nil")
    }

    private func getPresenter(from view: CurrencyViewController) -> CurrencyPresenterImpl {
        return view.presenter as! CurrencyPresenterImpl
    }

    private func getFetcherMock(from presenter: CurrencyPresenterImpl) -> CurrencyFetcherMock {
        return presenter.fetcher as! CurrencyFetcherMock
    }

    private func getDataSource(from presenter: CurrencyPresenterImpl) -> CurrencyDataSourceImpl {
        return presenter.dataSource as! CurrencyDataSourceImpl
    }

    private func createMockedViewController() -> CurrencyViewControllerMock {
        CurrencyAssembler(view: view,
                          resolver: CurrencyResolverMock(factory: DependenciesStorage.shared, config: currencyConfig),
                          config: currencyConfig).assemble()

        let viewMock = CurrencyViewControllerMock(currencyViewController: view)
        let presenter = getPresenter(from: view)
        presenter.view = viewMock

        return viewMock
    }

}
