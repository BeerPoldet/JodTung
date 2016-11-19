//
//  StackViewControllerAnimatedTransitioning.swift
//  JodTung
//
//  Created by Poldet Assanangkornchai on 11/19/2559 BE.
//  Copyright © 2559 Poldet Assanangkornchai. All rights reserved.
//

import UIKit

class StackViewControllerAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    var isPresenting = false
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        if !isPresenting {
            animateStackIn(using: transitionContext)
        } else {
            animatePopOut(using: transitionContext)
        }
    }
    
    private func animateStackIn(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to),
            let fromView = transitionContext.view(forKey: .from),
            let toViewController = transitionContext.viewController(forKey: .to),
            let fromViewController = transitionContext.viewController(forKey: .from) else { return }
        
        let duration = transitionDuration(using: transitionContext)
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toView)
        
        let topViewFinalFrame = transitionContext.finalFrame(for: toViewController)
        var topViewInitialFrame = topViewFinalFrame
        topViewInitialFrame.origin.y += topViewInitialFrame.height
        
        toView.frame = topViewInitialFrame
        
        UIView.animate(
            withDuration: duration,
            delay: 0,
            usingSpringWithDamping: 300,
            initialSpringVelocity: 5,
            options: [.allowUserInteraction, .beginFromCurrentState],
            animations: {
                fromView.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
                toView.frame = topViewFinalFrame
            },
            completion: { (completion) in
                transitionContext.completeTransition(true)
            }
        )
        
        isPresenting = true
    }
    
    private func animatePopOut(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to),
            let fromView = transitionContext.view(forKey: .from),
            let toViewController = transitionContext.viewController(forKey: .to),
            let fromViewController = transitionContext.viewController(forKey: .from) else { return }
        
        let duration = transitionDuration(using: transitionContext)
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toView)
        
        let topViewFinalFrame = transitionContext.finalFrame(for: toViewController)
        var topViewInitialFrame = topViewFinalFrame
        topViewInitialFrame.origin.y += topViewInitialFrame.height
        
        toView.frame = topViewInitialFrame
        
        UIView.animate(
            withDuration: duration,
            delay: 0,
            usingSpringWithDamping: 300,
            initialSpringVelocity: 5,
            options: [.allowUserInteraction, .beginFromCurrentState],
            animations: {
                fromView.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
                toView.frame = topViewFinalFrame
        },
            completion: { (completion) in
                transitionContext.completeTransition(true)
        }
        )
        
        isPresenting = false
    }
}
