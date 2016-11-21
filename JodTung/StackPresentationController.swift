//
//  StackPresentationController.swift
//  JodTung
//
//  Created by Poldet Assanangkornchai on 11/19/2559 BE.
//  Copyright © 2559 Poldet Assanangkornchai. All rights reserved.
//

import UIKit

class StackPresentationController: UIPresentationController {
    
    private let topMarginFromContainer = CGFloat(40)
    
    lazy var dimmingView: UIView = {
        let dimmingView = UIView()
        dimmingView.backgroundColor = UIColor(white: 0, alpha: 0.4)
        dimmingView.alpha = 0
        
        dimmingView.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(StackPresentationController.dimmingViewDidTap(_:))
            )
        )
        
        return dimmingView
    }()
    
    func dimmingViewDidTap(_ gesture: UIGestureRecognizer) {
        if gesture.state == .recognized {
            presentingViewController.dismiss(animated: true, completion: nil)
        }
    }
    
    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else {
            return
        }
        
        dimmingView.frame = containerView.bounds
        dimmingView.alpha = 0
        
        containerView.insertSubview(dimmingView, at: 0)
        
        guard let transitionCoordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 1
            return
        }
        
        transitionCoordinator.animate(alongsideTransition: { (context) in
            self.dimmingView.alpha = 1
        })
    }
    
    override func dismissalTransitionWillBegin() {
        guard let transitionCoordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 0
            return
        }
        
        transitionCoordinator.animate(alongsideTransition: { (context) in
            self.dimmingView.alpha = 0
        })
    }
    
    override var adaptivePresentationStyle: UIModalPresentationStyle {
        return .overFullScreen
    }
    
    override func containerViewWillLayoutSubviews() {
        if let containerView = containerView {
            dimmingView.frame = containerView.bounds
        }
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    override var shouldPresentInFullscreen: Bool { return true }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        let presentedViewOrigin = CGPoint(x: 0, y: topMarginFromContainer)
        let presentedViewSize = CGSize(
            width: containerView?.bounds.width ?? 0,
            height: (containerView?.bounds.height ?? 0) - topMarginFromContainer
        )
        return CGRect(origin: presentedViewOrigin, size: presentedViewSize)
    }
}
