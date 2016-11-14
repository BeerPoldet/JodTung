//
//  RoundedLabel.swift
//  JodTung
//
//  Created by Poldet Assanangkornchai on 10/19/2559 BE.
//  Copyright © 2559 Poldet Assanangkornchai. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedLabel: UILabel {
  
  @IBInspectable var layerBackgroundColor: UIColor = UIColor.red { didSet { updateViews() } }
  @IBInspectable var backgroundHidden: Bool = false { didSet { updateViews() } }
  @IBInspectable var isCircle: Bool = false { didSet { updateViews() } }
  @IBInspectable var cornerRadius: CGFloat = 5 { didSet { updateViews() } }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupViews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    setupViews()
  }
  
  private func setupViews() {
    layer.masksToBounds = true
    clipsToBounds = false
    
    updateViews()
  }
  
  private func updateViews() {
    if isCircle {
      layer.cornerRadius = min(bounds.width, bounds.height) / 2
    } else {
      layer.cornerRadius = cornerRadius
    }
    
    if !backgroundHidden {
      layer.backgroundColor = layerBackgroundColor.cgColor
    } else {
      layer.backgroundColor = UIColor.clear.cgColor
    }
    
    setNeedsDisplay()
  }
}
