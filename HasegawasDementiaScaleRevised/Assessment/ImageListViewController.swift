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

    override func viewDidLoad() {
        super.viewDidLoad()
        //　参考　https://qiita.com/tanaka-tt/items/df1ebcc68f29e50c13c9
        image1.isUserInteractionEnabled = true
        image1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
    }

    @objc
    func tapped() {
        
    }
}
