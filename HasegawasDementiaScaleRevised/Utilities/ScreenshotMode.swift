//
//  ScreenshotMode.swift
//  HasegawasDementiaScaleRevised
//
//  ストア用スクリーンショットの撮影モード（Debug ビルドのみ）。
//  起動引数 `-ssScene 1〜6` で、見本データ（架空の評価者・対象者・点数）を
//  メモリ上のデータベースに入れ、指定の画面を開いた状態で起動する。
//  端末に保存済みの評価データには一切触れない。
//

#if DEBUG
import SwiftUI
import SwiftData

enum ScreenshotMode {
    /// 撮影する場面（1〜6）。起動引数が無ければ nil
    static let scene: Int? = {
        let args = ProcessInfo.processInfo.arguments
        guard let i = args.firstIndex(of: "-ssScene"), args.indices.contains(i + 1) else { return nil }
        return Int(args[i + 1])
    }()

    static var isActive: Bool { scene != nil }

    /// 評価画面をどの設問から始めるか（場面1・5）
    static var assessmentStartIndex: Int? {
        switch scene {
        case 1: return 1          // 日付の見当識
        case 5: return HDSRQuestion.visualMemoryIndex
        default: return nil
        }
    }

    /// 場面5：視覚記憶の物品一覧を開いておく
    static var showsImageList: Bool { scene == 5 }

    /// 場面4：評価結果のコピー完了を表示しておく
    static var showsCopyCompleted: Bool { scene == 4 }

    static func makeContainer() -> ModelContainer? {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        return try? ModelContainer(for: Assessor.self, TargetPerson.self, Assessment.self, configurations: config)
    }

    @MainActor private static var seededPath: NavigationPath?

    /// 見本データを入れ、場面に応じた画面遷移の経路を返す（画面の再描画で二重に入れない）
    @MainActor
    static func seed(_ context: ModelContext) -> NavigationPath {
        if let seededPath { return seededPath }
        let path = makeSeed(context)
        seededPath = path
        return path
    }

    @MainActor
    private static func makeSeed(_ context: ModelContext) -> NavigationPath {
        let calendar = Calendar(identifier: .gregorian)
        func date(_ m: Int, _ d: Int, _ h: Int, _ min: Int) -> Date {
            calendar.date(from: DateComponents(year: 2026, month: m, day: d, hour: h, minute: min)) ?? .now
        }

        let assessors = ["佐藤 美咲（OT）", "高橋 健太（PT）", "中村 由紀（看護師）"]
            .enumerated()
            .map { Assessor(name: $1, createdAt: date(1, 5, 9, $0)) }
        assessors.forEach(context.insert)
        let assessor = assessors[0]

        let names = ["山本 花子", "小林 清", "加藤 和子", "吉田 正雄", "松本 千代", "井上 武"]
        let persons = names.enumerated().map { TargetPerson(name: $1, createdAt: date(2, 1, 9, $0)) }
        for person in persons {
            context.insert(person)
            person.assessor = assessor
        }
        let person = persons[0]

        // 架空の点数（9項目：年齢・日付・場所・即時記憶・計算・逆唱・遅延再生・視覚記憶・語想起）
        // 改善・悪化を示唆しないよう、点数は小さく上下させるだけにする
        let history: [(Date, [Int])] = [
            (date(4, 8, 10, 30), [1, 3, 2, 3, 2, 2, 4, 3, 3]),
            (date(5, 13, 14, 0), [1, 3, 2, 3, 2, 2, 4, 4, 3]),
            (date(6, 10, 10, 15), [1, 3, 1, 3, 2, 2, 4, 3, 3]),
            (date(7, 15, 11, 0), [1, 3, 2, 3, 2, 2, 4, 4, 3]),
            (date(8, 19, 13, 45), [1, 3, 2, 3, 1, 2, 4, 4, 3]),
            (date(9, 16, 10, 0), [1, 4, 2, 3, 2, 2, 4, 4, 3]),
            (date(10, 14, 15, 30), [1, 3, 2, 3, 2, 2, 4, 4, 3])
        ]
        var latest: Assessment?
        for (createdAt, results) in history {
            let assessment = Assessment(results: results, createdAt: createdAt)
            context.insert(assessment)
            assessment.targetPerson = person
            latest = assessment
        }
        try? context.save()

        var path = NavigationPath()
        switch scene {
        case 1, 5:
            path.append(assessor)
            path.append(person)
            path.append(Route.newAssessment(person))
        case 2, 4:
            path.append(assessor)
            path.append(person)
            path.append(Route.pastAssessments(person))
            if let latest { path.append(Route.assessmentDetail(latest)) }
        case 3:
            path.append(assessor)
            path.append(person)
            path.append(Route.pastAssessments(person))
        case 6:
            path.append(assessor)
        default:
            break
        }
        return path
    }
}
#endif
