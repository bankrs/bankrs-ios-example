//
//  ChallengeAnswerTableViewController.swift
//  bankrs-ios-example
//
//  Created by Ingmar.Stein on 29.03.17.
//  Copyright © 2017 Bankrs. All rights reserved.
//

import UIKit

class ChallengeAnswerTableViewController: UITableViewController {

    var provider: Provider!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = UITableViewAutomaticDimension
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return provider.challenges.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChallengeAnswerCell", for: indexPath) as! ChallengeAnswerTableViewCell

        let challenge = provider.challenges[indexPath.row]
        cell.configureForChallenge(challenge)

        return cell
    }

    @IBAction func createAccess(_ sender: Any) {
        let challengeAnswers = provider.challenges.enumerated().map { (row: Int, challenge: Challenge) -> ChallengeAnswer in
            let cell = self.tableView.cellForRow(at: IndexPath(row: row, section: 0)) as! ChallengeAnswerTableViewCell
            return ChallengeAnswer(id: challenge.id, value: cell.textField.text!, store: false)
        }
        BankrsApi.addAccess(providerId: provider.id, answers: challengeAnswers) { (jobURL, error) in
            if error == nil {
                self.performSegue(withIdentifier: "unwindToAccesses", sender: self)
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
