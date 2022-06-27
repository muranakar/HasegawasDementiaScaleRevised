//
//  RootNavigationController.swift
//  HasegawasDementiaScaleRevised
//
//  Created by 村中令 on 2022/03/16.
//

import UIKit

class RootNavigationController: UINavigationController {
    override func awakeFromNib() {
        super.awakeFromNib()
        UINavigationBar.setupAppearance()
    }
}

private extension UINavigationBar {
    static func setupAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "navigation")!
        let navigationBar = self.appearance()
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.compactAppearance = appearance
    }
}
