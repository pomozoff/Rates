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
        viewMock = CurrencyViewControllerMock()
        XCTAssertNotNil(viewMock, "View mock is nil")

        DependenciesStorage.shared.flush()
    }

    override func tearDown() {
        viewMock = nil
    }

    func testAssembly() {
        let resolver = CurrencyResolver(factory: DependenciesStorage.shared, config: config)
        XCTAssertNotNil(resolver, "Currency resolver is nil")

        assembleModule(using: resolver)
    }

    func testLoadInitialRates() {
        let resolver = createResolverMock(with: "CurrencyRatesInitBaseEUR")
        assembleModule(using: resolver)

        viewMock.viewDidLoad()
        XCTAssertNil(viewMock.alertError, "Error fetching changes: \(viewMock.alertError!)")

        let expectedNumberOfLoadedRows = 5
        XCTAssert(viewMock.changeset!.edits.count == expectedNumberOfLoadedRows, "Invalid number of loaded rows")
    }

    func testUpdateInitialRates() {
        let resolver = createResolverMock(with: "CurrencyRatesInitBaseEUR")
        assembleModule(using: resolver)

        viewMock.viewDidLoad()

        resolver.assetName = "CurrencyRatesUpdateBaseEUR"
        assembleModule(using: resolver)

        viewMock.viewDidLoad()
        XCTAssertNil(viewMock.alertError, "Error fetching changes: \(viewMock.alertError!)")

        let expectedNumberOfUpdatedRows = 3
        XCTAssert(viewMock.changeset!.edits.count == expectedNumberOfUpdatedRows, "Invalid number of updated rows")
    }

    func testMoveCurrencyToTop() {

    }

    // MARK: - Private

    private var viewMock: CurrencyViewControllerMock!

    private var config: CurrencyConfig = {
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

    private func assembleModule(using resolver: CurrencyResolver) {
        CurrencyAssembler(view: viewMock,
                          resolver: resolver,
                          config: config).assemble()
        XCTAssert(viewMock.reusableIdentifier == "CurrencyCellIdentifier", "Invalid reuse identifier")
        XCTAssertNotNil(viewMock.presenter, "Presenter is nil")
        XCTAssertNotNil(viewMock.dataSource, "Data source is nil")
        XCTAssertNotNil(viewMock.amountFormatter, "Amount formatter is nil")
    }

    private func createResolverMock(with asset: String) -> CurrencyResolverMock {
        let resolver = CurrencyResolverMock(factory: DependenciesStorage.shared, config: config, assetName: "CurrencyRatesInitBaseEUR")
        XCTAssertNotNil(resolver, "Currency resolver mock is nil")

        return resolver
    }

}
