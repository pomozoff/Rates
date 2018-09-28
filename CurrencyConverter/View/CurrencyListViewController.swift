//
//  CurrencyListViewController.swift
//  CurrencyConverter
//
//  Created by Anton Pomozov on 24/09/2018.
//  Copyright © 2018 Anton Pomozov. All rights reserved.
//

import UIKit

protocol CurrencyListView: class {

    func updateTable()
    func alert(error: Error)

}

class CurrencyListViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var tableView: UITableView!

    // MARK: - Properties

    var reusableIdentifier: String!
    var presenter: CurrencyPresenter!
    var dataSource: CurrencyDataSourceImpl!
    var amountFormatter: NumberFormatter!

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.viewDidLoad()
    }

}

// MARK: - UITableViewDataSource

extension CurrencyListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier) as! CurrencyTableViewCell

        cell.amountFormatter = amountFormatter
        cell.currency = dataSource[indexPath.row]
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension CurrencyListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let cell = tableView.cellForRow(at: indexPath) as! CurrencyCell

        let completion: (Bool) -> Void = { isFinished in
            //TODO: Update height of the table content view according a keyboard height
            cell.startEditing()
        }

        guard indexPath.row > 0 else {
            completion(true)
            return
        }

        // TODO: Animate move to top
        presenter.moveCurrencyToTop(from: indexPath.row)
        tableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: 0))
    }

}

// MARK: - CurrencyListView

extension CurrencyListViewController: CurrencyListView {

    func updateTable() {
        tableView.reloadData()
    }

    func alert(error: Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)

        let actionOk = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(actionOk)

        present(alertController, animated: true, completion: nil)
    }

}
