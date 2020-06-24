//
//  FadeAnimator.swift
//  InstaPass
//
//  Created by 法好 on 2020/6/24.
//  Copyright © 2020 yuetsin. All rights reserved.
//

import UIKit

class FadeAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var duration: TimeInterval = 0.2
    
    init(duration animationDuration: TimeInterval) {
        super.init()
        duration = animationDuration
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard
            let fromView = transitionContext.view(forKey: .from),
            let toView = transitionContext.view(forKey: .to)
        else {
            return
        }
        
        containerView.addSubview(toView)
        toView.alpha = 0
        fromView.alpha = 1
        

        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
//                fromView.alpha = 0
                toView.alpha = 1
        }) { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            fromView.alpha = 0
        }
    }
}
