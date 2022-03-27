//
//  UIAlertController.swift
//  TimerAssessment
//
//  Created by Takehito Koshimizu on 2022/02/20.
//

import UIKit

extension UIAlertController {
    /// 評価データのコピーが完了しました。
    static func copyingCompletedDetailAssessment() -> Self {
        let title = "コピー完了"
        let message = "評価データのコピーが\n完了しました。"
        let controller = self.init(title: title, message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return controller
    }

    /// データ内容のコピーが完了しました。
    static func copyingCompletedPastAssessment() -> Self {
        let title = "コピー完了"
        let message = "データ内容のコピーが\n完了しました。"
        let controller = self.init(title: title, message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return controller
    }

    static func checkStopAssessment(okHandler:@escaping () -> Void) -> Self {
        let title = "評価中止"
        let message = "入力データは途中保存されません。\n評価を中止しますか？"
        let alertController = self.init(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "中止する",
            style: .cancel) { _ in
                okHandler()
            }
        let cancelAction = UIAlertAction(title: "中止しない", style: .default)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        return alertController
    }
}
