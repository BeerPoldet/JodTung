//
//  StoryboardView.swift
//  JodTung
//
//  Created by Dev on 11/28/2559 BE.
//  Copyright © 2559 Poldet Assanangkornchai. All rights reserved.
//

import UIKit

protocol StoryboardView {
    func setup()
}

extension StoryboardView where Self: UIView {
    func setup() {
        let bundle = Bundle(for: Self.self)
        let nib = UINib(nibName: String(describing: Self.self), bundle: bundle)
        
        let view = nib.instantiate(withOwner: self, options: nil).first	 as! UIView
        view.frame = bounds
        
        addSubview(view)
    }
}
