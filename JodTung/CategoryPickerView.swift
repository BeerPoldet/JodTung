import UIKit

class CategoryPickerView: UIView, StoryboardView {
    
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
    
    // MARK: - Injected Properties
    
    var categoryGroups = [CategoryGroup]() {
        didSet {
            setupSelectedCategoryGroups()
        }
    }
    
    var selectedTransactionType: TransactionType = .income {
        didSet {
            setupSelectedCategoryGroups()
        }
    }
    
    // MAKR: - Private Properties
    
    fileprivate var selectedCategoryGroups = [CategoryGroup]()
    fileprivate var selectedCategoryGroup: CategoryGroup? {
        didSet {
            guard let categoriesOfSelectedGroup = selectedCategoryGroup?.categoryList else { return }
            
            selectedCategories = categoriesOfSelectedGroup
        }
    }
    fileprivate var selectedCategories = [Category]() {
        didSet {
            selectedCategory = selectedCategories.first
            
            categoryCollectionView?.reloadData()
            if !selectedCategories.isEmpty {
                categoryCollectionView?.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: false)
            }
        }
    }
    
    // MARK: - SelectedCategoryGroup
    
    fileprivate func setupSelectedCategoryGroups() {
        selectedCategoryGroups = categoryGroups.filter({ (group) -> Bool in
            return group.type == selectedTransactionType
        })
        
        selectedCategoryGroup = selectedCategoryGroups.first
        categoryGroupCollectionView?.reloadData()
    }
    
    // MARK: - Public Properties
    
    var selectedCategory: Category?
    
    // MARK: - Object lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        categoryGroupCollectionView.register(
            UINib(nibName: Storyboard.CollectionViewCell.categoryGroup, bundle: nil),
            forCellWithReuseIdentifier: Storyboard.CollectionViewCell.categoryGroup
        )
        
        categoryCollectionView.register(
            UINib(nibName: Storyboard.CollectionViewCell.category, bundle: nil),
            forCellWithReuseIdentifier: Storyboard.CollectionViewCell.category
        )
                
        categoryGroupCollectionView.reloadData()
    }
    
    // MARK: - Constant
    
    struct Storyboard {
        struct CollectionViewCell {
            static let categoryGroup = String(describing: CategoryGroupCollectionViewCell.self)
            static let category = String(describing: CategoryCollectionViewCell.self)
        }
    }
}

// MARK: - CollectionViewDataSource

extension CategoryPickerView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryGroupCollectionView {
            return selectedCategoryGroups.count
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
            
            cell.categoryGroup = selectedCategoryGroups[indexPath.row]
            
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

// MARK: - CollectionViewDelegate

extension CategoryPickerView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryGroupCollectionView {
            selectedCategoryGroup = selectedCategoryGroups[indexPath.row]
        } else {
            
        }
    }
}
