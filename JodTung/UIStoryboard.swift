//
//  UIStoryboard.swift
//  JodTung
//
//  Created by Poldet Assanangkornchai on 11/2/2559 BE.
//  Copyright © 2559 Poldet Assanangkornchai. All rights reserved.
//

import UIKit

extension UIStoryboard {
  func instantiateViewController<T>(withType type: T.Type) -> T {
    let storyboardIdentifier = String(describing: type)
    let viewController = instantiateViewController(withIdentifier: storyboardIdentifier)
    assert(viewController is T, "Instantiate view controller with" +
      " result: \(viewController) failed. You have not named view controller's" +
      " storyboard identifier correctly it suppose to be \(storyboardIdentifier)")
    return viewController as! T
  }
}
