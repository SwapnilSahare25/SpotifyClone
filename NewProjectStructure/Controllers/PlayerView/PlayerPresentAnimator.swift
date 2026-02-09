//
//  PlayerPresentAnimator.swift
//  NewProjectStructure
//
//  Created by Swapnil on 09/02/26.
//

import Foundation
import UIKit

class PlayerPresentAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let originFrame: CGRect

  init(originFrame: CGRect){
    self.originFrame = originFrame
  }

  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.3
  }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.view(forKey: .to) else { return }

        let container = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: transitionContext.viewController(forKey: .to)!)

        toVC.frame = originFrame
        container.addSubview(toVC)

        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            toVC.frame = finalFrame
        }) { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}

class PlayerDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let originFrame: CGRect

  init(originFrame: CGRect){
    self.originFrame = originFrame
  }

  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.3
  }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.view(forKey: .from) else { return }

        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            fromVC.frame = self.originFrame
        }) { _ in
            fromVC.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}


class PlayerTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {

    var originFrame: CGRect = .zero

    func animationController(forPresented presented: UIViewController,presenting: UIViewController,source: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        return PlayerPresentAnimator(originFrame: originFrame)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PlayerDismissAnimator(originFrame: originFrame)
    }
}
