//
//  ProviderTableViewController.swift
//  bankrs-ios-example
//
//  Created by Ingmar.Stein on 29.03.17.
//  Copyright © 2017 Bankrs. All rights reserved.
//

import UIKit

class ProviderTableViewController: UITableViewController, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {

    /// Search controller to help us with filtering.
    var searchController: UISearchController!
    var searchResultController: ProviderSearchResultTableViewController?
    var providers = [Provider]()

    override func viewDidLoad() {
        super.viewDidLoad()

        definesPresentationContext = true

        searchResultController = ProviderSearchResultTableViewController(style: .plain)
        searchResultController?.tableView.delegate = self

        searchController = UISearchController(searchResultsController: searchResultController)
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        searchController.delegate = self
        searchController.dimsBackgroundDuringPresentation = false // default is YES
        searchController.searchBar.delegate = self    // so we can monitor text changes + others

        tableView.tableHeaderView = searchController.searchBar
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.providers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProviderCell", for: indexPath)

        let provider = providers[indexPath.row]
        cell.textLabel?.text = provider.id

        return cell
    }

    // MARK: - UITableViewDelete

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "challengeSegue", sender: indexPath)
    }

    // MARK: - UISearchResultsUpdating

    func updateSearchResults(for searchController: UISearchController) {
        let query = searchController.searchBar.text!.trimmingCharacters(in: CharacterSet.whitespaces)
        BankrsApi.providers(query: query) { (providers, error) in
            self.providers = providers
            self.searchResultController?.providers = providers
            self.searchResultController?.tableView.reloadData()
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "challengeSegue" {
            guard let challengeAnswerTableViewController = segue.destination as? ChallengeAnswerTableViewController else { return }
            guard let selection = sender as? IndexPath else { return }

            let provider = self.providers[selection.row]
            challengeAnswerTableViewController.provider = provider
        }
    }

}
