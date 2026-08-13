//
//  HDSRLogicTests.swift
//  HasegawasDementiaScaleRevisedTests
//
//  集計・コピー文字列・削除の連鎖が、旧バージョンと同じ結果になることを確認する。
//

import XCTest
import SwiftData
@testable import HasegawasDementiaScaleRevised

final class HDSRLogicTests: XCTestCase {

    private var container: ModelContainer!
    private var context: ModelContext!

    override func setUpWithError() throws {
        // ディスクを汚さないようメモリ上のストアで検証する
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(
            for: Assessor.self, TargetPerson.self, Assessment.self,
            configurations: configuration
        )
        context = ModelContext(container)
    }

    override func tearDownWithError() throws {
        container = nil
        context = nil
    }

    // MARK: - 設問定義

    func testQuestionCountAndFullScore() {
        let questions = HDSRQuestion.loadAll()
        XCTAssertEqual(questions.count, 9, "HDSR.json の設問数が9ではない")
        XCTAssertEqual(
            questions.count, Assessment.hdsrItemName.count,
            "設問数と項目名の数が食い違っている。詳細画面で項目と点数がずれる"
        )

        // 各設問の最高点の合計がHDS-Rの満点30点になる
        let maxTotal = questions.reduce(0) { $0 + ($1.choices.map(\.score).max() ?? 0) }
        XCTAssertEqual(maxTotal, 30, "設問の最高点の合計が30点にならない")
        XCTAssertEqual(Assessment.fullScore, 30)
    }

    func testVisualMemoryQuestionIndexPointsToCorrectItem() {
        let questions = HDSRQuestion.loadAll()
        let index = HDSRQuestion.visualMemoryIndex
        XCTAssertEqual(
            questions[index].itemName, "視覚記憶",
            "物品一覧を出す設問の位置がずれている"
        )
    }

    func testChoicesSkipEmptySlots() {
        let questions = HDSRQuestion.loadAll()
        // 年齢は2択、日付の見当識は5択
        XCTAssertEqual(questions[0].choices.count, 2)
        XCTAssertEqual(questions[1].choices.count, 5)
        // 得点は昇順に並んでいる
        for question in questions {
            let scores = question.choices.map(\.score)
            XCTAssertEqual(scores, scores.sorted(), "\(question.itemName) の選択肢の得点が昇順でない")
        }
    }

    // MARK: - 集計

    func testTotalAndItemOrder() {
        let scores = [1, 4, 2, 3, 2, 2, 6, 5, 5]
        let assessment = Assessment(results: scores)
        XCTAssertEqual(assessment.hdsrItemResult, scores, "項目の並び順が評価順と一致しない")
        XCTAssertEqual(assessment.hdsrItemSum, 30)
        XCTAssertEqual(assessment.itemAge, 1)
        XCTAssertEqual(assessment.itemDateOrientation, 4)
        XCTAssertEqual(assessment.itemWordRecall, 5)
    }

    func testResultsInitializerHandlesShortArray() {
        // 項目数に満たない配列でも落ちず、残りは0になる
        let assessment = Assessment(results: [1, 4])
        XCTAssertEqual(assessment.itemAge, 1)
        XCTAssertEqual(assessment.itemDateOrientation, 4)
        XCTAssertEqual(assessment.itemPlaceOrientation, 0)
        XCTAssertEqual(assessment.hdsrItemSum, 5)
    }

    // MARK: - コピー文字列

    func testCopyStringIncludesAssessorAndTargetPerson() throws {
        let assessment = try makeStoredAssessment(scores: [1, 4, 2, 3, 2, 2, 6, 5, 5])
        let text = AssessmentResultFormatter.string(from: assessment)

        XCTAssertTrue(text.hasPrefix("評価結果"), "先頭が旧バージョンと異なる")
        XCTAssertTrue(text.contains("評価者:テスト評価者"), "評価者名が出ていない:\n\(text)")
        XCTAssertTrue(text.contains("対象者:テスト対象者"), "対象者名が出ていない:\n\(text)")
        XCTAssertTrue(text.contains("評価項目:HDS-R"))
        XCTAssertTrue(text.contains("合計:30"))
        for itemName in Assessment.hdsrItemName {
            XCTAssertTrue(text.contains("\(itemName):"), "\(itemName) がコピー結果に含まれていない")
        }
    }

    // MARK: - 削除の連鎖

    func testDeletingAssessorRemovesTargetPersonsAndAssessments() throws {
        _ = try makeStoredAssessment(scores: Array(repeating: 1, count: 9))
        XCTAssertEqual(try context.fetch(FetchDescriptor<Assessor>()).count, 1)
        XCTAssertEqual(try context.fetch(FetchDescriptor<TargetPerson>()).count, 1)
        XCTAssertEqual(try context.fetch(FetchDescriptor<Assessment>()).count, 1)

        let assessor = try XCTUnwrap(try context.fetch(FetchDescriptor<Assessor>()).first)
        context.delete(assessor)
        try context.save()

        XCTAssertEqual(try context.fetch(FetchDescriptor<Assessor>()).count, 0)
        XCTAssertEqual(
            try context.fetch(FetchDescriptor<TargetPerson>()).count, 0,
            "評価者を削除しても対象者が残っている"
        )
        XCTAssertEqual(
            try context.fetch(FetchDescriptor<Assessment>()).count, 0,
            "評価者を削除しても評価結果が残っている"
        )
    }

    func testDeletingAssessmentKeepsTargetPerson() throws {
        let assessment = try makeStoredAssessment(scores: Array(repeating: 1, count: 9))
        context.delete(assessment)
        try context.save()

        XCTAssertEqual(try context.fetch(FetchDescriptor<Assessment>()).count, 0)
        XCTAssertEqual(
            try context.fetch(FetchDescriptor<TargetPerson>()).count, 1,
            "評価を消しただけで対象者まで消えている"
        )
    }

    // MARK: - 補助

    @discardableResult
    private func makeStoredAssessment(scores: [Int]) throws -> Assessment {
        let assessor = Assessor(name: "テスト評価者")
        context.insert(assessor)

        let targetPerson = TargetPerson(name: "テスト対象者")
        context.insert(targetPerson)
        targetPerson.assessor = assessor

        let assessment = Assessment(results: scores)
        context.insert(assessment)
        assessment.targetPerson = targetPerson

        try context.save()
        return assessment
    }
}
