//
//  PastAssessmentListView.swift
//  HasegawasDementiaScaleRevised
//
//  対象者ごとの過去のHDS-R評価一覧。
//

import SwiftUI
import SwiftData

struct PastAssessmentListView: View {
    let targetPerson: TargetPerson

    @Environment(\.modelContext) private var modelContext
    @State private var isAscending = false
    @State private var isShowingCopyCompleted = false

    // targetPerson.assessments を直接参照すると、評価を追加・削除しても画面が更新されない。
    // リレーション経由の変更は SwiftUI へ通知されないため @Query で取得する
    @Query private var allAssessments: [Assessment]

    init(targetPerson: TargetPerson) {
        self.targetPerson = targetPerson
        let targetPersonID = targetPerson.uuidString
        _allAssessments = Query(
            filter: #Predicate<Assessment> { $0.targetPerson?.uuidString == targetPersonID },
            sort: \Assessment.createdAt
        )
    }

    /// 並び替えは @Query では動的に変えられないため、取得後に並べ替える
    private var assessments: [Assessment] {
        isAscending ? allAssessments : allAssessments.reversed()
    }

    var body: some View {
        Group {
            if assessments.isEmpty {
                ContentUnavailableView {
                    Label("評価結果がありません", systemImage: "list.bullet.rectangle")
                } description: {
                    Text("「評価する」から評価を行うと、ここに履歴が表示されます。")
                }
            } else {
                assessmentList
            }
        }
        .navigationTitle("対象者:　\(targetPerson.name)　様")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    isAscending.toggle()
                } label: {
                    Label(
                        isAscending ? "古い順" : "新しい順",
                        systemImage: isAscending ? "arrow.up" : "arrow.down"
                    )
                }
            }
        }
        .alert("コピーしました", isPresented: $isShowingCopyCompleted) {
            Button("OK") {}
        } message: {
            Text("カルテなどに貼り付けてご利用ください。")
        }
    }

    private var assessmentList: some View {
        List {
            ForEach(assessments) { assessment in
                NavigationLink(value: Route.assessmentDetail(assessment)) {
                    row(assessment)
                }
                .swipeActions(edge: .trailing) {
                    Button(role: .destructive) {
                        modelContext.delete(assessment)
                    } label: {
                        Label("削除", systemImage: "trash")
                    }
                    Button {
                        UIPasteboard.general.string = AssessmentResultFormatter.string(from: assessment)
                        isShowingCopyCompleted = true
                    } label: {
                        Label("コピー", systemImage: "doc.on.doc")
                    }
                    .tint(Theme.main)
                }
            }
        }
    }

    private func row(_ assessment: Assessment) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("\(assessment.hdsrItemSum) / \(Assessment.fullScore) 点")
                .font(.headline)
                .foregroundStyle(Theme.main)
            Text(DateFormatter.evaluated.string(from: assessment.createdAt))
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}
