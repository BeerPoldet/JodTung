//
//  CategoryCollectionViewCell.swift
//  JodTung
//
//  Created by Poldet Assanangkornchai on 11/22/2559 BE.
//  Copyright © 2559 Poldet Assanangkornchai. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    var category: Category? { didSet { updateUI() } }
    var iconImageFactory: IconImageFactory? { didSet { updateIcon() } }
    
    struct SelectionBoundary {
        static let borderWitdh: CGFloat = 1
        static let borderColor: UIColor = UIColor(ired: 0, igreen: 122, iblue: 255, alpha: 1)
        static let inset: CGFloat = 5
        static let cornerRadius: CGFloat = 5
    }
    
    override var isSelected: Bool {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private func updateUI() {
        if let category = category {
            label.text = category.title
        }
        
        updateIcon()
    }
    
    private func updateIcon() {
        guard let category = category,
            let iconImageFactory = iconImageFactory,
            let icon = Icon(rawValue: category.iconName!) else { return }
        
        iconImageView?.image = iconImageFactory.image(forIcon: icon)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if !isSelected {
            return
        }
                
        let boundaryRect = CGRect(
            x: rect.origin.x + SelectionBoundary.inset,
            y: rect.origin.y + SelectionBoundary.inset,
            width: rect.width - (SelectionBoundary.inset * 2),
            height: rect.height - (SelectionBoundary.inset * 2))
        
        SelectionBoundary.borderColor.setStroke()
        let path = UIBezierPath(roundedRect: boundaryRect, cornerRadius: SelectionBoundary.cornerRadius)
        path.lineWidth = SelectionBoundary.borderWitdh
        path.stroke()
        
    }
}
