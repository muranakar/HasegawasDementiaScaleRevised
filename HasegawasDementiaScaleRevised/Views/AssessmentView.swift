//
//  AssessmentView.swift
//  HasegawasDementiaScaleRevised
//
//  HDS-Rの9項目を順に評価する画面。設問は HDSR.json から読み込む。
//

import SwiftUI
import SwiftData
import StoreKit

struct AssessmentView: View {
    let targetPerson: TargetPerson

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Environment(\.requestReview) private var requestReview

    @State private var questions: [HDSRQuestion] = []
    @State private var currentIndex = 0
    @State private var scores: [Int] = []
    @State private var isShowingImageList = false
    @State private var isConfirmingCancel = false
    @State private var completedAssessment: Assessment?

    private var currentQuestion: HDSRQuestion? {
        questions.indices.contains(currentIndex) ? questions[currentIndex] : nil
    }

    var body: some View {
        Group {
            if let question = currentQuestion {
                questionView(question)
            } else {
                ProgressView()
            }
        }
        .navigationTitle("対象者:　\(targetPerson.name)　様")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("中止") { isConfirmingCancel = true }
            }
        }
        .task {
            if questions.isEmpty {
                questions = HDSRQuestion.loadAll()
            }
        }
        .sheet(isPresented: $isShowingImageList) {
            ImageListView()
        }
        .sheet(item: $completedAssessment) { assessment in
            NavigationStack {
                DetailAssessmentView(assessment: assessment)
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("完了") {
                                completedAssessment = nil
                                dismiss()
                            }
                        }
                    }
            }
        }
        .alert("評価を中止しますか？", isPresented: $isConfirmingCancel) {
            Button("中止する", role: .destructive) { dismiss() }
            Button("続ける", role: .cancel) {}
        } message: {
            Text("入力中の内容は保存されません。")
        }
    }

    // MARK: - 設問

    private func questionView(_ question: HDSRQuestion) -> some View {
        VStack(spacing: 0) {
            ProgressView(value: Double(currentIndex), total: Double(questions.count))
                .tint(Theme.main)
                .padding(.horizontal)

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("\(currentIndex + 1) / \(questions.count)　\(question.itemName)")
                        .font(.headline)
                        .foregroundStyle(Theme.main)

                    Text(question.itemQuestion)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .fixedSize(horizontal: false, vertical: true)

                    if !question.itemAttention.isEmpty {
                        Text(question.itemAttention)
                            .font(.callout)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }

                    // 視覚記憶の設問でのみ物品一覧を提示する
                    if currentIndex == HDSRQuestion.visualMemoryIndex {
                        Button {
                            isShowingImageList = true
                        } label: {
                            Label("提示する物品をみる", systemImage: "photo.on.rectangle")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                    }

                    Divider().padding(.vertical, 8)

                    ForEach(question.choices) { choice in
                        Button {
                            select(choice)
                        } label: {
                            Text(choice.title)
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                        .tint(Theme.main)
                    }
                }
                .padding()
            }

            if currentIndex >= 1 {
                Button {
                    goBackOneQuestion()
                } label: {
                    Label("1つ前に戻る", systemImage: "chevron.left")
                }
                .padding(.bottom, 8)
            }
        }
    }

    // MARK: - 操作

    private func select(_ choice: HDSRQuestion.Choice) {
        scores.append(choice.score)

        guard scores.count == questions.count else {
            currentIndex += 1
            return
        }
        save()
    }

    private func goBackOneQuestion() {
        guard currentIndex >= 1 else { return }
        currentIndex -= 1
        if !scores.isEmpty {
            scores.removeLast()
        }
    }

    private func save() {
        let assessment = Assessment(results: scores)
        modelContext.insert(assessment)
        assessment.targetPerson = targetPerson
        completedAssessment = assessment

        if ReviewCounter.incrementAndShouldRequestReview() {
            requestReview()
        }
    }
}
