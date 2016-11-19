//
//  CalendarViewControllerAnimatedTransitioning.swift
//  JodTung
//
//  Created by Poldet Assanangkornchai on 11/5/2559 BE.
//  Copyright © 2559 Poldet Assanangkornchai. All rights reserved.
//

import UIKit

class CollapsingViewControllerAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    weak var dataSource: CalendarViewControllerAnimatedTransitioningDataSource!
    fileprivate var isExpanding: Bool
    
    init(isExpanding: Bool) {
        self.isExpanding = isExpanding
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isExpanding {
            animateCollapsingTransition(using: transitionContext)
        } else {
            animateExpandingTransition(using: transitionContext)
        }
        
        isExpanding = !isExpanding
    }
    
    fileprivate func animateExpandingTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) else { return }
        
        let containerView = transitionContext.containerView
        let contentView = dataSource.contentViewToFadeIn()
        let expandedHeight = dataSource.expendedHeight()
        let expandableLayoutConstraint = dataSource.expandableLayoutConstraint()
        
        containerView.addSubview(toView)
        
        contentView.alpha = 0
        expandableLayoutConstraint.constant = 0
        toView.layoutIfNeeded()
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
                contentView.alpha = 1
                expandableLayoutConstraint.constant = expandedHeight
                toView.layoutIfNeeded()
        }) { (completion) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    fileprivate func animateCollapsingTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from),
            let toView = transitionContext.view(forKey: .to) else { return }
        
        let containerView = transitionContext.containerView
        let contentView = dataSource.contentViewToFadeIn()
        let expandableLayoutConstraint = dataSource.expandableLayoutConstraint()
        
        containerView.addSubview(toView)
        containerView.addSubview(fromView)
        
        contentView.alpha = 1
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
                contentView.alpha = 0
                expandableLayoutConstraint.constant = 0
                fromView.layoutIfNeeded()
        }) { (completion) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
}

protocol CalendarViewControllerAnimatedTransitioningDataSource: class {
    func expandableLayoutConstraint() -> NSLayoutConstraint
    
    func expendedHeight() -> CGFloat
    
    func contentViewToFadeIn() -> UIView
}
