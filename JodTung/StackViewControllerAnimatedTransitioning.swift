//
//  StackViewControllerAnimatedTransitioning.swift
//  JodTung
//
//  Created by Poldet Assanangkornchai on 11/19/2559 BE.
//  Copyright © 2559 Poldet Assanangkornchai. All rights reserved.
//

import UIKit

/**
    Modal presentation/dismissal transition,
    at presenting state it'll move and scale "FromView" down behind and "ToView" comes up from bottom of screen,
    at dismissal state it'll move "FromView" downward out of screen and "ToView" which currently stays
    at the bottom will move and scale back to it's normal position/size
 */
class StackViewControllerAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    private struct Config {
        struct BottomView {
            static let scale = CGFloat(0.9)
            static let shiftUp = CGFloat(5)
            static let scalingTransform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
    
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
            let toViewController = transitionContext.viewController(forKey: .to),
            let fromViewController = transitionContext.viewController(forKey: .from),
            let fromView = fromViewController.view else { return }
        
        let duration = transitionDuration(using: transitionContext)
        
        let bottomView = fromView
        let topView = toView
        
        let topViewFinalFrame = transitionContext.finalFrame(for: toViewController)
        var topViewInitialFrame = topViewFinalFrame
        topViewInitialFrame.origin.y += topViewInitialFrame.height
        
        let containerView = transitionContext.containerView
        containerView.addSubview(topView)
        
        topView.frame = topViewInitialFrame
        
        UIView.animate(
            withDuration: duration,
            delay: 0,
            usingSpringWithDamping: 300,
            initialSpringVelocity: 5,
            options: [.allowUserInteraction, .beginFromCurrentState],
            animations: {
                bottomView.center.y -= Config.BottomView.shiftUp
                bottomView.transform = Config.BottomView.scalingTransform
                
                topView.frame = topViewFinalFrame
            },
            completion: { (completion) in
                transitionContext.completeTransition(true)
            }
        )
        
        isPresenting = true
    }
    
    private func animatePopOut(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to),
            let toView = toViewController.view,
            let fromViewController = transitionContext.viewController(forKey: .from),
            let fromView = transitionContext.view(forKey: .from) else { return }
        
        let duration = transitionDuration(using: transitionContext)
        
        let bottomView = toView
        let topView = fromView
        
        let topViewInitialFrame = transitionContext.finalFrame(for: fromViewController)
        var topViewFinalFrame = topViewInitialFrame
        
        topViewFinalFrame.origin.y += topViewInitialFrame.height
        topView.frame = topViewInitialFrame
        
        UIView.animate(
            withDuration: duration,
            delay: 0,
            usingSpringWithDamping: 300,
            initialSpringVelocity: 5,
            options: [.allowUserInteraction, .beginFromCurrentState],
            animations: {
                bottomView.frame.origin.y += 5
                bottomView.transform = CGAffineTransform(scaleX: 1, y: 1)
                topView.frame = topViewFinalFrame
            },
            completion: { (completion) in
                topView.removeFromSuperview()
                transitionContext.completeTransition(true)
            }
        )
        
        isPresenting = false
    }
}
