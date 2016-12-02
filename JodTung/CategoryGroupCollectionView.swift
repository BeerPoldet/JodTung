//
//  CategoryGroupCollectionView.swift
//  JodTung
//
//  Created by Dev on 11/30/2559 BE.
//  Copyright © 2559 Poldet Assanangkornchai. All rights reserved.
//

import UIKit

class CategoryGroupCollectionView: UICollectionView {
    
    // MARK: - Public API
    
    var categoryGroups = [CategoryGroup]() {
        didSet {
            reloadData()
        }
    }
    var viewDelegate: CategoryGroupCollectionViewDelegate?
    var selectedCategoryGroup: CategoryGroup? {
        get {
            if let selectedItem = indexPathsForSelectedItems?.first {
                return categoryGroups[selectedItem.item]
            }
            return nil
        }
        set {
            if let newSelected = newValue,
                let itemIndex = categoryGroups.index(of: newSelected) {
                let indexPath = IndexPath(item: itemIndex, section: 0)
                selectItem(at: indexPath,
                           animated: false,
                           scrollPosition: UICollectionViewScrollPosition.left)
                
                viewDelegate?.categoryGroupCollectionView(self, didSelect: categoryGroups[indexPath.row])
            }
        }
    }
    
    // MARK: - Private Properties
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        register(
            UINib(nibName: Storyboard.CollectionViewCell.categoryGroup, bundle: nil),
            forCellWithReuseIdentifier: Storyboard.CollectionViewCell.categoryGroup)
        
        self.delegate = self
        self.dataSource = self
        self.allowsMultipleSelection = false
    }
    
    fileprivate struct Storyboard {
        struct CollectionViewCell {
            static let categoryGroup = String(describing: CategoryGroupCollectionViewCell.self)
        }
    }
}

extension CategoryGroupCollectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryGroups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Storyboard.CollectionViewCell.categoryGroup,
            for: indexPath) as! CategoryGroupCollectionViewCell
        
        cell.categoryGroup = categoryGroups[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewDelegate?.categoryGroupCollectionView(self, didSelect: categoryGroups[indexPath.row])
    }
}

protocol CategoryGroupCollectionViewDelegate: class {
    func categoryGroupCollectionView(_ collectionView: CategoryGroupCollectionView, didSelect categoryGroup: CategoryGroup)
}
