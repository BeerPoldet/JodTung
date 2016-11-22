//
//  CategoryGroupCollectionViewCell.swift
//  JodTung
//
//  Created by Poldet Assanangkornchai on 11/22/2559 BE.
//  Copyright © 2559 Poldet Assanangkornchai. All rights reserved.
//

import UIKit

class CategoryGroupCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    var categoryGroup: CategoryGroup? { didSet { updateUI() } }
    
    private func updateUI() {
        if let categoryGroup = categoryGroup {
            label.text = categoryGroup.title
        }
    }
}
