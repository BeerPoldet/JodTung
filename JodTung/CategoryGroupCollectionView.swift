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
//        let pageCollectionViewFlowLayout = PagingCollectionViewFlowLayout()
//        self.collectionViewLayout = pageCollectionViewFlowLayout
//        pageCollectionViewFlowLayout.scrollDirection = .horizontal
//        pageCollectionViewFlowLayout.itemSize = CGSize(width: bounds.width / 4 - 8, height: 40)
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

class PagingCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override var collectionViewContentSize: CGSize {
        let count: Int! = collectionView?.dataSource?.collectionView(collectionView!, numberOfItemsInSection: 0)
        var contentSize = canvasSize
        
        let page: Int = (count / Int(rowCount * columnCount))
        contentSize.width = CGFloat(page) * canvasSize.width
        
        return contentSize
    }
    
    var canvasSize: CGSize {
        return collectionView!.frame.size
    }
    
    var rowCount: Int {
        return Int(canvasSize.height - itemSize.height) / Int(itemSize.height + minimumInteritemSpacing) + 1
    }
    
    var columnCount: Int {
        return Int(canvasSize.width - itemSize.width) / Int(itemSize.width + minimumLineSpacing) + 1
    }
    
    func frame(forItemAt indexPath: IndexPath) -> CGRect {
        let x = columnCount > 1 ? CGFloat(columnCount - 1) * self.minimumLineSpacing : 0
        let y = rowCount > 1 ? CGFloat(rowCount - 1) * self.minimumInteritemSpacing : 0
        let pageMarginX = (canvasSize.width - CGFloat(columnCount) * self.itemSize.width - x) / 2.0
        let pageMarginY = (canvasSize.height - CGFloat(rowCount) * self.itemSize.height - y) / 2.0
        let page = indexPath.row / Int(rowCount * columnCount)
        let remainder = indexPath.row - page * Int(rowCount * columnCount)
        let row = remainder / Int(columnCount)
        let column = remainder - row * Int(columnCount)
        
        var cellFrame = CGRect.init(
            x: pageMarginX + CGFloat(column) * (self.itemSize.width + self.minimumLineSpacing),
            y: pageMarginY + CGFloat(row) * (self.itemSize.height + self.minimumInteritemSpacing),
            width: self.itemSize.width,
            height: self.itemSize.height)
        
        cellFrame.origin.x += CGFloat(page) * canvasSize.width
        
        return cellFrame
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attr = super.layoutAttributesForItem(at: indexPath)
        attr?.frame = frame(forItemAt: indexPath)
        return attr
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return super.layoutAttributesForElements(in: rect)?.filter({ (attr) -> Bool in
            let indexPath = attr.indexPath
            let itemFrame = self.frame(forItemAt: indexPath)
            return rect.intersects(itemFrame)
        })
    }
}
