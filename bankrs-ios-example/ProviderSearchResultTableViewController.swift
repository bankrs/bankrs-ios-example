//
//  ProviderSearchResultTableViewController.swift
//  bankrs-ios-example
//
//  Created by Ingmar.Stein on 29.03.17.
//  Copyright © 2017 Bankrs. All rights reserved.
//

import UIKit

class ProviderSearchResultTableViewController: UITableViewController {

    var providers = [Provider]()

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.providers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProviderCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "ProviderCell")

        let provider = providers[indexPath.row]
        cell.textLabel?.text = provider.id
        cell.detailTextLabel?.text = provider.name ?? provider.description

        return cell
    }

}
