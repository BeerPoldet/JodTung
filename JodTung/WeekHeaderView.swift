//
//  WeekHeaderView.swift
//  JodTung
//
//  Created by Poldet Assanangkornchai on 10/27/2559 BE.
//  Copyright © 2559 Poldet Assanangkornchai. All rights reserved.
//

import UIKit

@IBDesignable
class WeekHeaderView: UIView {

  @IBOutlet weak var view: UIView!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    setup()
  }
  
  private func setup() {
    
    let bundle = Bundle(for: WeekHeaderView.self)
    let nib = UINib(nibName: String(describing: WeekHeaderView.self), bundle: bundle)
//    view = nib.instantiate(withOwner: self, options: nil).first as! UIView
    nib.instantiate(withOwner: self, options: nil)
    
    addSubview(view)
    view.frame = bounds
  }
}
