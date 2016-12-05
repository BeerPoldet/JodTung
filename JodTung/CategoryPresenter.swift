//
//  CategoryPresenter.swift
//  JodTung
//
//  Created by Dev on 12/5/2559 BE.
//  Copyright © 2559 Poldet Assanangkornchai. All rights reserved.
//

import Foundation

protocol CategoryPresenter: class {
    func sorted(categories: [Category]) -> [Category]
}

extension CategoryPresenter {
    func sorted(categories: [Category]) -> [Category] {
        return categories.sorted {
            if let titleA = $0.title, let titleB = $1.title {
                return titleA < titleB
            }
            return true
        }
    }
}
