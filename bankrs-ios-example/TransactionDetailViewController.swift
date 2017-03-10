//
//  DetailViewController.swift
//  bankrs-ios-example
//
//  Created by Ingmar.Stein on 10.03.17.
//  Copyright © 2017 Ingmar.Stein. All rights reserved.
//

import UIKit

class TransactionDetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail.description
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    var detailItem: NSDate? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

}
