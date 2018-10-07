//
//  ViewTests.swift
//  RatesTests
//
//  Created by Anton Pomozov on 07/10/2018.
//  Copyright © 2018 Anton Pomozov. All rights reserved.
//

import XCTest
@testable import Rates

class ViewTests: XCTestCase {

    // MARK: - XCTestCase

    override func setUp() {
        view = UIStoryboard(name: "Main", bundle: Bundle(for: CurrencyViewController.self))
            .instantiateInitialViewController() as? CurrencyViewController

        DependenciesStorage.shared.flush()
        CurrencyAssembler(view: view, resolver: resolverMock, config: RatesTests.testCurrencyConfig).assemble()

        UIApplication.shared.keyWindow!.rootViewController = view
        let _ = view.view
    }

    override func tearDown() {
        view = nil
    }

    // MARK: - Tests

    func testViewIsLoaded() {
        XCTAssertNotNil(view.tableView, "Table view is nil")

        let expectedNumberOfRows = 5
        let resultNumberOfRows = view.tableView!.numberOfRows(inSection: 0)

        XCTAssert(resultNumberOfRows == expectedNumberOfRows, "Invalid number of loaded rows")
    }

    func testSetNewBaseCurrency() {
        let realIndexPath = IndexPath(row: 3, section: 0)
        let realCurrency = view.dataSource[realIndexPath.row]

        view.tableView(view.tableView!, didSelectRowAt: realIndexPath)

        let baseCurrency = view.dataSource[0]
        XCTAssert(realCurrency.id == baseCurrency.id, "Invalid base currency")
    }

    func testUpdateAnotherTextField() {
        let baseIndexPath = IndexPath(row: 0, section: 0)
        let cell = view.tableView?.cellForRow(at: baseIndexPath) as! CurrencyTableViewCell

        let shouldChange = cell.textField(UITextField(frame: .zero),
                                          shouldChangeCharactersIn: NSRange(location: 0, length: 0),
                                          replacementString: "")

        XCTAssertTrue(shouldChange, "The text should be changed")
    }

    func testUpdateBaseCurrencyAmountWithNonDigitChars() {
        let baseIndexPath = IndexPath(row: 0, section: 0)
        let cell = view.tableView?.cellForRow(at: baseIndexPath) as! CurrencyTableViewCell

        let shouldChangeLetter = cell.textField(cell.currencyAmountTextField,
                                                shouldChangeCharactersIn: NSRange(location: 0, length: 1),
                                                replacementString: "a")
        XCTAssertFalse(shouldChangeLetter, "The text should not be changed")

        let shouldChangeSpecial = cell.textField(cell.currencyAmountTextField,
                                                 shouldChangeCharactersIn: NSRange(location: 0, length: 1),
                                                 replacementString: "!")
        XCTAssertFalse(shouldChangeSpecial, "The text should not be changed")

        let shouldChangeSeparator = cell.textField(cell.currencyAmountTextField,
                                                   shouldChangeCharactersIn: NSRange(location: 0, length: 1),
                                                   replacementString: Locale.current.decimalSeparator!)
        XCTAssertFalse(shouldChangeSeparator, "The text should not be changed")
    }

    func testUpdateBaseCurrencyAmountWithDecimal() {
        let baseIndexPath = IndexPath(row: 0, section: 0)
        let cell = view.tableView?.cellForRow(at: baseIndexPath) as! CurrencyTableViewCell

        let shouldChangeSeparator = cell.textField(cell.currencyAmountTextField,
                                                   shouldChangeCharactersIn: NSRange(location: 0, length: 1),
                                                   replacementString: ".")
        XCTAssertFalse(shouldChangeSeparator, "The text should not be changed")

        let shouldChangeZero = cell.textField(cell.currencyAmountTextField,
                                              shouldChangeCharactersIn: NSRange(location: 0, length: 1),
                                              replacementString: "0")
        XCTAssertTrue(shouldChangeZero, "The text should be changed")

        let shouldAddSeparator = cell.textField(cell.currencyAmountTextField,
                                                shouldChangeCharactersIn: NSRange(location: 1, length: 0),
                                                replacementString: Locale.current.decimalSeparator!)
        XCTAssertTrue(shouldAddSeparator, "The separator should be added")

        let shouldAddOne = cell.textField(cell.currencyAmountTextField,
                                          shouldChangeCharactersIn: NSRange(location: 2, length: 0),
                                          replacementString: "1")
        XCTAssertTrue(shouldAddOne, "The digit should be added")
    }

    func testUpdateBaseCurrencyAmount() {
        let cell = cellForRow(at: 0)
        let shouldChangeTwo = cell.textField(cell.currencyAmountTextField,
                                             shouldChangeCharactersIn: NSRange(location: 0, length: 1),
                                             replacementString: "2")
        XCTAssertTrue(shouldChangeTwo, "The text should be changed")

        RunLoop.main.run(until: Date()) 

        let tableView = view.tableView!
        let resultNumberOfRows = tableView.numberOfRows(inSection: 0)

        for index in 0 ..< resultNumberOfRows {
            let cell = cellForRow(at: index)

            let expectedAmpunt = cell.amountFormatter.string(from: cell.currency.amount as NSDecimalNumber)
            let resultAmount = cell.currencyAmountTextField.text!
            XCTAssert(resultAmount == expectedAmpunt, "Invalid currency \(cell.currency.id) amount")
        }
    }

    // MARK: - Private

    private var view: CurrencyViewController!

    private lazy var resolverMock = CurrencyResolverMock(factory: DependenciesStorage.shared,
                                                         config: RatesTests.testCurrencyConfig,
                                                         assetName: "CurrencyRatesInitBaseEUR")

}

// MARK: - Private

private extension ViewTests {

    private func cellForRow(at index: Int) -> CurrencyTableViewCell {
        let baseIndexPath = IndexPath(row: index, section: 0)
        return view.tableView!.cellForRow(at: baseIndexPath) as! CurrencyTableViewCell
    }

}
