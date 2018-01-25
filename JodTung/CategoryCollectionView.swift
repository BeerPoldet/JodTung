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
        isPagingEnabled = false
        let pageCollectionViewFlowLayout = PagingCollectionViewFlowLayout()
        self.collectionViewLayout = pageCollectionViewFlowLayout
        pageCollectionViewFlowLayout.scrollDirection = .horizontal
//        pageCollectionViewFlowLayout.itemSize = CGSize(width: 150, height: 100)
    }
    
    // MARK: - Constant
    
    fileprivate struct Storyboard {
        struct CollectionViewCell {
            static let category = String(describing: CategoryCollectionViewCell.self)
        }
    }
}

// MARK: - CategoryCollectionView CollectionViewDelegate

extension CategoryCollectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("FUCK?")
        print(collectionView.frame.width)
        print(collectionView.frame.width / 4)
        let numberOfItemsPerRow = 4
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(numberOfItemsPerRow - 1))
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(numberOfItemsPerRow))
        print(size)
        return CGSize(width: size, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
}

protocol CategoryCollectionViewDelegate: class {
    func categoryCollectionView(_ collectionView: CategoryCollectionView, didSelect category: Category)
}
