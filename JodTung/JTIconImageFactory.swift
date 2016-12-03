//
//  JTIcon.swift
//  JodTung
//
//  Created by Dev on 12/2/2559 BE.
//  Copyright © 2559 Poldet Assanangkornchai. All rights reserved.
//

import UIKit

class JTIconImageFactory: IconImageFactory {
    
    func image(forIcon icon: Icon) -> UIImage {
        switch icon {
        case .breakfast:
            return #imageLiteral(resourceName: "Breakfast")
        case .lunch:
            return #imageLiteral(resourceName: "Lunch")
        case .dinner:
            return #imageLiteral(resourceName: "Dinner")
        case .drink:
            return #imageLiteral(resourceName: "Drink")
        case .snack:
            return #imageLiteral(resourceName: "Snack")
        case .mrt:
            return #imageLiteral(resourceName: "MRT")
        case .bts:
            return #imageLiteral(resourceName: "BTS")
        case .train:
            return #imageLiteral(resourceName: "Train")
        case .taxi:
            return #imageLiteral(resourceName: "Taxi")
        case .fuel:
            return #imageLiteral(resourceName: "Fuel")
        case .income:
            return #imageLiteral(resourceName: "Income")
        case .salary:
            return #imageLiteral(resourceName: "Salary")
        }
    }
}
