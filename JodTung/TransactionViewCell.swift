//
//  TransactionViewCell.swift
//  JodTung
//
//  Created by Poldet Assanangkornchai on 11/19/2559 BE.
//  Copyright © 2559 Poldet Assanangkornchai. All rights reserved.
//

import UIKit

class TransactionViewCell: UITableViewCell {
    
    @IBOutlet weak var categoryTitleLabel: UILabel!
    @IBOutlet weak var transactionNoteLabel: UILabel!
    @IBOutlet weak var transactionValueLabel: UILabel!
    @IBOutlet weak var transactionCreationDateLabel: UILabel!
    
    var transaction: Transaction? {
        didSet {
            updateUI()
        }
    }
    
    private var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm a"
        return formatter
    }
    
    private func updateUI() {
        categoryTitleLabel.text = transaction?.category?.title
        transactionNoteLabel.text = transaction?.note ?? ""
        transactionValueLabel.text = String(format: "%.1f", transaction?.value ?? 0)
        
        transactionCreationDateLabel.text = formatter.string(from: (transaction?.creationDate)!)
    }
}
