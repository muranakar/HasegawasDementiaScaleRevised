//
//  ImageListViewController.swift
//  HasegawasDementiaScaleRevised
//
//  Created by 村中令 on 2022/03/26.
//

import UIKit

class ImageListViewController: UIViewController {
    @IBOutlet private weak var image1: UIImageView!
    @IBOutlet private weak var image2: UIImageView!
    @IBOutlet private weak var image3: UIImageView!
    @IBOutlet private weak var image4: UIImageView!
    @IBOutlet private weak var image5: UIImageView!
    private var imageViews: [UIImageView] {
        [image1, image2, image3, image4, image5]
    }
    private let imageNames = ["Hair", "Coin", "Clock", "Pen", "Key"]
    private var dictionaryImageAndImageName: [UIImageView: String] {
        [UIImageView: String](uniqueKeysWithValues: zip(imageViews, imageNames))
    }
    private var tapImageName = ""
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction private func imageViewTapped(_ sender: UITapGestureRecognizer) {
        // 参考；　https://teratail.com/questions/116922
        guard let image = sender.view as? UIImageView else {
            return
        }
        tapImageName = dictionaryImageAndImageName[image]!
        performSegue(withIdentifier: "AnimatedTransitioning", sender: nil)
    }

    @IBSegueAction
    func makePastAssessment(
        coder: NSCoder,
        sender: Any?,
        segueIdentifier: String?
    ) -> AnimatedTransitioningViewController? {
        AnimatedTransitioningViewController(coder: coder, imageName: tapImageName)
    }

    @IBAction private func backToImageListTableViewController(segue: UIStoryboardSegue) {
    }
}
