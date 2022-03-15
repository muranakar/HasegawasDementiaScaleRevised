//
//  InputFormContainerView.swift
//  TimerAssessment
//
//  Created by Takehito Koshimizu on 2022/02/13.
//

import UIKit

@IBDesignable
class InputFormContainerView: UIView {
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
        backgroundColor = .white
    }

    private func updateLayer() {
        layer.cornerRadius = 20
        layer.shadowOpacity = 0.7
        layer.shadowRadius = 5
        layer.shadowColor = Colors.mainColor.cgColor
        layer.shadowOffset = CGSize(width: 1, height: 1)
    }
}

#if canImport(SwiftUI)
import SwiftUI

struct InputFormView_Previews: PreviewProvider {
    struct Representable: UIViewRepresentable {
        func makeUIView(context: Context) -> InputFormContainerView {
            InputFormContainerView()
        }

        func updateUIView(_: InputFormContainerView, context: Context) {
        }
    }

    static var previews: some View {
        Representable()
            .preferredColorScheme(.light)
            .previewDevice("iPhone 8")
            .previewInterfaceOrientation(.portrait)
            .previewLayout(.fixed(width: 250, height: 250))
    }
}
#endif
