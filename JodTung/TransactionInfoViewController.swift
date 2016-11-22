//
//  TransactionInfoViewController.swift
//  JodTung
//
//  Created by Poldet Assanangkornchai on 11/19/2559 BE.
//  Copyright © 2559 Poldet Assanangkornchai. All rights reserved.
//

import UIKit

class TransactionInfoViewController: UIViewController {
    
    // MARK: - Injected Properties
    
    var accountant: Accountant! {
        didSet {
            categoryGroups = accountant.categoryGroups!
            selectedCategoryGroup = categoryGroups.first
            
            categoryGroupCollectionView?.reloadData()
        }
    }
    
    // MARK: - Properties
    
    fileprivate var categoryGroups = [CategoryGroup]()
    fileprivate var selectedCategoryGroup: CategoryGroup? {
        didSet {
            guard let selectedCategoryGroup = selectedCategoryGroup,
                let categoriesOfSelectedGroup = selectedCategoryGroup.categoryList else { return }
            
            selectedCategories = categoriesOfSelectedGroup
        }
    }
    fileprivate var selectedCategories = [Category]() {
        didSet {
            selectedCategory = selectedCategories.first
            
            categoryCollectionView?.reloadData()
            categoryCollectionView?.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: false)
        }
    }
    fileprivate var selectedCategory: Category?
    
    // MARK: - Outlets
    
    @IBOutlet weak var categoryGroupCollectionView: UICollectionView! {
        didSet {
            categoryGroupCollectionView.dataSource = self
            categoryGroupCollectionView.delegate = self
        }
    }
    @IBOutlet weak var categoryCollectionView: UICollectionView! {
        didSet {
            categoryCollectionView.dataSource = self
            categoryCollectionView.delegate = self
        }
    }
    
    // MARK: - View Controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        modalPresentationCapturesStatusBarAppearance = true
        
        categoryGroupCollectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNeedsStatusBarAppearanceUpdate()
    }
    
    // MARK: - Status Bar
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    // MARK: - Constant
    
    struct Storyboard {
        struct CollectionViewCell {
            static let categoryGroup = String(describing: CategoryGroupCollectionViewCell.self)
            static let category = String(describing: CategoryCollectionViewCell.self)
        }
    }
}

extension TransactionInfoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryGroupCollectionView {
            return categoryGroups.count
        } else {
            return selectedCategories.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryGroupCollectionView {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: Storyboard.CollectionViewCell.categoryGroup,
                for: indexPath
            ) as! CategoryGroupCollectionViewCell
            
            cell.categoryGroup = categoryGroups[indexPath.row]
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: Storyboard.CollectionViewCell.category,
                for: indexPath
                ) as! CategoryCollectionViewCell
            
            cell.category = selectedCategories[indexPath.row]
            
            return cell
        }
    }
}

extension TransactionInfoViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryGroupCollectionView {
            selectedCategoryGroup = categoryGroups[indexPath.row]
        } else {
            
        }
    }
}
