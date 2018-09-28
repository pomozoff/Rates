//
//  CurrencyTableViewCell.swift
//  CurrencyConverter
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

    var amountFormatter: NumberFormatter!
    var currency: CurrencyView! {
        didSet {
            currencyIdLabel.text = currency.id
            currencyNameLabel.text = currency.name
            flagImageview.image = UIImage(named: currency.country)
            currencyAmountTextField.text = amountFormatter.string(from: currency!.amount as NSDecimalNumber)
        }
    }

    // MARK: - Life cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

// MARK: - CurrencyCell

extension CurrencyTableViewCell: CurrencyCell {

    func startEditing() {
        currencyAmountTextField.becomeFirstResponder()
    }

}
