//
//  BlurVisualEffectView+HairlineShadow.swift
//  JodTung
//
//  Created by Poldet Assanangkornchai on 10/26/2559 BE.
//  Copyright © 2559 Poldet Assanangkornchai. All rights reserved.
//

import UIKit

@IBDesignable
class ShadowedBlurVisualEffectView: UIView {
  
  @IBOutlet var view: UIView!
  @IBOutlet weak var visualEffectView: UIVisualEffectView!
  @IBOutlet weak var shadowView: UIView!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    let nib = UINib(nibName: String(describing: ShadowedBlurVisualEffectView.self), bundle: Bundle(for: ShadowedBlurVisualEffectView.self))
    nib.instantiate(withOwner: self, options: nil)
    
    addSubview(view)
    view.frame = bounds
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    let nib = UINib(nibName: String(describing: ShadowedBlurVisualEffectView.self), bundle: Bundle(for: ShadowedBlurVisualEffectView.self))
    nib.instantiate(withOwner: self, options: nil)

    addSubview(view)
    view.frame = bounds
  }
  
  override func willMove(toWindow newWindow: UIWindow?) {
    super.willMove(toWindow: newWindow)
    
    shadowView.addShadow()
  }
}
