//
//  RoundedTimerButton.swift
//  TimerAssessment
//
//  Created by Takehito Koshimizu on 2022/02/17.
//

import UIKit

@IBDesignable
class RoundedTimerButton: UIButton {
    @IBInspectable var title: String? {
        didSet {
            setTitle(title, for: .normal)
            setTitle(title, for: .highlighted)
            setTitle(title, for: .disabled)
        }
    }

    private var radius: CGFloat {
        min(intrinsicContentSize.width, intrinsicContentSize.height)/2
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
        configuration = nil
        backgroundColor = Colors.baseColor
        setTitleColor(Colors.mainColor, for: .normal)
        setTitleColor(Colors.mainColor, for: .highlighted)
        setTitleColor(.systemGray3, for: .disabled)
    }

    private func updateLayer() {
        layer.cornerRadius = radius
        layer.borderWidth = 2
        layer.borderColor = Colors.mainColor.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 2
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 1, height: 1)
    }

    override var intrinsicContentSize: CGSize {
        CGSize(width: 80, height: 80)
    }
}

#if canImport(SwiftUI)
import SwiftUI

struct RoundedTimerButton_Previews: PreviewProvider {
    struct Representable: UIViewRepresentable {
        let title: String?

        func makeUIView(context: Context) -> RoundedTimerButton {
            RoundedTimerButton()
        }

        func updateUIView(_ button: RoundedTimerButton, context: Context) {
            button.title = title
        }
    }

    private static let previewTitles: [String] = [
        "start", "stop", "reset"
    ]

    static var previews: some View {
        ForEach(previewTitles, id: \.self) { title in
            Representable(title: title)
                .preferredColorScheme(.light)
                .previewDevice("iPhone 8")
                .previewInterfaceOrientation(.portrait)
                .previewLayout(.fixed(width: 80, height: 80))
        }
    }
}
#endif
