//
//  TransactionViewCell.swift
//  JodTung
//
//  Created by Poldet Assanangkornchai on 11/19/2559 BE.
//  Copyright © 2559 Poldet Assanangkornchai. All rights reserved.
//

import UIKit

class TransactionViewCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var categoryTitleLabel: UILabel!
    @IBOutlet weak var transactionNoteLabel: UILabel!
    @IBOutlet weak var transactionValueLabel: UILabel!
    @IBOutlet weak var transactionCreationDateLabel: UILabel!
    
    var transaction: Transaction? { didSet { updateUI() } }
    
    var iconImageFactory: IconImageFactory? { didSet { updateIcon() } }
    
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
        
        updateIcon()
    }
    
    private func updateIcon() {
        guard let transaction = transaction,
            let iconImageFactory = iconImageFactory else { return }
        
        let icon = Icon(rawValue: transaction.category!.iconName!)
        
        iconImageView.image = iconImageFactory.image(forIcon: icon!)
    }
}
