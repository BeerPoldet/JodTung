//
//  CategoryInfo.swift
//  JodTung
//
//  Created by Poldet Assanangkornchai on 11/12/2559 BE.
//  Copyright © 2559 Poldet Assanangkornchai. All rights reserved.
//

import Foundation

struct CategoryInfo {
    var uniqueIdentifier: String?
    var title: String?
    var iconName: String?
    
    init() {
        
    }
    
    init(category: Category) {
        self.uniqueIdentifier = category.uniqueIdentifier
        self.title = category.title
        self.iconName = category.iconName
    }
}
