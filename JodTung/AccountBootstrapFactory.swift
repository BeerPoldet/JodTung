
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
        var icon: Icon
    }
    
    let bootstrapDatas = [
        CategoryGroupBootstrap(
            title: "Food",
            type: .expense,
            categories: [
                CategoryBoostrap(title: "Breakfast", icon: Icon.breakfast),
                CategoryBoostrap(title: "Lunch", icon: Icon.lunch),
                CategoryBoostrap(title: "Dinner", icon: Icon.dinner),
                CategoryBoostrap(title: "Drink", icon: Icon.drink),
                CategoryBoostrap(title: "Snack", icon: Icon.snack)
            ]
        ),
        CategoryGroupBootstrap(
            title: "Transport",
            type: .expense,
            categories: [
                CategoryBoostrap(title: "MRT", icon: Icon.mrt),
                CategoryBoostrap(title: "BTS", icon: Icon.bts),
                CategoryBoostrap(title: "Train", icon: Icon.train),
                CategoryBoostrap(title: "Taxi", icon: Icon.taxi),
                CategoryBoostrap(title: "Fuel", icon: Icon.fuel)
            ]
        ),
        CategoryGroupBootstrap(
            title: "Income",
            type: .income,
            categories: [
                CategoryBoostrap(title: "Income", icon: Icon.income),
                CategoryBoostrap(title: "Salary", icon: Icon.salary)
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
                category.iconName = categoryData.icon.name
                categoryGroup.addToCategories(category)
            }
        }
    }
}
