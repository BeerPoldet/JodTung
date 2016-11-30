//
//  CategoryGroupCollectionViewCell.swift
//  JodTung
//
//  Created by Poldet Assanangkornchai on 11/22/2559 BE.
//  Copyright © 2559 Poldet Assanangkornchai. All rights reserved.
//

import UIKit

class CategoryGroupCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var label: RoundedLabel!
    
    override var isSelected: Bool {
        didSet {
            updateSelection()
        }
    }
    
    var categoryGroup: CategoryGroup? { didSet { updateUI() } }
    
    private func updateUI() {
        if let categoryGroup = categoryGroup {
            label.text = categoryGroup.title
        }
        updateSelection()
    }
    
    private func updateSelection() {
        label?.backgroundHidden = !isSelected
        label?.textColor = isSelected ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
}
