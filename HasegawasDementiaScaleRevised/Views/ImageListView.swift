//
//  ImageListView.swift
//  HasegawasDementiaScaleRevised
//
//  視覚記憶の設問で対象者に提示する5つの物品。タップで拡大表示する。
//

import SwiftUI

struct ImageListView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var zoomedImage: ZoomedImage?

    private let imageNames = ["Hair", "Coin", "Clock", "Pen", "Key"]

    /// 拡大表示する物品。`sheet(item:)` に渡すため Identifiable にしている
    private struct ZoomedImage: Identifiable {
        let id = UUID()
        let name: String
    }

    private let columns = [
        GridItem(.adaptive(minimum: 140), spacing: 16)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(imageNames, id: \.self) { name in
                        Button {
                            zoomedImage = ZoomedImage(name: name)
                        } label: {
                            Image(name)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 140)
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
            .navigationTitle("視覚記憶")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("閉じる") { dismiss() }
                }
            }
            .sheet(item: $zoomedImage) { image in
                ZoomedImageView(imageName: image.name)
            }
        }
    }
}

// MARK: - ZoomedImageView
private struct ZoomedImageView: View {
    let imageName: String
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemBackground))
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("閉じる") { dismiss() }
                    }
                }
        }
    }
}
