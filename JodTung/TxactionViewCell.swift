//
//  TxactionViewCell.swift
//  JodTung
//
//  Created by Poldet Assanangkornchai on 11/19/2559 BE.
//  Copyright © 2559 Poldet Assanangkornchai. All rights reserved.
//

import UIKit

class TxactionViewCell: UITableViewCell {
    
    @IBOutlet weak var categoryTitleLabel: UILabel!
    @IBOutlet weak var txactionNoteLabel: UILabel!
    @IBOutlet weak var txactionValueLabel: UILabel!
    @IBOutlet weak var txactionCreationDateLabel: UILabel!
    
    var transaction: Transaction? {
        didSet {
            updateUI()
        }
    }
    
    class var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm a"
        return formatter
    }
    
    private func updateUI() {
        categoryTitleLabel.text = transaction?.category?.title
        txactionNoteLabel.text = transaction?.note ?? ""
        txactionValueLabel.text = String(format: "%.1f", transaction?.value ?? 0)
        
        txactionCreationDateLabel.text = TxactionViewCell.formatter.string(from: (transaction?.creationDate)!)
    }
}
