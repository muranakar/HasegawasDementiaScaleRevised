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
        // 対象者名が長いとナビゲーションバーで省略されるため、名前は画面内に置く
        .navigationTitle("HDS-R 評価")
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
                                // 評価の途中や結果確認中に割り込まないよう、閉じるときに依頼する
                                if ReviewCounter.incrementAndShouldRequestReview() {
                                    requestReview()
                                }
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
            header

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
                        choiceButton(choice)
                    }
                }
                .padding()
            }
            // 設問が変わったらスクロール位置を先頭に戻す。
            // 戻さないと、前の設問でスクロールした位置のままになり設問文が画面外になる
            .id(currentIndex)

            if currentIndex >= 1 {
                Button {
                    goBackOneQuestion()
                } label: {
                    Label("1つ前に戻る", systemImage: "chevron.left")
                }
                .padding(.vertical, 8)
            }
        }
    }

    /// 進捗と対象者名。設問が切り替わっても位置が変わらないよう固定して表示する
    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("対象者:　\(targetPerson.name)　様")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                Spacer()
                Text("\(currentIndex + 1) / \(questions.count)")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Theme.main)
                    .monospacedDigit()
            }
            ProgressView(value: Double(currentIndex), total: Double(questions.count))
                .tint(Theme.main)
        }
        .padding(.horizontal)
        .padding(.bottom, 8)
    }

    private func choiceButton(_ choice: HDSRQuestion.Choice) -> some View {
        Button {
            select(choice)
        } label: {
            HStack(spacing: 12) {
                // 点数を左端に固定幅で置き、選択肢が並んだときに視線が縦に流れるようにする
                Text("\(choice.score)")
                    .font(.title3.weight(.bold))
                    .frame(width: 28)
                    .monospacedDigit()
                Text(choice.title)
                    .font(.body)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 4)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .tint(Theme.main)
        // 点数と選択肢名を別々に並べているため、読み上げは選択肢名だけにまとめる
        .accessibilityLabel(choice.title)
        .accessibilityIdentifier("choice-\(choice.score)")
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
        // 評価記録は失うと再入力が必要になるため、自動保存に任せず確実に書き込む
        try? modelContext.save()
        completedAssessment = assessment
    }
}
