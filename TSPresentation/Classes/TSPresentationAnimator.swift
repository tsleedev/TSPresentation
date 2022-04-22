//
//  TSPresentationAnimator.swift
//  TSFramework
//
//  Created by TAE SU LEE on 2021/10/13.
//

import UIKit

final class TSPresentationAnimator: NSObject {
    // MARK: - Properties
    var transitionStyle: TSPresentationTransitionStyle = .bottomToTop
    let isPresentation: Bool
    let duration: TimeInterval
    
    // MARK: - Initializers
    init(transitionStyle: TSPresentationTransitionStyle, isPresentation: Bool, duration: TimeInterval) {
        self.transitionStyle = transitionStyle
        self.isPresentation = isPresentation
        self.duration = duration
        super.init()
    }
}

// MARK: - UIViewControllerAnimatedTransitioning
extension TSPresentationAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch transitionStyle {
        case .none, .topToBottom, .leftToRight, .rightToLeft, .bottomToTop:
            move(transitionContext: transitionContext)
        case .fadeIn:
            fade(transitionContext: transitionContext)
        case .push:
            push(transitionContext: transitionContext)
        }
    }
}

// MARK: - Helper
private extension TSPresentationAnimator {
    func move(transitionContext: UIViewControllerContextTransitioning) {
        let key: UITransitionContextViewControllerKey = isPresentation ? .to : .from
        guard let controller = transitionContext.viewController(forKey: key)
        else { return }
        
        if isPresentation {
            transitionContext.containerView.addSubview(controller.view)
        }
        
        let presentedFrame = transitionContext.finalFrame(for: controller)
        var dismissedFrame = presentedFrame
        switch transitionStyle {
        case .none:
            break
        case .leftToRight:
            dismissedFrame.origin.x = -presentedFrame.width
        case .rightToLeft:
            dismissedFrame.origin.x = transitionContext.containerView.frame.size.width
        case .topToBottom:
            dismissedFrame.origin.y = -presentedFrame.height
        case .bottomToTop:
            dismissedFrame.origin.y = transitionContext.containerView.frame.size.height
        default:
            break
        }
        
        let initialFrame = isPresentation ? dismissedFrame : presentedFrame
        let finalFrame = isPresentation ? presentedFrame : dismissedFrame
        
        let animationDuration = transitionDuration(using: transitionContext)
        controller.view.frame = initialFrame
        UIView.animate(
            withDuration: animationDuration,
            animations: {
                controller.view.frame = finalFrame
            }, completion: { finished in
                if !self.isPresentation && !transitionContext.transitionWasCancelled {
                    controller.view.removeFromSuperview()
                }
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
    }
    
    func fade(transitionContext: UIViewControllerContextTransitioning) {
        let key: UITransitionContextViewControllerKey = isPresentation ? .to : .from
        guard let controller = transitionContext.viewController(forKey: key)
        else { return }
        
        if isPresentation {
            transitionContext.containerView.addSubview(controller.view)
        }
        
        controller.view.alpha = isPresentation ? 0 : 1
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
                controller.view.alpha = self.isPresentation ? 1 : 0
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
    func push(transitionContext: UIViewControllerContextTransitioning) {
        let formKey: UITransitionContextViewControllerKey = isPresentation ? .to : .from
        let toKey: UITransitionContextViewControllerKey = !isPresentation ? .to : .from
        guard
            let parentController = transitionContext.viewController(forKey: toKey),
            let controller = transitionContext.viewController(forKey: formKey)
        else { return }
        
        if isPresentation {
            transitionContext.containerView.addSubview(controller.view)
        }
        
        let parentPresentedFrame = transitionContext.finalFrame(for: parentController)
        let parentDismissedFrame = parentPresentedFrame.offsetBy(dx: parentPresentedFrame.width / -2, dy: 0)
        let presentedFrame = transitionContext.finalFrame(for: controller)
        let dismissedFrame = presentedFrame.offsetBy(dx: presentedFrame.width, dy: 0)
        
        let parentInitialFrame = isPresentation ? parentPresentedFrame : parentDismissedFrame
        let parentFinalFrame = isPresentation ? parentDismissedFrame : parentPresentedFrame
        let initialFrame = isPresentation ? dismissedFrame : presentedFrame
        let finalFrame = isPresentation ? presentedFrame : dismissedFrame
        
        let animationDuration = transitionDuration(using: transitionContext)
        parentController.view.frame = parentInitialFrame
        controller.view.frame = initialFrame
        UIView.animate(
            withDuration: animationDuration,
            animations: {
                parentController.view.frame = parentFinalFrame
                controller.view.frame = finalFrame
            }, completion: { finished in
                if !self.isPresentation && !transitionContext.transitionWasCancelled {
                    controller.view.removeFromSuperview()
                }
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
    }
}
