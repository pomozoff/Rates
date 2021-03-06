//
//  CurrencyListViewController.swift
//  Rates
//
//  Created by Anton Pomozov on 24/09/2018.
//  Copyright © 2018 Anton Pomozov. All rights reserved.
//

import UIKit
import Changeset

protocol CurrencyListView: class {

    func updateTable(with changeset: Changeset<[Currency]>, animation: Bool, completion: (() -> Void)?)
    func alert(error: Error)

}

class CurrencyViewController: UIViewController, CurrencyListView {

    // MARK: - Outlets

    @IBOutlet weak var tableView: UITableView?

    // MARK: - Properties

    var reusableIdentifier: String!
    var presenter: CurrencyPresenter!
    var dataSource: CurrencyDataSource!
    var amountFormatter: NumberFormatter!

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.viewDidLoad()
    }

    // MARK: - CurrencyListView

    func updateTable(with changeset: Changeset<[Currency]>, animation: Bool, completion: (() -> Void)?) {
        tableView?.update(with: changeset.edits, animation: animation ? .automatic : .none)
        completion?()
    }

    func alert(error: Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)

        let actionOk = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(actionOk)

        present(alertController, animated: true, completion: nil)
    }

}

// MARK: - UITableViewDataSource

extension CurrencyViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier) as! CurrencyTableViewCell

        cell.presenter = presenter
        cell.amountFormatter = amountFormatter
        cell.currency = dataSource[indexPath.row]

        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension CurrencyViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let completion: () -> Void = {
            UIView.animate(withDuration: 0.3, animations: {
                tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            }, completion: { isFinished in
                guard isFinished else { return }

                let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! CurrencyCell
                cell.startEditing()
            })
        }

        guard indexPath.row > 0 else {
            completion()
            return
        }

        presenter.moveCurrencyToTop(fromRow: indexPath.row, completion: completion)
    }

}
