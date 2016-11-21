//
//  CalendarViewControllerAnimatedTransitioning.swift
//  JodTung
//
//  Created by Poldet Assanangkornchai on 11/5/2559 BE.
//  Copyright © 2559 Poldet Assanangkornchai. All rights reserved.
//

import UIKit

/**
 Present State: Expanding View and Fade In Content View which supplied by DataSource
 Dismissal State: Collapse View and Fade Out Content View
 In order to us this animation transition you have to supply DataSource that will give:
 
 Parameters
 expandableLayoutConstaint, expandedHeight, contentView
 
 */
class CollapsingViewControllerAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    weak var dataSource: CollapsingViewControllerAnimatedTransitioningDataSource!
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
        let contentView = dataSource.contentView()
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
        let contentView = dataSource.contentView()
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

protocol CollapsingViewControllerAnimatedTransitioningDataSource: class {
    
    func expandableLayoutConstraint() -> NSLayoutConstraint
    
    func expendedHeight() -> CGFloat
    
    func contentView() -> UIView
}
