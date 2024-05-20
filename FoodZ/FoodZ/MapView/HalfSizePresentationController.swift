//
//  HalfSizePresentationController.swift
//  FoodZ
//
//  Created by surexnx on 20.05.2024.
//

import UIKit

final class HalfSizePresentationController: UIPresentationController {

    // MARK: Private properties

    private let dimmingView = UIView()

    // MARK: Internal methods

    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return .zero }
        return CGRect(
            x: 0,
            y: containerView.bounds.height - containerView.bounds.height / 3,
            width: containerView.bounds.width,
            height: containerView.bounds.height / 3
        )
    }
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        setupDimmingView()
    }

    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }

        dimmingView.frame = containerView.bounds
        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        dimmingView.alpha = 0.0
        containerView.insertSubview(dimmingView, at: 0)

        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
            guard let self = self else { return }

            dimmingView.alpha = 1.0
        }, completion: nil)
    }

    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
            guard let self = self else { return }

            dimmingView.alpha = 0.0
        }, completion: { [weak self]  _ in
            guard let self = self else { return }
            dimmingView.removeFromSuperview()
        })
    }

    // MARK: Private methods

    @objc private func handleTap(recognizer: UITapGestureRecognizer) {
        presentingViewController.dismiss(animated: true, completion: nil)
     }

    private func setupDimmingView() {
        dimmingView.alpha = 0.0
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        dimmingView.addGestureRecognizer(tapRecognizer)
    }
}
