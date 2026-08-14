//
//  HDSRQuestion.swift
//  HasegawasDementiaScaleRevised
//
//  HDSR.json の設問定義。JSONのフォーマットは旧バージョンから変更していないため、
//  既存の HDSR.json をそのまま読み込める。
//

import Foundation

struct HDSRQuestion: Decodable, Identifiable {
    let itemName: String
    let itemQuestion: String
    let itemAttention: String
    let buttonNumber: Int

    private let button1Text: String?
    private let button2Text: String?
    private let button3Text: String?
    private let button4Text: String?
    private let button5Text: String?
    private let button6Text: String?
    private let button7Text: String?

    private let button1ResultNumber: Int?
    private let button2ResultNumber: Int?
    private let button3ResultNumber: Int?
    private let button4ResultNumber: Int?
    private let button5ResultNumber: Int?
    private let button6ResultNumber: Int?
    private let button7ResultNumber: Int?

    var id: String { itemName }

    /// 選択肢
    struct Choice: Identifiable, Hashable {
        let title: String
        let score: Int
        var id: String { "\(title)-\(score)" }
    }

    /// テキストと得点が揃っている選択肢だけを並べたもの
    var choices: [Choice] {
        let texts = [button1Text, button2Text, button3Text, button4Text,
                     button5Text, button6Text, button7Text]
        let scores = [button1ResultNumber, button2ResultNumber, button3ResultNumber, button4ResultNumber,
                      button5ResultNumber, button6ResultNumber, button7ResultNumber]

        return zip(texts, scores).compactMap { text, score in
            guard let text, let score else { return nil }
            return Choice(title: text, score: score)
        }
    }
}

// MARK: - 読み込み
extension HDSRQuestion {
    /// 視覚記憶の設問。この設問のときだけ画像一覧を提示する
    static let visualMemoryIndex = 7

    /// バンドルの HDSR.json を読み込む
    static func loadAll() -> [HDSRQuestion] {
        guard let url = Bundle.main.url(forResource: "HDSR", withExtension: "json") else {
            assertionFailure("HDSR.json がバンドルに含まれていません")
            return []
        }
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode([HDSRQuestion].self, from: data)
        } catch {
            assertionFailure("HDSR.json の読み込みに失敗しました: \(error)")
            return []
        }
    }
}
