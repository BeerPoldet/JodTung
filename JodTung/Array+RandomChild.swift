//
//  Array+RandomChild.swift
//  JodTung
//
//  Created by Poldet Assanangkornchai on 11/18/2559 BE.
//  Copyright © 2559 Poldet Assanangkornchai. All rights reserved.
//

import Foundation

extension Array {
    var random: Element {
        return self[Int.random(range: 0..<count)]
    }
}
