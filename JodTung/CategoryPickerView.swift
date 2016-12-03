import UIKit

class CategoryPickerView: UIView, StoryboardView {
    
    // MARK: - Outlets
    
    @IBOutlet weak var categoryGroupCollectionView: CategoryGroupCollectionView! {
        didSet {
            categoryGroupCollectionView.viewDelegate = self
        }
    }
    @IBOutlet weak var categoryCollectionView: CategoryCollectionView! {
        didSet {
            categoryCollectionView.viewDelegate = self
            categoryCollectionView.iconImageFactory = iconImageFactory
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
    
    fileprivate var selectedCategoryGroups = [CategoryGroup]() {
        didSet {
            categoryGroupCollectionView.categoryGroups = selectedCategoryGroups
            categoryGroupCollectionView.selectedCategoryGroup = selectedCategoryGroups.first
        }
    }
    
    fileprivate let iconImageFactory: IconImageFactory = JTIconImageFactory()
    
    // MARK: - SelectedCategoryGroup
    
    fileprivate func setupSelectedCategoryGroups() {
        selectedCategoryGroups = categoryGroups.filter({ (group) -> Bool in
            return group.type == selectedTransactionType
        })
    }
    
    // MARK: - Public Properties
    
    var selectedCategoryGroup: CategoryGroup? {
        return categoryGroupCollectionView.selectedCategoryGroup
    }
    
    var selectedCategory: Category? {
        return categoryCollectionView.selectedCategory
    }
    
    // MARK: - Object lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
}

// MARK: - CollectionViewDataSource

extension CategoryPickerView: CategoryGroupCollectionViewDelegate {
    func categoryGroupCollectionView(_ collectionView: CategoryGroupCollectionView, didSelect categoryGroup: CategoryGroup) {
        categoryCollectionView.categories = categoryGroup.categoryList!
        categoryCollectionView.selectedCategory = categoryCollectionView.categories.first
    }
}

extension CategoryPickerView: CategoryCollectionViewDelegate {
    func categoryCollectionView(_ collectionView: CategoryCollectionView, didSelect category: Category) {
        // DO NOTHING
    }
}
