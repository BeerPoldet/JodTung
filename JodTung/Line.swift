//
//  Line.swift
//  JodTung
//
//  Created by Dev on 11/29/2559 BE.
//  Copyright © 2559 Poldet Assanangkornchai. All rights reserved.
//

import UIKit

@IBDesignable
class Line: UIView {
    @IBInspectable var lineWidth: CGFloat = 1
    @IBInspectable var color: UIColor = UIColor.black
    
    override func draw(_ rect: CGRect) {
        
        color.set()
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: bounds.minX, y: bounds.midY))
        path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.midY))
        path.lineWidth = lineWidth
        path.stroke()
    }
}
