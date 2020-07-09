//
//  PresentMenuAnimator.swift
//  Apprtc
//
//  Created by Aashish Adhikari on 1/30/18.
//  Copyright © 2018 Aashish Adhikari. All rights reserved.
//

import UIKit

public class PresentMenuAnimator : NSObject {
    var direction: Direction
    
    public init(direction: Direction) {
        self.direction = direction
    }
    
    public var shadowOpacity: Float = 0.7
}

extension PresentMenuAnimator : UIViewControllerAnimatedTransitioning {
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
        containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        
        // replace main view with snapshot
        let snapshot = fromVC.view.snapshotView(afterScreenUpdates: false)
        snapshot?.tag = MenuHelper.snapshotNumber
        snapshot?.isUserInteractionEnabled = false
        snapshot?.layer.shadowOpacity = shadowOpacity
        containerView.insertSubview(snapshot!, aboveSubview: toVC.view)
        fromVC.view.isHidden = true
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
                if self.direction == .Left{
                    snapshot!.center.x += UIScreen.main.bounds.width * MenuHelper.menuWidth
                }else{
                    snapshot!.center.x -= UIScreen.main.bounds.width * MenuHelper.menuWidth
                }
        },
            completion: { _ in
                fromVC.view.isHidden = false
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        )
    }
}
