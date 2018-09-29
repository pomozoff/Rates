//
//  CurrencyListViewController.swift
//  CurrencyConverter
//
//  Created by Anton Pomozov on 24/09/2018.
//  Copyright © 2018 Anton Pomozov. All rights reserved.
//

import UIKit

protocol CurrencyListView: class {

    func reloadTable()
    func refreshRows()
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

        cell.presenter = presenter
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
            UIView.animate(withDuration: 0.3, animations: {
                tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            }, completion: { isFinished in
                guard isFinished else { return }
                cell.startEditing()
            })
        }

        defer {
            completion(true)
        }

        guard indexPath.row > 0 else {
            return
        }

        // TODO: Animate move to top
        presenter.moveCurrencyToTop(from: indexPath.row)
        tableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: 0))
    }

}

// MARK: - CurrencyListView

extension CurrencyListViewController: CurrencyListView {

    func reloadTable() {
        tableView.reloadData()
    }

    func refreshRows() {
        var arrayOfIndexPathes: [IndexPath] = []
        for i in 1 ..< dataSource.count {
            arrayOfIndexPathes.append(IndexPath(row: i, section: 0))
        }
        tableView.reloadRows(at: arrayOfIndexPathes, with: .none)
    }

    func alert(error: Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)

        let actionOk = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(actionOk)

        present(alertController, animated: true, completion: nil)
    }

}

/*
// MARK: - Private

private extension CurrencyListViewController {

    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidShowNotification, object: nil, queue: .main) { notification in
            guard let userInfo = notification.userInfo,
                let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
            else {
                return
            }

            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.size.width, right: keyboardFrame.size.height)
        }

        NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidHideNotification, object: nil, queue: .main) { notification in

        }
    }

}
*/
