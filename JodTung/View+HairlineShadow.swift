//
//  View+HairlineShadow.swift
//  JodTung
//
//  Created by Poldet Assanangkornchai on 10/26/2559 BE.
//  Copyright © 2559 Poldet Assanangkornchai. All rights reserved.
//

import UIKit

extension UIView {
  
  func addShadow() {
    layer.masksToBounds = false
    layer.shadowOffset = CGSize(width: 0, height: 1 / UIScreen.main.scale)
    layer.shadowRadius = 0
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = 0.25
  }
}
