//
//  MiniPlayerTransitionManager.swift
//  NewProjectStructure
//
//  Created by Swapnil on 10/02/26.
//

import Foundation
import UIKit

class MiniPlayerTransitionManager: NSObject, UIViewControllerTransitioningDelegate {

    // The frame of the mini player in the window's coordinate system
    var originFrame: CGRect = .zero

    // Configuration
    var presentDuration: TimeInterval = 0.7
    var dismissDuration: TimeInterval = 0.8 // Slower dismissal as requested

    // Internal state tracking
    private var isPresenting: Bool = true

    // MARK: - UIViewControllerTransitioningDelegate

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = true
        return self
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = false
        return self
    }
}

// MARK: - UIViewControllerAnimatedTransitioning

extension MiniPlayerTransitionManager: UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return isPresenting ? presentDuration : dismissDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        let containerView = transitionContext.containerView
        let duration = self.transitionDuration(using: transitionContext)

        // Identify the view we are animating (The Player View)
        let playerView: UIView

        if isPresenting {
            playerView = transitionContext.view(forKey: .to) ?? transitionContext.viewController(forKey: .to)!.view
        } else {
            playerView = transitionContext.view(forKey: .from) ?? transitionContext.viewController(forKey: .from)!.view
        }

        // Initial setup
        if isPresenting {
            containerView.addSubview(playerView)
            playerView.layoutIfNeeded()

            // Start State: PlayerVC is sized to the Mini Player and transparent
            playerView.frame = originFrame
            playerView.alpha = 0
            playerView.clipsToBounds = true
            playerView.layer.cornerRadius = 8

        } else {
            // Dismissing: Ensure on top
            containerView.bringSubviewToFront(playerView)
        }

        // Calculate Final Frame
        let finalFrame = isPresenting ? containerView.bounds : originFrame
        let finalAlpha: CGFloat = isPresenting ? 1.0 : 0.0
        let finalCornerRadius: CGFloat = isPresenting ? 0 : 8

        // Settings for Smoothness
        // Higher damping (0.95) for dismissal = smoother, less bounce
        let damping: CGFloat = isPresenting ? 0.75 : 0.85
        let velocity: CGFloat = 0.0

        // Perform Animation
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: .curveEaseInOut) {

            playerView.frame = finalFrame
            playerView.alpha = finalAlpha
            playerView.layer.cornerRadius = finalCornerRadius
            playerView.layoutIfNeeded()

        } completion: { _ in
            let wasCancelled = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!wasCancelled)
        }
    }
}
