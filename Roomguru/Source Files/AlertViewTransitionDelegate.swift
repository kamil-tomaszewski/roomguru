//
//  AlertViewTransitionDelegate.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 11/05/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Darwin
import UIKit
import Async

class AlertViewTransitionDelegate: NSObject {
    
    private var presentAnimationController = PresentAlertViewAnimationController()
    private var dismissAnimationController = DismissAlertViewAnimationController()
    
    private weak var bindedViewController: UIViewController?
    
    private var beginPoint: CGPoint?
    private var panGestureRecognizer: UIPanGestureRecognizer?
    
    private var shouldDismiss = false
    
    func bindViewController(controller: UIViewController, withView view: UIView) {
        unbindViewController()
        bindedViewController = controller
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "didPanGesture:")
        view.addGestureRecognizer(panGestureRecognizer!)
    }
    
    func unbindViewController() {
        if let recognizer = panGestureRecognizer {
            bindedViewController?.view.removeGestureRecognizer(recognizer)
            panGestureRecognizer = nil
        }
        bindedViewController = nil
    }
    
    func didPanGesture(recognizer: UIPanGestureRecognizer) {
        
        var view = recognizer.view!
        var dynamicAnimator = presentAnimationController.dynamicAnimator
        
        switch recognizer.state {
        case .Began:
            shouldDismiss = false
            beginPoint = view.center
            dynamicAnimator?.removeAllBehaviors()
        case .Changed:
            let currentPoint = recognizer.translationInView(recognizer.view!)
            let currentCenter = CGPointMake(beginPoint!.x + currentPoint.x, beginPoint!.y + currentPoint.y)
            let distance = currentCenter.distanceTo(beginPoint!)
            shouldDismiss = recognizer.velocityInView(view.superview!).y > 5000 || distance > 180
            view.center = currentCenter
        default:
            if shouldDismiss {
                bindedViewController!.dismissViewControllerAnimated(true) {
                    self.unbindViewController()
                    self.presentAnimationController.clean()
                    self.dismissAnimationController.clean()
                }
            } else {
                let point = presentAnimationController.snappedToPoint
                dynamicAnimator?.addBehavior(UISnapBehavior(item: view, snapToPoint: point!))
            }
        }
    }
}

extension AlertViewTransitionDelegate: UIViewControllerTransitioningDelegate {
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentAnimationController
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismissAnimationController
    }
}


class AlertViewAnimationController: NSObject, UIViewControllerAnimatedTransitioning {    
    
    var dynamicAnimator: UIDynamicAnimator?
    var snappedToPoint: CGPoint?
    
    func clean() {
        dynamicAnimator = nil
        snappedToPoint = nil
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.8
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {}
}


class PresentAlertViewAnimationController: AlertViewAnimationController {

    override func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! MaskingViewController
        
        let maskingView = toViewController.aView.maskingView
        let toView = toViewController.aView.contentView
        let fromView = fromViewController.view
        
        let fromViewCenter = fromView.center
        
        let containerView = transitionContext.containerView()
        containerView.addSubview(toViewController.view)
        
        let snapPoint = CGPointMake(fromViewCenter.x, fromViewCenter.y - 100)
        dynamicAnimator = UIDynamicAnimator(referenceView: containerView)
        dynamicAnimator?.addBehavior(UISnapBehavior(item: toView, snapToPoint: snapPoint))

        maskingView.alpha = 0.0
        UIView.animateWithDuration(0.25) {
            maskingView.alpha = 0.7
        }
        
        Async.main(after: transitionDuration(transitionContext)) {
            self.dynamicAnimator?.removeAllBehaviors()
            self.snappedToPoint = snapPoint
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
    }
}

class DismissAlertViewAnimationController: AlertViewAnimationController {
    
    override func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! MaskingViewController

        let maskingView = fromViewController.aView.maskingView
        let fromView = fromViewController.aView.contentView
        
        let containerView = transitionContext.containerView()
        containerView.addSubview(fromViewController.view)
        
        dynamicAnimator = UIDynamicAnimator(referenceView: transitionContext.containerView())
        
        let gravityBehavior = UIGravityBehavior(items: [fromView])
        gravityBehavior.magnitude = 20.0
        dynamicAnimator?.addBehavior(gravityBehavior)
        
        maskingView.alpha = 0.7
        UIView.animateWithDuration(transitionDuration(transitionContext)) {
            maskingView.alpha = 0.0
        }
        
        Async.main(after: transitionDuration(transitionContext)) {
            self.dynamicAnimator = nil
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
    }
}

private extension UIViewController {
    
    func topParentView() -> UIView {
        if let tabBarController = tabBarController {
            return tabBarController.view
        } else if let navigationController = navigationController {
            return navigationController.view
        }
        return view
    }
}

extension CGPoint {

    func distanceTo(point: CGPoint) -> CGFloat {
        let x_diff = pow(point.x - x, 2)
        let y_diff = pow(point.y - y, 2)
        return sqrt(x_diff + y_diff)
    }
}
