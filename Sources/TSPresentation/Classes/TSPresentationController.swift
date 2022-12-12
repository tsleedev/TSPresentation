//
//  TSPresentationController.swift
//  TSFramework
//
//  Created by TAE SU LEE on 2021/10/13.
//

import UIKit

final class TSPresentationController: UIPresentationController {
    // MARK: - Properties
    private var dimmingView: UIView!
    private let transitionStyle: TSPresentationTransitionStyle
    private let frameSize: TSPresentaionFrameSize
    private let dimColor: UIColor
    
    override var frameOfPresentedViewInContainerView: CGRect {
        var frame: CGRect = .zero
        frame.size = size(forChildContentContainer: presentedViewController,
                          withParentContainerSize: containerView!.bounds.size)
        
        switch transitionStyle {
        case .rightToLeft:
            frame.origin.x = containerView!.frame.width - sizeWidth
        case .bottomToTop:
            frame.origin.y = containerView!.frame.height - sizeHeight
        default:
            frame.origin = .zero
        }
        return frame
    }
    
    private var sizeWidth: CGFloat {
        switch frameSize {
        case .full:
            return containerView!.frame.width
        case .half:
            return containerView!.frame.width * 0.5
        case .radio(let radio):
            return containerView!.frame.width * radio
        case .length(let width):
            return width
        }
    }
    
    private var sizeHeight: CGFloat {
        switch frameSize {
        case .full:
            return containerView!.frame.height
        case .half:
            return containerView!.frame.height * 0.5
        case .radio(let radio):
            return containerView!.frame.height * radio
        case .length(let height):
            return height
        }
    }
    
    // MARK: - Initializers
    init(presentedViewController: UIViewController,
         presenting presentingViewController: UIViewController?,
         transitionStyle: TSPresentationTransitionStyle,
         frameSize: TSPresentaionFrameSize,
         dimColor: UIColor) {
        self.transitionStyle = transitionStyle
        self.frameSize = frameSize
        self.dimColor = dimColor
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        setupDimmingView()
    }
    
    override func presentationTransitionWillBegin() {
        guard let dimmingView = dimmingView else {
            return
        }
        containerView?.insertSubview(dimmingView, at: 0)
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|[dimmingView]|",
                                                                   options: [],
                                                                   metrics: nil,
                                                                   views: ["dimmingView": dimmingView]))
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|[dimmingView]|",
                                                                   options: [],
                                                                   metrics: nil,
                                                                   views: ["dimmingView": dimmingView]))
        
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 1.0
            return
        }
        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 1.0
        })
    }
    
    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 0.0
            return
        }
        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0.0
        })
    }
    
    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    override func size(forChildContentContainer container: UIContentContainer,
                       withParentContainerSize parentSize: CGSize) -> CGSize {
        switch transitionStyle {
        case .leftToRight, .rightToLeft:
            return CGSize(width: sizeWidth, height: parentSize.height)
        case .bottomToTop, .topToBottom:
            return CGSize(width: parentSize.width, height: sizeHeight)
//        case .fadeIn:
//            return CGSize(width: parentSize.width, height: parentSize.height)
        default:
            return CGSize(width: parentSize.width, height: parentSize.height)
        }
    }
}

// MARK: - Private
private extension TSPresentationController {
    func setupDimmingView() {
        dimmingView = UIView()
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        dimmingView.backgroundColor = dimColor
        dimmingView.alpha = 0.0
        
        let recognizer = UITapGestureRecognizer(target: self,
                                                action: #selector(handleTap(recognizer:)))
        dimmingView.addGestureRecognizer(recognizer)
    }
    
    @objc func handleTap(recognizer: UITapGestureRecognizer) {
        presentingViewController.dismiss(animated: true)
    }
}
