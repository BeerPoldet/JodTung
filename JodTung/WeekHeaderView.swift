//
//  WeekHeaderView.swift
//  JodTung
//
//  Created by Poldet Assanangkornchai on 10/27/2559 BE.
//  Copyright © 2559 Poldet Assanangkornchai. All rights reserved.
//

import UIKit

@IBDesignable
class WeekHeaderView: UIView, StoryboardView {

  @IBOutlet weak var view: UIView!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    setup()
  }
}
