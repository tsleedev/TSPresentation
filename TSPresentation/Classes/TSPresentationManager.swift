//
//  TSPresentationManager.swift
//  TSFramework
//
//  Created by TAE SU LEE on 2021/10/13.
//

import UIKit

public enum TSPresentationTransitionStyle {
    case none
    case leftToRight
    case topToBottom
    case rightToLeft
    case bottomToTop
    case fadeIn
}

public enum TSPresentaionFrameSize {
    case full
    case half
    case radio(CGFloat)
    case length(CGFloat)
}

private class TSInteractor: UIPercentDrivenInteractiveTransition {
    var hasStarted = false
    var shouldFinish = false
}

final public class TSPresentationManager: NSObject {
    // MARK: - Properties
    public var transitionStyle: TSPresentationTransitionStyle = .bottomToTop
    public var frameSize: TSPresentaionFrameSize = .full
    public var duration: TimeInterval = 0.3
    public var dimColor = UIColor.black.withAlphaComponent(0.85)
    public var disableCompactHeight = false
    public var isNeedPanGesture = false
    
    private let interactor = TSInteractor()
    private weak var parentViewController: UIViewController?
    
    public init(transitionStyle: TSPresentationTransitionStyle = .bottomToTop,
         dimColor: UIColor = UIColor.black.withAlphaComponent(0.85)) {
        self.transitionStyle = transitionStyle
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension TSPresentationManager: UIViewControllerTransitioningDelegate {
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = TSPresentationController(
            presentedViewController: presented,
            presenting: presenting,
            transitionStyle: transitionStyle,
            frameSize: frameSize,
            dimColor: dimColor
        )
        if let navigationController = presented as? UINavigationController,
           let rootViewController = navigationController.viewControllers.first {
            parentViewController = rootViewController
        } else {
            parentViewController = presented
        }
        removeGesture()
        if isNeedPanGesture {
            setPanGesture()
        }
        return presentationController
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TSPresentationAnimator(transitionStyle: transitionStyle, isPresentation: true, duration: duration)
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TSPresentationAnimator(transitionStyle: transitionStyle, isPresentation: false, duration: duration)
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
}

// MARK: - UIAdaptivePresentationControllerDelegate
extension TSPresentationManager: UIAdaptivePresentationControllerDelegate {
    public func adaptivePresentationStyle( for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        if traitCollection.verticalSizeClass == .compact && disableCompactHeight {
            return .overFullScreen
        } else {
            return .none
        }
    }
}

// MARK: - UIGestureRecognizerDelegate
extension TSPresentationManager: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// MARK: - Gesture
private extension TSPresentationManager {
    func setEdgePanGesture() {
        guard let view = parentViewController?.view else { return }
        
        let leftEdgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleLeftEdgeGesture(_:)))
        leftEdgeGesture.edges = .left
        view.addGestureRecognizer(leftEdgeGesture)
    }
    
    func setPanGesture() {
        guard let view = parentViewController?.view else { return }
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleLeftPanGesture(_:)))
        view.addGestureRecognizer(panGesture)
    }
    
    func removeGesture() {
        guard let view = parentViewController?.view else { return }
        if let recognizers = view.gestureRecognizers {
            for recognizer in recognizers {
                view.removeGestureRecognizer(recognizer)
            }
        }
    }
    
    @objc func handleLeftEdgeGesture(_ gesture: UIScreenEdgePanGestureRecognizer) {
        dismissAction(translation: gesture.translation(in: gesture.view), state: gesture.state)
    }
    
    @objc func handleLeftPanGesture(_ gesture: UIPanGestureRecognizer) {
        dismissAction(translation: gesture.translation(in: gesture.view), state: gesture.state)
    }
    
    func dismissAction(translation: CGPoint, state: UIGestureRecognizer.State) {
        guard let parentViewController = parentViewController, let view = parentViewController.view else { return }
        
        let percentThreshold: CGFloat = 0.4
        
        // convert y-position to downward pull progress (percentage)
        let verticalMovement: CGFloat
        if transitionStyle == .leftToRight {
            verticalMovement = -translation.x / view.bounds.width
        } else if transitionStyle == .bottomToTop {
            verticalMovement = translation.y / view.bounds.height
        } else {
            verticalMovement = translation.x / view.bounds.width
        }
        let downwardMovement = fmaxf(Float(verticalMovement), 0.0)
        let downwardMovementPercent = fminf(downwardMovement, 1.0)
        let progress = CGFloat(downwardMovementPercent)
        
        //        guard let interactor = interactor else { return }
        
        switch state {
        case .began:
            interactor.hasStarted = true
//            if isPushedFromNavigation {
//                parentViewController.navigationController?.popViewController(animated: true)
//            } else {
                parentViewController.dismiss(animated: true, completion: nil)
//            }
        case .changed:
            if interactor.hasStarted == false {
                interactor.hasStarted = true
//                if isPushedFromNavigation {
//                    parentViewController.navigationController?.popViewController(animated: true)
//                } else {
                    parentViewController.dismiss(animated: true, completion: nil)
//                }
            }
            interactor.shouldFinish = progress > percentThreshold
            interactor.update(progress)
        case .cancelled:
            interactor.hasStarted = false
            interactor.cancel()
        case .ended:
            interactor.hasStarted = false
            interactor.shouldFinish ? interactor.finish() : interactor.cancel()
        default:
            break
        }
    }
}
