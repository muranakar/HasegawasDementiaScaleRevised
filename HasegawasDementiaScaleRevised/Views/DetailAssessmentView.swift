//
//  DetailAssessmentView.swift
//  HasegawasDementiaScaleRevised
//
//  1回分の評価結果の内訳。
//

import SwiftUI

struct DetailAssessmentView: View {
    let assessment: Assessment

    @State private var isShowingCopyCompleted = false

    var body: some View {
        List {
            Section {
                HStack {
                    Text("合計")
                        .font(.headline)
                    Spacer()
                    Text("\(assessment.hdsrItemSum) / \(Assessment.fullScore) 点")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(Theme.main)
                }
            } header: {
                Text("評価日:　\(DateFormatter.evaluated.string(from: assessment.createdAt))")
            }

            Section("評価項目") {
                ForEach(Array(Assessment.hdsrItemName.enumerated()), id: \.offset) { index, itemName in
                    HStack {
                        Text(itemName)
                        Spacer()
                        Text("\(assessment.hdsrItemResult[index]) 点")
                            .foregroundStyle(.secondary)
                    }
                }
            }

            Section {
                Button {
                    copyToPasteboard()
                } label: {
                    Label("評価結果をコピーする", systemImage: "doc.on.doc")
                }
            }
        }
        .navigationTitle("評価結果")
        .navigationBarTitleDisplayMode(.inline)
        .alert("コピーしました", isPresented: $isShowingCopyCompleted) {
            Button("OK") {}
        } message: {
            Text("カルテなどに貼り付けてご利用ください。")
        }
    }

    private func copyToPasteboard() {
        UIPasteboard.general.string = AssessmentResultFormatter.string(from: assessment)
        isShowingCopyCompleted = true
    }
}
