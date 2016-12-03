//
//  CategoryCollectionView.swift
//  JodTung
//
//  Created by Dev on 11/30/2559 BE.
//  Copyright © 2559 Poldet Assanangkornchai. All rights reserved.
//

import UIKit

class CategoryCollectionView: UICollectionView {
    
    var categories = [Category]() {
        didSet {            
            reloadData()
        }
    }
    
    weak var viewDelegate: CategoryCollectionViewDelegate?
    
    var selectedCategory: Category? {
        get {
            if let selectedItem = indexPathsForSelectedItems?.first {
                return categories[selectedItem.item]
            }
            return nil
        }
        set {
            if let newSelected = newValue,
                let itemIndex = categories.index(of: newSelected) {
                let indexPath = IndexPath(item: itemIndex, section: 0)
                selectItem(at: indexPath,
                           animated: false,
                           scrollPosition: UICollectionViewScrollPosition.left)
                
                viewDelegate?.categoryCollectionView(self, didSelect: categories[indexPath.row])
            }
        }
    }
    
    var iconImageFactory: IconImageFactory?
    
    // MARK: - Private
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        register(
            UINib(nibName: Storyboard.CollectionViewCell.category, bundle: nil),
            forCellWithReuseIdentifier: Storyboard.CollectionViewCell.category)
        
        dataSource = self
        delegate = self
        allowsMultipleSelection = false
    }
    
    // MARK: - Constant
    
    fileprivate struct Storyboard {
        struct CollectionViewCell {
            static let category = String(describing: CategoryCollectionViewCell.self)
        }
    }
}

// MARK: - CategoryCollectionView CollectionViewDelegate

extension CategoryCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Storyboard.CollectionViewCell.category,
            for: indexPath) as! CategoryCollectionViewCell
        
        cell.category = categories[indexPath.row]
        cell.iconImageFactory = self.iconImageFactory
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewDelegate?.categoryCollectionView(self, didSelect: categories[indexPath.row])
    }
}

protocol CategoryCollectionViewDelegate: class {
    func categoryCollectionView(_ collectionView: CategoryCollectionView, didSelect category: Category)
}
