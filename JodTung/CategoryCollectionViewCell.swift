//
//  CategoryCollectionViewCell.swift
//  JodTung
//
//  Created by Poldet Assanangkornchai on 11/22/2559 BE.
//  Copyright © 2559 Poldet Assanangkornchai. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    var category: Category? { didSet { updateUI() } }
    
    func updateUI() {
        if let category = category {
            label.text = category.title
        }
    }
}
