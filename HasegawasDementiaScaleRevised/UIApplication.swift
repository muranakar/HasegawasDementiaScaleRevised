//
//  UIApplication.swift
//  TimerAssessment
//
//  Created by Takehito Koshimizu on 2022/02/20.
//

import UIKit

extension UIApplication {
    // MARK: -
    /// Twitter を開く
    @IBAction private func openTwitter(sender: Any) {
        let url = URL(string: "https://twitter.com/iOS76923384")!
        open(url, options: [:], completionHandler: nil)
    }
}
