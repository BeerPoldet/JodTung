
class AccountBootstrapFactory {
    let dataStorage: DataStorage
    
    init(dataStorage: DataStorage) {
        self.dataStorage = dataStorage
    }
    
    struct CategoryGroupBootstrap {
        var title: String
        var type: TransactionType
        var categories: [CategoryBoostrap]
    }
    
    struct CategoryBoostrap {
        var title: String
    }
    
    let bootstrapDatas = [
        CategoryGroupBootstrap(
            title: "Food",
            type: .expense,
            categories: [
                CategoryBoostrap(title: "Breakfast"),
                CategoryBoostrap(title: "Lunch"),
                CategoryBoostrap(title: "Dinner"),
                CategoryBoostrap(title: "Drink"),
                CategoryBoostrap(title: "Snack")
            ]
        ),
        CategoryGroupBootstrap(
            title: "Transport",
            type: .expense,
            categories: [
                CategoryBoostrap(title: "MRT"),
                CategoryBoostrap(title: "BTS"),
                CategoryBoostrap(title: "Train"),
                CategoryBoostrap(title: "Taxi"),
                CategoryBoostrap(title: "Fuel")
            ]
        ),
        CategoryGroupBootstrap(
            title: "Income",
            type: .income,
            categories: [
                CategoryBoostrap(title: "Income"),
                CategoryBoostrap(title: "Salary")
            ]
        ),
    ]
    
    func boostrap() {
        bootstrapDatas.forEach { (categoryGroupData) in
            let categoryGroup = self.dataStorage.makeCategoryGroup()
            categoryGroup.title = categoryGroupData.title
            categoryGroup.type = categoryGroupData.type
            categoryGroupData.categories.forEach{ (categoryData) in
                let category = self.dataStorage.makeCategory()
                category.title = categoryData.title
                categoryGroup.addToCategories(category)
            }
        }
    }
}
