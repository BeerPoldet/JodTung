//
//  UIColor.swift
//  JodTung
//
//  Created by Dev on 12/1/2559 BE.
//  Copyright © 2559 Poldet Assanangkornchai. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(ired: Int, igreen: Int, iblue: Int, alpha: CGFloat) {
        self.init(
            red: CGFloat(ired) / 255,
            green: CGFloat(igreen) / 255,
            blue: CGFloat(iblue) / 255,
            alpha: alpha)
    }
}
