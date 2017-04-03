//
//  BankAccessTableViewController.swift
//  bankrs-ios-example
//
//  Created by Ingmar.Stein on 13.03.17.
//  Copyright © 2017 Bankrs. All rights reserved.
//

import UIKit

class BankAccessTableViewController: UITableViewController {

    var accesses = [BankAccess]()

    func refresh() {
        BankrsApi.bankAccesses { (accesses, _) in
            self.accesses = accesses
            self.tableView.reloadData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        refresh()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accesses.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BankAccessCell", for: indexPath)

        let access = accesses[indexPath.row]

        if let name = access.name, !name.isEmpty {
            cell.textLabel?.text = name
        } else {
            cell.textLabel?.text = "<empty name>"
        }
        cell.accessoryType = access.enabled ? .checkmark : .none

        return cell
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let bankAccountTableViewController = segue.destination as? BankAccountTableViewController, let selection = self.tableView.indexPathForSelectedRow {
            let access = accesses[selection.row]
            bankAccountTableViewController.access = access
        }
    }

    @IBAction func unwindToAccesses(segue: UIStoryboardSegue) {
        refresh()
    }

}
