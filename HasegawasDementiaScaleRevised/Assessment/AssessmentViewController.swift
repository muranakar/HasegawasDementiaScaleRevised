//
//  AssessmentViewController.swift
//  HasegawasDementiaScaleRevised
//
//  Created by 村中令 on 2022/03/19.
//

import UIKit

class AssessmentViewController: UIViewController {
    private let targetPerson: TargetPerson
    private let repository: AssessmentRepository

    @IBOutlet private weak var progressTextLabel: UILabel!
    @IBOutlet private weak var progressView: UIProgressView!
    @IBOutlet private weak var assessmentItemTitleLabel: UILabel!
    @IBOutlet private weak var assessmentQuestionLabel: UILabel!
    @IBOutlet private weak var assessmentAttentionTextView: UITextView!
    @IBOutlet private weak var button1: UIButton!
    @IBOutlet private weak var button2: UIButton!
    @IBOutlet private weak var button3: UIButton!
    @IBOutlet private weak var button4: UIButton!
    @IBOutlet private weak var button5: UIButton!
    @IBOutlet private weak var button6: UIButton!
    @IBOutlet private weak var button7: UIButton!

    required init?(coder: NSCoder, targetPerson: TargetPerson, repository: AssessmentRepository) {
        self.targetPerson = targetPerson
        self.repository = repository
        super.init(coder: coder)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // JSONファイルから、デコードされた構造体を、配列で管理。
    private var hdsrAssessment: [HDSRAssessment] = []
    private var assessmentResultHDSR: [Int] = []
    private var hdsrIndex: Int = 0
    // ボタンの配列
    private var buttons: [UIButton] {
        [
            button1, button2, button3, button4, button5, button6, button7
        ]
    }
    private var hdsrButtonText: [String?] {
        [
            hdsrAssessment[hdsrIndex].button1Text,
            hdsrAssessment[hdsrIndex].button2Text,
            hdsrAssessment[hdsrIndex].button3Text,
            hdsrAssessment[hdsrIndex].button4Text,
            hdsrAssessment[hdsrIndex].button5Text,
            hdsrAssessment[hdsrIndex].button6Text,
            hdsrAssessment[hdsrIndex].button7Text
        ]
    }
    private var hdsrResultNum: [Int?] {
        [
            hdsrAssessment[hdsrIndex].button1ResultNumber,
            hdsrAssessment[hdsrIndex].button2ResultNumber,
            hdsrAssessment[hdsrIndex].button3ResultNumber,
            hdsrAssessment[hdsrIndex].button4ResultNumber,
            hdsrAssessment[hdsrIndex].button5ResultNumber,
            hdsrAssessment[hdsrIndex].button6ResultNumber,
            hdsrAssessment[hdsrIndex].button7ResultNumber
        ]
    }

    private var dictonaryButtonAndButtonText: [UIButton: String?] {
        [UIButton: String?](uniqueKeysWithValues: zip(buttons, hdsrButtonText))
    }

    private var dictonaryButtonAndButtonResultNum: [UIButton: Int?] {
        [UIButton: Int?](uniqueKeysWithValues: zip(buttons, hdsrResultNum))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        decodeHDSRJsonFile()
        // 以下、Viewに関するメソッド
        buttonViewConfigue()
        labelViewConfigue()
        textViewViewConfigue()
    }

    @IBAction private func decide(sender: UIButton) {
        assessmentResultHDSR.append(dictonaryButtonAndButtonResultNum[sender]!!)
        print(assessmentResultHDSR)
        hdsrIndex += 1
        if hdsrIndex == 9 {
            // TODO 画面遷移処理
            let assessmet = Assessment(resultHDSR: .init(
                itemAge: assessmentResultHDSR[0],
                itemDateOrientation: assessmentResultHDSR[1],
                itemPlaceOrientation: assessmentResultHDSR[2],
                itemMemory: assessmentResultHDSR[3],
                itemCalculation: assessmentResultHDSR[4],
                itemDigitSpan: assessmentResultHDSR[5],
                itemDelayedPlayback: assessmentResultHDSR[6],
                itemVisualMemory: assessmentResultHDSR[7],
                itemWordRecall: assessmentResultHDSR[8])
            )
            repository.add(value: assessmet, id: targetPerson.id)

        } else {
            buttonViewConfigue()
            labelViewConfigue()
            textViewViewConfigue()
        }
    }
}

// MARK: - Viewに関する変更
private extension AssessmentViewController {
    func labelViewConfigue() {
        assessmentItemTitleLabel.text = hdsrAssessment[hdsrIndex].itemName
        assessmentQuestionLabel.text = hdsrAssessment[hdsrIndex].itemQuestion
    }
    func textViewViewConfigue() {
        assessmentAttentionTextView.text = hdsrAssessment[hdsrIndex].itemAttention
    }
    func buttonViewConfigue() {
    buttons.forEach { button in
                button.isHidden = dictonaryButtonAndButtonText[button]! == nil
                button.setTitle(dictonaryButtonAndButtonText[button]!, for: .normal)
            }
    }
}

// MARK: - JSONファイルのデコーダー
private extension AssessmentViewController {
    ///　HDS-Rの評価に関する情報
    struct HDSRAssessment: Decodable {
        var itemName: String
        var itemQuestion: String
        var itemAttention: String
        var buttonNumber: Int
        var button1Text: String?
        var button2Text: String?
        var button3Text: String?
        var button4Text: String?
        var button5Text: String?
        var button6Text: String?
        var button7Text: String?
        var button1ResultNumber: Int?
        var button2ResultNumber: Int?
        var button3ResultNumber: Int?
        var button4ResultNumber: Int?
        var button5ResultNumber: Int?
        var button6ResultNumber: Int?
        var button7ResultNumber: Int?
    }

    private func decodeHDSRJsonFile() {
        let data: Data?
        guard let file = Bundle.main.url(forResource: "HDSR", withExtension: "json") else {
            fatalError("ファイルが見つかりません。メソッド名：[\(#function)]")
        }
        do {
            data  = try Data(contentsOf: file)
        } catch {
            fatalError("ファイルをロード不可。メソッド名：[\(#function)]")
        }

        do {
            guard let data = data else {
                fatalError("dataの中身が入っていない。メソッド名：[\(#function)]")
            }
            let decoder = JSONDecoder()
            hdsrAssessment = try decoder.decode([HDSRAssessment].self, from: data)
        } catch {
            fatalError("パース不可。メソッド名：[\(#function)]")
        }
    }
}
