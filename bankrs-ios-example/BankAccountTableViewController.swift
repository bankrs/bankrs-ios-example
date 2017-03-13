//
//  BankAccountTableViewController.swift
//  bankrs-ios-example
//
//  Created by Ingmar.Stein on 13.03.17.
//  Copyright © 2017 Bankrs. All rights reserved.
//

import UIKit

class BankAccountTableViewController: UITableViewController {

    var access: BankAccess?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let access = access {
            BankrsApi.bankAccess(identifier: access.id) { (access, _) in
                self.access = access
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return access?.accounts.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BankAccountCell", for: indexPath)

        guard let account = access?.accounts[indexPath.row] else { return cell }

        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        currencyFormatter.currencyCode = account.currency

        cell.textLabel?.text = account.name
        cell.detailTextLabel?.text = currencyFormatter.string(from: account.balance)
        cell.accessoryType = account.enabled ? .checkmark : .none

        return cell
    }

}
