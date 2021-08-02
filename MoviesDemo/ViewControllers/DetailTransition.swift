//
//  DetailTransition.swift
//  MoviesDemo
//
//  Created by Andrew Cheberyako on 01.08.2021.
//

import UIKit


public protocol DetailTransitionAnimatorDelegate: class {

    func transitionWillStart()

    func transitionDidEnd()

    func referenceImage() -> UIImage?

    func imageFrame() -> CGRect?
}

public class DetailPushTransition: NSObject, UIViewControllerAnimatedTransitioning {
    fileprivate let fromDelegate: DetailTransitionAnimatorDelegate
    fileprivate let detailVC: MoreInfoCompositionLayout

    fileprivate let transitionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.accessibilityIgnoresInvertColors = true
        return imageView
    }()

    init?(
        fromDelegate: Any,
        toPhotoDetailVC detailVC: MoreInfoCompositionLayout
    ) {
        guard let fromDelegate = fromDelegate as? DetailTransitionAnimatorDelegate else {
            return nil
        }
        self.fromDelegate = fromDelegate
        self.detailVC = detailVC
    }
    
    

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.38
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        let toView = transitionContext.view(forKey: .to)
        let fromView = transitionContext.view(forKey: .from)
//        let fromReferenceFrame = detailVC.imageFrame()

        let containerView = transitionContext.containerView
        toView?.alpha = 0
        [fromView, toView]
            .compactMap { $0 }
            .forEach {
                containerView.addSubview($0)
        }
        let transitionImage = fromDelegate.referenceImage()!
        transitionImageView.image = transitionImage
        transitionImageView.frame = fromDelegate.imageFrame()
            ?? DetailPushTransition.defaultOffscreenFrameForPresentation(image: transitionImage, forView: toView!)
        
        let toReferenceFrame = DetailPushTransition.calculateZoomInImageFrame(image: transitionImage, forView: toView!)
//        let toReferenceFrame = self.fromDelegate.imageFrame() ??
//            DetailPopTransition.defaultOffscreenFrameForDismissal(
//                transitionImageSize: fromReferenceFrame!.size,
//                screenHeight: containerView.bounds.height
//        )
        
        containerView.addSubview(self.transitionImageView)

        self.fromDelegate.transitionWillStart()
        self.detailVC.transitionWillStart()

        let duration = self.transitionDuration(using: transitionContext)
        let spring: CGFloat = 0.95
        let animator = UIViewPropertyAnimator(duration: duration, dampingRatio: spring) {
            self.transitionImageView.frame = toReferenceFrame
//            toView?.alpha = 1
        }
        animator.addCompletion { (position) in
            assert(position == .end)
            self.transitionImageView.removeFromSuperview()
            self.transitionImageView.image = nil
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            self.detailVC.transitionDidEnd()
            self.fromDelegate.transitionDidEnd()
            toView?.alpha = 1
        }
        animator.startAnimation()
       
    }

    /// If no location is provided by the fromDelegate, we'll use an offscreen-bottom position for the image.
    private static func defaultOffscreenFrameForPresentation(image: UIImage, forView view: UIView) -> CGRect {
        var result = DetailPushTransition.calculateZoomInImageFrame(image: image, forView: view)
        result.origin.y = view.bounds.height
        return result
    }

    /// Because the photoDetailVC isn't laid out yet, we calculate a default rect here.
    // TODO: Move this into PhotoDetailViewController, probably!
    private static func calculateZoomInImageFrame(image: UIImage, forView view: UIView) -> CGRect {
//        let rect = CGRect.makeRect(aspectRatio: image.size, insideRect: view.bounds)
       
        
        let rect = CGRect(x: 10, y: 74, width: 355, height: 590)
        return rect
    }
    public static func defaultOffscreenFrameForDismissal(
        transitionImageSize: CGSize,
        screenHeight: CGFloat
    ) -> CGRect {
        return CGRect(
            x: 0,
            y: screenHeight,
            width: transitionImageSize.width,
            height: transitionImageSize.height
        )
    }
}


public class DetailPopTransition: NSObject, UIViewControllerAnimatedTransitioning {
    fileprivate let toDelegate: DetailTransitionAnimatorDelegate
    fileprivate let photoDetailVC: MoreInfoCompositionLayout

    /// The snapshotView that is animating between the two view controllers.
    fileprivate let transitionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.accessibilityIgnoresInvertColors = true
        return imageView
    }()

    /// If toDelegate isn't PhotoDetailTransitionAnimatorDelegate, returns nil.
    init?(
        toDelegate: Any,
        fromPhotoDetailVC photoDetailVC: MoreInfoCompositionLayout
        ) {
        guard let toDelegate = toDelegate as? DetailTransitionAnimatorDelegate else {
            return nil
        }

        self.toDelegate = toDelegate
        self.photoDetailVC = photoDetailVC
    }

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromView = transitionContext.view(forKey: .from)
        let toView = transitionContext.view(forKey: .to)
        let containerView = transitionContext.containerView
        let fromReferenceFrame = photoDetailVC.imageFrame()!

        let transitionImage = photoDetailVC.referenceImage()
        transitionImageView.image = transitionImage
        transitionImageView.frame = photoDetailVC.imageFrame()!

        [toView, fromView]
            .compactMap { $0 }
            .forEach { containerView.addSubview($0) }
        containerView.addSubview(transitionImageView)

        self.photoDetailVC.transitionWillStart()
        self.toDelegate.transitionWillStart()

        let duration = self.transitionDuration(using: transitionContext)
        let spring: CGFloat = 0.9
        let animator = UIViewPropertyAnimator(duration: duration, dampingRatio: spring) {
            fromView?.alpha = 0
        }
        animator.addCompletion { (position) in
            assert(position == .end)

            self.transitionImageView.removeFromSuperview()
            self.transitionImageView.image = nil
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            self.toDelegate.transitionDidEnd()
            self.photoDetailVC.transitionDidEnd()
        }
        animator.startAnimation()

        // HACK: By delaying 0.005s, I get a layout-refresh on the toViewController,
        // which means its collectionview has updated its layout,
        // and our toDelegate?.imageFrame() is accurate, even if
        // the device has rotated. :scream_cat:
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.005) {
            animator.addAnimations {
                let toReferenceFrame = self.toDelegate.imageFrame() ??
                    DetailPopTransition.defaultOffscreenFrameForDismissal(
                        transitionImageSize: fromReferenceFrame.size,
                        screenHeight: containerView.bounds.height
                )
                self.transitionImageView.frame = toReferenceFrame
            }
        }
    }

    /// If we need a "dummy reference frame", let's throw the image off the bottom of the screen.
    /// Photos.app transitions to CGRect.zero, though I think that's ugly.
    public static func defaultOffscreenFrameForDismissal(
        transitionImageSize: CGSize,
        screenHeight: CGFloat
    ) -> CGRect {
        return CGRect(
            x: 0,
            y: screenHeight,
            width: transitionImageSize.width,
            height: transitionImageSize.height
        )
    }
}


