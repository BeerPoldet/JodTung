//
//  WeekNavbarView.swift
//  JodTung
//
//  Created by Poldet Assanangkornchai on 10/20/2559 BE.
//  Copyright © 2559 Poldet Assanangkornchai. All rights reserved.
//

import UIKit

class WeekNavbarView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func willMove(toWindow newWindow: UIWindow?) {
        layer.shadowOffset = CGSize(width: 0, height: 1 / UIScreen.main.scale)
        layer.shadowRadius = 0
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.25
    }
}
