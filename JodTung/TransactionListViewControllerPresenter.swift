//
//  TransactionListViewControllerPresenter.swift
//  JodTung
//
//  Created by Dev on 11/29/2559 BE.
//  Copyright © 2559 Poldet Assanangkornchai. All rights reserved.
//

import UIKit

class TransactionListViewControllerPresenter: NSObject {
    
    fileprivate lazy var viewControllerAnimatedTransitioning = StackViewControllerAnimatedTransitioning()
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        return dateFormatter
    }()
    
    func dateTitle(of date: Date) -> String {
        return dateFormatter.string(from: date)
    }
}

// MARK: - TransitioningDelgate

extension TransactionListViewControllerPresenter: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return viewControllerAnimatedTransitioning
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return viewControllerAnimatedTransitioning
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return StackPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
