//
//  CurrencyTableViewCell.swift
//  Rates
//
//  Created by Anton Pomozov on 24/09/2018.
//  Copyright © 2018 Anton Pomozov. All rights reserved.
//

import UIKit

protocol CurrencyCell: class {

    var currency: CurrencyView! { get set }

    func startEditing()

}

final class CurrencyTableViewCell: UITableViewCell {

    // MARK: - Outlets

    @IBOutlet weak var flagImageview: UIImageView!
    @IBOutlet weak var currencyIdLabel: UILabel!
    @IBOutlet weak var currencyNameLabel: UILabel!
    @IBOutlet weak var currencyAmountTextField: UITextField!

    // MARK: - Properties

    var presenter: CurrencyPresenter!
    var amountFormatter: NumberFormatter!
    var currency: CurrencyView! {
        didSet {
            currencyIdLabel.text = currency.id
            currencyNameLabel.text = currency.name
            flagImageview.image = UIImage(named: currency.country)
            currencyAmountTextField.text = amountFormatter.string(from: currency!.amount as NSDecimalNumber)
        }
    }

    // MARK: - Private

    private let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()

}

// MARK: - CurrencyCell

extension CurrencyTableViewCell: CurrencyCell {

    func startEditing() {
        currencyAmountTextField.isUserInteractionEnabled = true
        currencyAmountTextField.becomeFirstResponder()
        currencyAmountTextField.selectAll(nil)
    }

}

// MARK: - UITextFieldDelegate

extension CurrencyTableViewCell: UITextFieldDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.isUserInteractionEnabled = false
        if let text = textField.text, text.isEmpty {
            textField.text = "0"
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text, let textRange = Range(range, in: text) else {
            return true
        }

        let updatedText = text.replacingCharacters(in: textRange, with: string)
        guard let amount = formatter.number(from: updatedText.isEmpty ? "0" : updatedText) else {
            return false
        }

        presenter.updateAmountOfBaseCurrency(with: amount.decimalValue)

        return true
    }

}
