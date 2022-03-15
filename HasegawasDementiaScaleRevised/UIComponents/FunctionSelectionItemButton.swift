//
//  FunctionSelectionItemButton.swift
//  TimerAssessment
//
//  Created by Takehito Koshimizu on 2022/02/17.
//

import UIKit

@IBDesignable
class FunctionSelectionItemButton: UIButton {
    @IBInspectable var title: String? {
        didSet {
            setTitle(title, for: .normal)
            setTitle(title, for: .highlighted)
        }
    }

    @IBInspectable var image: UIImage? {
        didSet {
            setImage(image, for: .normal)
            setImage(image, for: .highlighted)
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializeContent()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeContent()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateLayer()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        initializeContent()
    }

    private func initializeContent() {
        tintColor = Colors.baseColor
        backgroundColor = Colors.mainColor
        configuration = nil
    }

    private func updateLayer() {
        layer.cornerRadius = 10
        layer.shadowOpacity = 0.7
        layer.shadowRadius = 3
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 1, height: 1)
    }

    override var intrinsicContentSize: CGSize {
        CGSize(width: 200, height: 70)
    }
}

#if canImport(SwiftUI)
import SwiftUI

struct FunctionSelectionItemButton_Previews: PreviewProvider {
    typealias Content = FunctionSelectionItemButton

    struct Representable: UIViewRepresentable {
        let title: String
        let image: UIImage?

        func makeUIView(context: Context) -> Content {
            Content()
        }

        func updateUIView(_ button: Content, context: Context) {
            button.title = title
            button.image = image
        }
    }

    private static let previewTitles: [(title: String, image: UIImage?)] = [
        ("評価開始", UIImage(systemName: "applepencil")),
        ("過去評価一覧", UIImage(systemName: "list.dash"))
    ]

    static var previews: some View {
        return ForEach(previewTitles, id: \.title) {
            Representable(title: $0.title, image: $0.image)
                .preferredColorScheme(.light)
                .previewDevice("iPhone 8")
                .previewInterfaceOrientation(.portrait)
                .previewLayout(.fixed(width: 200, height: 70))
        }
    }
}
#endif
