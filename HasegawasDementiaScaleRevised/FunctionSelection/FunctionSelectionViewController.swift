//
//  FunctionSelectionViewController.swift
//  TimerAssessment
//
//  Created by 村中令 on 2022/02/01.
//

import UIKit
import StoreKit

final class FunctionSelectionViewController: UIViewController {
    private let targetPerson: TargetPerson
    private let repository: TargetPersonRepository

    required init?(coder: NSCoder, targetPerson: TargetPerson, repository: TargetPersonRepository) {
        self.targetPerson = targetPerson
        self.repository = repository
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = targetPerson.name
    }

    @IBAction private func shareTwitter(_ sender: Any) {
        shareOnTwitter()
    }
    @IBAction private func shareLine(_ sender: Any) {
        shareOnLine()
    }
    @IBAction private func shareOtherApp(_ sender: Any) {
        shareOnOtherApp()
    }
    @IBAction private func review(_ sender: Any) {
        let urlString = URL(string: "https://apps.apple.com/app/id1616574755?action=write-review")
        guard let writeReviewURL = urlString else {
            fatalError("Expected a valid URL")
        }
        UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
    }
    private func shareOnTwitter() {
        // シェアするテキストを作成
        let text = "認知機能検査のHDS-Rを評価することが可能！"
        // swiftlint:disable:next line_length
        let hashTag = " #ADL #長谷川式 #認知機能 #病院 #クリニック #在宅 #医師 #理学療法士 #作業療法士 #言語聴覚士 #介護 #評価 #認知　#認知評価   \nhttps://apps.apple.com/jp/app/hds-r/id1616574755"
        let completedText = text + "\n" + hashTag

        // 作成したテキストをエンコード
        let encodedText = completedText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

        // エンコードしたテキストをURLに繋げ、URLを開いてツイート画面を表示させる
        if let encodedText = encodedText,
           let url = URL(string: "https://twitter.com/intent/tweet?text=\(encodedText)") {
            UIApplication.shared.open(url)
        }
    }

    private  func shareOnLine() {
        let urlscheme: String = "https://line.me/R/share?text="
        // swiftlint:disable:next line_length
        let message = "認知機能検査のHDS-Rを評価することが可能！\n #ADL #長谷川式 #認知機能 #病院 #クリニック #在宅 #医師 #理学療法士 #作業療法士 #言語聴覚士 #介護 #評価 #認知　#認知評価   \nhttps://apps.apple.com/jp/app/hds-r/id1616574755"

        // line:/msg/text/(メッセージ)
        let urlstring = urlscheme + "/" + message

        // URLエンコード
        guard let  encodedURL =
                urlstring.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) else {
            return
        }

        // URL作成
        guard let url = URL(string: encodedURL) else {
            return
        }

        if UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: { (succes) in
                    //  LINEアプリ表示成功
                })
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            // LINEアプリが無い場合
            let alertController = UIAlertController(title: "エラー",
                                                    message: "LINEがインストールされていません",
                                                    preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default))
            present(alertController,animated: true,completion: nil)
        }
    }

    private func shareOnOtherApp() {
        let url = URL(string: "https://sites.google.com/view/muranakar")
        if UIApplication.shared.canOpenURL(url!) {
            UIApplication.shared.open(url!)
        }
    }
}

// MARK: - Segue
extension FunctionSelectionViewController {
    @IBSegueAction
    func makeAssessment(coder: NSCoder, sender: Any?, segueIdentifier: String?) -> AssessmentViewController? {
        AssessmentViewController(
            coder: coder,
            targetPerson: targetPerson,
            repository: Repository.assessment()
        )
    }

    @IBSegueAction
    func makePastAssessment(coder: NSCoder, sender: Any?, segueIdentifier: String?) -> PastAssessmentViewController? {
        PastAssessmentViewController(
            coder: coder,
            targetPerson: targetPerson,
            repository: Repository.assessment()
        )
    }

    @IBAction private func backToFunctionSelectionTableViewController(segue: UIStoryboardSegue) {
        let reviewNum = ReviewRepository.processAfterAddReviewNumPulsOneAndSaveReviewNum()
        if reviewNum == 10 || reviewNum == 31 || reviewNum == 50 {
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
            }
        }
    }
}
