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

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Login", style: .plain, target: self, action: #selector(logInOut))
    }

    func logInOut() {
        if BankrsApi.sessionToken != nil {
            BankrsApi.logout { _ in
                self.navigationItem.rightBarButtonItem?.title = "Login"
                self.transactions = []
                self.tableView.reloadData()
            }
        } else {
            BankrsApi.login { _ in
                self.navigationItem.rightBarButtonItem?.title = "Logout"
                self.refresh()
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)

    }

    // MARK: - Actions

    @IBAction func refresh() {
        BankrsApi.transactions { trx, _ in
            self.transactions = trx.sorted(by: { (t1, t2) -> Bool in
                guard let d1 = t1.settlementDate else { return false }
                guard let d2 = t2.settlementDate else { return true }
                return d1 > d2
            })
            self.tableView.refreshControl?.endRefreshing()
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
            cell.transactionDetailLabel.text = "Category: \(categoryId)"
        } else {
            cell.transactionDetailLabel.text = "Category: unknown"
        }

        return cell
    }

}
