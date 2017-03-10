//
//  DetailViewController.swift
//  bankrs-ios-example
//
//  Created by Ingmar.Stein on 10.03.17.
//  Copyright © 2017 Bankrs. All rights reserved.
//

import UIKit

class TransactionDetailViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.reloadData()
    }

    var detailItem: Transaction? {
        didSet {
            // Update the view.
            self.tableView?.reloadData()
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailItem == nil ? 0 : 11
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionDetailCell", for: indexPath)

        guard let detailItem = detailItem else { return cell }

        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "ID"
            cell.detailTextLabel?.text = String(detailItem.id)
        case 1:
            cell.textLabel?.text = "Counterparty"
            cell.detailTextLabel?.text = detailItem.counterparty?.name
        case 2:
            cell.textLabel?.text = "Merchant"
            cell.detailTextLabel?.text = detailItem.counterparty?.merchant
        case 3:
            cell.textLabel?.text = "Usage"
            cell.detailTextLabel?.text = detailItem.usage
        case 4:
            cell.textLabel?.text = "Entry date"
            cell.detailTextLabel?.text = detailItem.entryDate.flatMap { DateFormatter.localizedString(from: $0, dateStyle: .medium, timeStyle: .medium) }
        case 5:
            cell.textLabel?.text = "Settlement date"
            cell.detailTextLabel?.text = detailItem.settlementDate.flatMap { DateFormatter.localizedString(from: $0, dateStyle: .medium, timeStyle: .medium) }
        case 6:
            cell.textLabel?.text = "Category"
            cell.detailTextLabel?.text = detailItem.categoryId.flatMap { String($0) }
        case 7:
            cell.textLabel?.text = "Account"
            cell.detailTextLabel?.text = String(detailItem.userBankAccountId)
        case 8:
            cell.textLabel?.text = "Amount"
            cell.detailTextLabel?.text = (detailItem.amount?.value).flatMap { NumberFormatter.localizedString(from: $0, number: .decimal) }
        case 9:
            cell.textLabel?.text = "Currency"
            cell.detailTextLabel?.text = detailItem.amount?.currency
        case 10:
            cell.textLabel?.text = "Type"
            cell.detailTextLabel?.text = detailItem.type
        default:
            fatalError("unexpected number of rows")
        }

        return cell
    }
}
