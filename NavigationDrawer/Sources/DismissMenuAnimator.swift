//
//  DismissMenuAnimator.swift
//  Apprtc
//
//  Created by Aashish Adhikari on 1/30/18.
//  Copyright © 2018 Aashish Adhikari. All rights reserved.
//

import UIKit

public class DismissMenuAnimator : NSObject {
}

extension DismissMenuAnimator : UIViewControllerAnimatedTransitioning {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
            else {
                return
        }
        
        let containerView = transitionContext.containerView
        let snapshot = containerView.viewWithTag(MenuHelper.snapshotNumber)
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
                snapshot?.frame = CGRect(origin: CGPoint.zero, size: UIScreen.main.bounds.size)
        },
            completion: { _ in
                let didTransitionComplete = !transitionContext.transitionWasCancelled
                if didTransitionComplete {
                    containerView.insertSubview(toVC.view, aboveSubview: fromVC.view)
                    snapshot?.removeFromSuperview()
                }
                transitionContext.completeTransition(didTransitionComplete)
        }
        )
    }
}
