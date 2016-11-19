//
//  ExtendedTable.swift
//  JodTung
//
//  Created by Poldet Assanangkornchai on 11/19/2559 BE.
//  Copyright © 2559 Poldet Assanangkornchai. All rights reserved.
//

import UIKit

@IBDesignable
class ExtendedTable: UITableView {
    @IBInspectable var topContentInset: CGFloat = 0 { didSet { updateContentInsetFromInterfaceBuilder() } }
    @IBInspectable var bottomContentInset: CGFloat = 0 { didSet { updateContentInsetFromInterfaceBuilder() } }
    @IBInspectable var leftContentInset: CGFloat = 0 { didSet { updateContentInsetFromInterfaceBuilder() } }
    @IBInspectable var rightContentInset: CGFloat = 0 { didSet { updateContentInsetFromInterfaceBuilder() } }
    
    private func updateContentInsetFromInterfaceBuilder() {
        contentInset = UIEdgeInsets(
            top: topContentInset,
            left: leftContentInset,
            bottom: bottomContentInset,
            right: rightContentInset
        )
        scrollIndicatorInsets = contentInset
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
    }
}
