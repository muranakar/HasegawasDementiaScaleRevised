//
//  AnimatedTransitioningViewController.swift
//  HasegawasDementiaScaleRevised
//
//  Created by 村中令 on 2022/03/26.
//

import UIKit

class AnimatedTransitioningViewController: UIViewController {
    @IBOutlet weak private var imageView: UIImageView!

    private var imageName = ""
    fileprivate var isPresent = false

    required init?(coder: NSCoder, imageName: String) {
        self.imageName = imageName
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = UIImage(named: imageName)
        // 元のバックのビューは、とりあえず透明にして見えなくする
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)

        // UIVisualEffectViewを生成する
        let visualEffectView = UIVisualEffectView(frame: view.frame)
        // エフェクトの種類を設定
        visualEffectView.effect = UIBlurEffect(style: .regular)
        // UIVisualEffectViewを他のビューの下に挿入する
        view.insertSubview(visualEffectView, at: 0)
    }
}

extension AnimatedTransitioningViewController: UIViewControllerTransitioningDelegate,
                                               UIViewControllerAnimatedTransitioning {
    // MARK: - UIViewControllerTransitioningDelegate
    public func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            // 遷移時にTrasitionを担当する（UIViewControllerAnimatedTransitioningプロトコルを実装した）クラスを返す
            isPresent = true
            return self
        }

    public func animationController(
        forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            // 復帰時にTrasitionを担当する（UIViewControllerAnimatedTransitioningプロトコルを実装した）クラスを返す
            isPresent = false
            return self
        }

    func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?
    ) -> TimeInterval {
        return 0.7
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresent {
            animatePresentTransition(transitionContext: transitionContext)
        } else {
            animateDissmissalTransition(transitionContext: transitionContext)
        }
    }

    // 遷移時のTrastion処理
    private func animatePresentTransition(transitionContext: UIViewControllerContextTransitioning) {
        UIView.animate(
            withDuration: self.transitionDuration(
                using: transitionContext
            ),
            animations: {
                // 遷移のアニメーションなど
            },
            completion: { _ in
                transitionContext.completeTransition(true)
            })
    }

    // 復帰時のTrastion処理
    func animateDissmissalTransition(transitionContext: UIViewControllerContextTransitioning) {
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            // 遷移のアニメーションなど
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
    }
}
