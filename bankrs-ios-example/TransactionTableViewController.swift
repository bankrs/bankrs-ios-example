//
//  MasterViewController.swift
//  bankrs-ios-example
//
//  Created by Ingmar.Stein on 10.03.17.
//  Copyright © 2017 Bankrs. All rights reserved.
//

import UIKit

class TransactionTableViewController: UITableViewController {

    var detailViewController: TransactionDetailViewController?
    var transactions = [Transaction]()
    var categories = [Int: String]()

    private static let defaultUsername = "john.doe@bankworld.com"
    private static let defaultPassword = "F6hC>dEgAWNnmRg.7xBE"

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)

    }

    // MARK: - Actions

    @IBAction func logInOut() {
        if BankrsApi.sessionToken != nil {
            BankrsApi.logout { _ in
                self.navigationItem.rightBarButtonItem?.title = "Login"
                self.navigationItem.leftBarButtonItem?.isEnabled = false
                self.transactions = []
                self.tableView.reloadData()
            }
        } else {
            let alertController = UIAlertController(title: "Login", message: "Please enter your Bankrs account", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
                let username = alertController.textFields![0].text ?? ""
                let password = alertController.textFields![1].text ?? ""

                BankrsApi.login(username: username, password: password) { error in
                    if error == nil {
                        self.navigationItem.rightBarButtonItem?.title = "Logout"
                        self.navigationItem.leftBarButtonItem?.isEnabled = true
                        self.refresh()
                    }
                }
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                alertController.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            alertController.addTextField { (textField) in
                textField.placeholder = "Username"
                textField.text = TransactionTableViewController.defaultUsername
            }
            alertController.addTextField { (textField) in
                textField.placeholder = "Password"
                textField.text = TransactionTableViewController.defaultPassword
                textField.isSecureTextEntry = true
            }

            present(alertController, animated: true, completion: nil)
        }
    }

    @IBAction func refresh() {
        BankrsApi.transactions { transactions, _ in
            self.transactions = transactions.sorted(by: { (t1, t2) -> Bool in
                guard let d1 = t1.settlementDate else { return false }
                guard let d2 = t2.settlementDate else { return true }
                return d1 > d2
            })
            self.tableView.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }

        BankrsApi.categories { (categories, _) in
            self.categories = categories
            self.tableView.reloadData()
        }
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let transaction = transactions[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! TransactionDetailViewController
                controller.detailItem = transaction
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as! TransactionTableViewCell

        let transaction = transactions[indexPath.row]

        if let settlementDate = transaction.settlementDate {
            cell.dateLabel.text = DateFormatter.localizedString(from: settlementDate, dateStyle: .medium, timeStyle: .none)
        } else {
            cell.dateLabel.text = "???"
        }

        if let amount = transaction.amount {
            let currencyFormatter = NumberFormatter()
            currencyFormatter.numberStyle = .currency
            currencyFormatter.currencyCode = amount.currency

            cell.amountLabel.text = currencyFormatter.string(from: amount.value)
            if amount.value.compare(NSDecimalNumber.zero) == .orderedAscending {
                cell.amountLabel.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            } else {
                cell.amountLabel.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            }
        } else {
            cell.amountLabel.text = "???"
            cell.amountLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }

        cell.counterpartyLabel.text = transaction.counterparty?.name ?? "???"

        if let categoryId = transaction.categoryId {
            if let category = categories[categoryId] {
                cell.transactionDetailLabel.text = category
            } else {
                cell.transactionDetailLabel.text = String(categoryId)
            }
        } else {
            cell.transactionDetailLabel.text = "Unknown"
        }

        return cell
    }

}
