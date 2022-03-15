//
//  AssessmentItemButton.swift
//  TimerAssessment
//
//  Created by Takehito Koshimizu on 2022/02/16.
//

import UIKit

@IBDesignable
class AssessmentItemButton: UIButton {
    @IBInspectable var title: String? {
        didSet {
            setTitle(title, for: .normal)
            setTitle(title, for: .highlighted)
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
        setTitleColor(Colors.mainColor, for: .normal)
        setTitleColor(Colors.mainColor, for: .highlighted)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        configuration = nil
        backgroundColor = Colors.baseColor
    }

    private func updateLayer() {
        layer.cornerRadius = 10
        layer.borderWidth = 2
        layer.shadowOpacity = 0.7
        layer.shadowRadius = 3
        layer.borderColor = Colors.mainColor.cgColor
        layer.shadowColor = Colors.mainColor.cgColor
        layer.shadowOffset = CGSize(width: 1, height: 1)
    }

    override var intrinsicContentSize: CGSize {
        CGSize(width: 150, height: 50)
    }
}

#if canImport(SwiftUI)
import SwiftUI

struct AssessmentItemButton_Previews: PreviewProvider {
    struct Representable: UIViewRepresentable {
        let title: String

        func makeUIView(context: Context) -> AssessmentItemButton {
            AssessmentItemButton()
        }

        func updateUIView(_ button: AssessmentItemButton, context: Context) {
            button.title = title
        }
    }

    private static let previewTitles: [String] = [
        "10m歩行", "6分間歩行", "片脚立位(右)", "片脚立位(左)", "TUG"
    ]

    static var previews: some View {
        ForEach(previewTitles, id: \.self) { title in
            Representable(title: title)
                .preferredColorScheme(.light)
                .previewDevice("iPhone 8")
                .previewInterfaceOrientation(.portrait)
                .previewLayout(.fixed(width: 150, height: 50))
        }
    }
}
#endif
