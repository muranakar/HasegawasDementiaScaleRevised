//
//  AssessmentFlowUITests.swift
//  HasegawasDementiaScaleRevisedUITests
//
//  評価者の登録から評価の保存・再表示までを一通り操作して、
//  SwiftUI + SwiftData へ移行したあとも評価が正しく記録されることを確認する。
//

import XCTest

final class AssessmentFlowUITests: XCTestCase {

    private var app: XCUIApplication!

    /// 各設問で選ぶ選択肢（すべて満点。合計30点になる）
    private let fullScoreChoices = [
        "正解：１点",
        "全部正解：４点",
        "ヒントなし：２点",
        "３つ正解：３点",
        "２つ正解：２点",
        "２つ正解：２点",
        "６点",
        "５つ正解：５点",
        "１０個以上：５点"
    ]

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    /// 評価者登録 → 対象者登録 → HDS-R評価 → 結果確認 → 履歴確認
    func testAssessmentFlowSavesFullScore() throws {
        let assessorName = "テスト評価者"
        let targetPersonName = "テスト対象者"

        addAssessor(named: assessorName)
        tap(app.buttons[assessorName], "評価者の行")

        addTargetPerson(named: targetPersonName)
        tap(app.buttons[targetPersonName], "対象者の行")

        tap(app.buttons["評価する"], "評価するボタン")

        // 9問すべてに満点で回答する
        for (index, choice) in fullScoreChoices.enumerated() {
            let button = app.buttons[choice].firstMatch
            XCTAssertTrue(
                button.waitForExistence(timeout: 5),
                "\(index + 1)問目の選択肢『\(choice)』が見つからない"
            )
            button.tap()
        }

        // 合計30点として保存されている
        let totalScore = app.staticTexts["30 / 30 点"]
        XCTAssertTrue(totalScore.waitForExistence(timeout: 5), "合計点が 30 / 30 点 になっていない")

        // 各項目の点数も表示されている
        XCTAssertTrue(app.staticTexts["年齢"].exists, "項目名が表示されていない")

        tap(app.buttons["完了"], "完了ボタン")

        // 履歴に1件残っている
        tap(app.buttons["過去の評価をみる"], "過去の評価をみるボタン")
        XCTAssertTrue(
            app.staticTexts["30 / 30 点"].waitForExistence(timeout: 5),
            "履歴に評価結果が表示されていない"
        )
    }

    /// 評価を中止した場合は保存されない
    func testCancelledAssessmentIsNotSaved() throws {
        let assessorName = "中止テスト評価者"
        let targetPersonName = "中止テスト対象者"

        addAssessor(named: assessorName)
        tap(app.buttons[assessorName], "評価者の行")
        addTargetPerson(named: targetPersonName)
        tap(app.buttons[targetPersonName], "対象者の行")

        tap(app.buttons["評価する"], "評価するボタン")
        tap(app.buttons[fullScoreChoices[0]].firstMatch, "1問目の選択肢")

        tap(app.buttons["中止"], "中止ボタン")
        tap(app.buttons["中止する"], "中止する")

        tap(app.buttons["過去の評価をみる"], "過去の評価をみるボタン")
        XCTAssertTrue(
            app.staticTexts["評価結果がありません"].waitForExistence(timeout: 5),
            "中止した評価が保存されてしまっている"
        )
    }

    // MARK: - 補助

    private func addAssessor(named name: String) {
        tap(app.buttons["評価者を追加"], "評価者を追加ボタン")
        let field = app.textFields["評価者名"]
        XCTAssertTrue(field.waitForExistence(timeout: 5), "評価者名の入力欄が出ない")
        field.tap()
        field.typeText(name)
        tap(app.buttons["保存"], "保存ボタン")
    }

    private func addTargetPerson(named name: String) {
        tap(app.buttons["対象者を追加"], "対象者を追加ボタン")
        let field = app.textFields["対象者名"]
        XCTAssertTrue(field.waitForExistence(timeout: 5), "対象者名の入力欄が出ない")
        field.tap()
        field.typeText(name)
        tap(app.buttons["保存"], "保存ボタン")
    }

    private func tap(_ element: XCUIElement, _ description: String, file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertTrue(element.waitForExistence(timeout: 10), "\(description)が見つからない", file: file, line: line)
        element.tap()
    }
}
