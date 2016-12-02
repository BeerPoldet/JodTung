//
//  Icon.swift
//  JodTung
//
//  Created by Dev on 12/2/2559 BE.
//  Copyright © 2559 Poldet Assanangkornchai. All rights reserved.
//

import Foundation

protocol IconBuilder {
    associatedtype Item: Icon
    typealias Content = Item.Content
    
    var breakfast: Item { get }
    var lunch: Item { get }
    var dinner: Item { get }
    var drink: Item { get }
    var snack: Item { get }
    
    var mrt: Item { get }
    var bts: Item { get }
    var train: Item { get }
    var taxi: Item { get }
    var fuel: Item { get }
    
    var income: Item { get }
    var salary: Item { get }
    
}

protocol Icon {
    associatedtype Content
    var data: String { get }
    var content: Content { get }
}
