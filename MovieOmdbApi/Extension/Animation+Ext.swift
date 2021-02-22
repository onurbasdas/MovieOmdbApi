//
//  Animation+Ext.swift
//  MovieOmdbApi
//
//  Created by Onur Başdaş on 22.02.2021.
//

import UIKit

class AnimationController:NSObject{
    
    private let animationDuration: Double
    private let animationType: AnimationType
    
    enum AnimationType {
        case present
        case dismiss
    }
    
    init(animationDuration: Double, animationType: AnimationType){
        self.animationDuration = animationDuration
        self.animationType = animationType
    }
 
    
}

extension AnimationController: UIViewControllerAnimatedTransitioning{
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(exactly: animationDuration) ?? 0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to),
              let fromViewController = transitionContext.viewController(forKey: .from) else {
            transitionContext.completeTransition(false)
            return
        }
        switch animationType {
        case .present:
            transitionContext.containerView.addSubview(toViewController.view)
            presentAnimation(with: transitionContext, viewToAnimate: toViewController.view)
        case .dismiss:
            print("Implement this")
        }
    }
    
    func presentAnimation(with transitionContext: UIViewControllerContextTransitioning, viewToAnimate: UIView) {
        viewToAnimate.clipsToBounds = true
        viewToAnimate.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.80, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            viewToAnimate.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }){ _ in
            transitionContext.completeTransition(true)
        }

    }
    
}
