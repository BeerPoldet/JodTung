//
//  LayerShadow.swift
//  JodTung
//
//  Created by Poldet Assanangkornchai on 10/24/2559 BE.
//  Copyright © 2559 Poldet Assanangkornchai. All rights reserved.
//

import UIKit

extension UINavigationBar {
  
  func removeDefaultShadow() {
    setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    shadowImage = UIImage()
  }
}
