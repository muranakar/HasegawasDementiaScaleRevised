//
//  FunctionSelectionView.swift
//  HasegawasDementiaScaleRevised
//
//  対象者を選んだあとの機能選択画面。
//

import SwiftUI

struct FunctionSelectionView: View {
    let targetPerson: TargetPerson

    @Environment(\.openURL) private var openURL

    var body: some View {
        List {
            Section("HDS-R") {
                NavigationLink(value: Route.newAssessment(targetPerson)) {
                    Label("評価する", systemImage: "square.and.pencil")
                }
                NavigationLink(value: Route.pastAssessments(targetPerson)) {
                    Label("過去の評価をみる", systemImage: "list.bullet.rectangle")
                }
            }

            Section("このアプリについて") {
                Button {
                    if let url = AppLinks.xShareURL { openURL(url) }
                } label: {
                    Label("Xで共有する", systemImage: "square.and.arrow.up")
                }
                Button {
                    if let url = AppLinks.lineShareURL { openURL(url) }
                } label: {
                    Label("LINEで共有する", systemImage: "bubble.left.and.bubble.right")
                }
                Button {
                    openURL(AppLinks.reviewURL)
                } label: {
                    Label("レビューを書く", systemImage: "star")
                }
                Button {
                    openURL(AppLinks.developerSiteURL)
                } label: {
                    Label("他のアプリをみる", systemImage: "app.badge")
                }
            }
        }
        .navigationTitle("対象者:　\(targetPerson.name)　様")
        .navigationBarTitleDisplayMode(.inline)
    }
}
