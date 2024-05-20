//
//  HalfSizePresentationController.swift
//  FoodZ
//
//  Created by surexnx on 20.05.2024.
//

import UIKit

final class HalfSizePresentationController: UIPresentationController {

    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return .zero }
        return CGRect(
            x: 0,
            y: containerView.bounds.height - containerView.bounds.height / 3,
            width: containerView.bounds.width,
            height: containerView.bounds.height / 3
        )
    }

    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }

        presentedView?.alpha = 0
        guard let presentedView = presentedView else { return }
        containerView.addSubview(presentedView)

        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.presentedView?.alpha = 1.0
        }, completion: nil)
    }

    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.presentedView?.alpha = 0.0
        }, completion: { _ in
            self.presentedView?.removeFromSuperview()
        })
    }
}
