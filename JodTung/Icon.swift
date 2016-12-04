//
//  Icon.swift
//  JodTung
//
//  Created by Dev on 12/2/2559 BE.
//  Copyright © 2559 Poldet Assanangkornchai. All rights reserved.
//

import UIKit

protocol IconImageFactory {
    func image(forIcon icon: Icon) -> UIImage
}

enum Icon: String {
    
    case breakfast = "breakfast"
    case lunch = "lunch"
    case dinner = "dinner"
    case drink = "drink"
    case snack = "snack"
    
    case mrt = "mrt"
    case bts = "bts"
    case train = "train"
    case taxi = "taxi"
    case fuel = "fuel"
    
    case income = "income"
    case salary = "salary"
        
    var name: String {
        return rawValue
    }
    
    func image(usingFactory iconImageFactory: IconImageFactory) -> UIImage {
        return iconImageFactory.image(forIcon: self)
    }
}
