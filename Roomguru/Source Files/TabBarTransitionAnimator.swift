//
//  TabBarTransitionAnimator.swift
//  Roomguru
//
//  Created by Aleksander Popko on 26.05.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

class TabBarTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    weak var tabBarController: TabBarController!
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let fromView: UIView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        let fromViewController: UIViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toView: UIView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        let toViewController: UIViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        
        transitionContext.containerView().addSubview(fromView)
        transitionContext.containerView().addSubview(toView)
        
        let fromViewControllerIndex = find(self.tabBarController.viewControllers
            as! [UIViewController], fromViewController)
        let toViewControllerIndex = find(self.tabBarController.viewControllers! as! [UIViewController], toViewController)
        
        let direction: CGFloat = (fromViewControllerIndex < toViewControllerIndex) ? 1 : -1
        
        toView.frame = CGRectMake(direction * toView.frame.width, 0, toView.frame.width, toView.frame.height)
        let fromNewFrame = CGRectMake(-1 * direction * fromView.frame.width, 0, fromView.frame.width, fromView.frame.height)
        
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
            toView.frame = fromView.frame
            fromView.frame = fromNewFrame
            }) { _ in
                transitionContext.completeTransition(true)
        }
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.25
    }
}
