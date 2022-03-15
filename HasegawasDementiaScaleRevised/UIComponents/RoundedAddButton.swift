//
//  RoundedAddButton.swift
//  TimerAssessment
//
//  Created by Takehito Koshimizu on 2022/02/13.
//

import UIKit

@IBDesignable
class RoundedAddButton: UIButton {
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
        let symbolConfiguration = UIImage.SymbolConfiguration(scale: .large)
        let image = UIImage(systemName: "plus", withConfiguration: symbolConfiguration)
        let bundle = Bundle(for: type(of: self))
        let backgroundImage = UIImage(named: "rounded-add-button", in: bundle, with: nil)
        setImage(image, for: .normal)
        setImage(image, for: .highlighted)
        setBackgroundImage(backgroundImage, for: .normal)
        setBackgroundImage(backgroundImage, for: .highlighted)
        configuration = nil
        backgroundColor = .clear
        tintColor = .white
    }

    private func updateLayer() {
        layer.cornerRadius = radius
        layer.shadowOpacity = 0.7
        layer.shadowRadius = 3
        layer.shadowColor = Colors.mainColor.cgColor
        layer.shadowOffset = CGSize(width: 1, height: 1)
    }

    override var intrinsicContentSize: CGSize {
        CGSize(width: 80, height: 80)
    }
}

#if canImport(SwiftUI)
import SwiftUI

struct RoundedAddButton_Previews: PreviewProvider {
    struct Representable: UIViewRepresentable {
        func makeUIView(context: Context) -> RoundedAddButton {
            RoundedAddButton()
        }

        func updateUIView(_: RoundedAddButton, context: Context) {
        }
    }

    static var previews: some View {
        Representable()
            .preferredColorScheme(.light)
            .previewDevice("iPhone 8")
            .previewInterfaceOrientation(.portrait)
            .previewLayout(.fixed(width: 80, height: 80))
    }
}
#endif
