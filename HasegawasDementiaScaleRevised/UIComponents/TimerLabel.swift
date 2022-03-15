//
//  TimerLabel.swift
//  TimerAssessment
//
//  Created by Takehito Koshimizu on 2022/02/18.
//

import UIKit

struct NonNegative<RawValue: ExpressibleByIntegerLiteral & Comparable>: RawRepresentable {
    var rawValue: RawValue

    init?(rawValue: RawValue) {
        guard rawValue >= 0 else {
            return nil
        }
        self.rawValue = rawValue
    }

    init?(_ rawValue: RawValue) {
        self.init(rawValue: rawValue)
    }
}

@IBDesignable
class TimerLabel: UILabel {
    @IBInspectable var fontSize: CGFloat = -1 {
        didSet {
            initializeContent()
        }
    }

    @IBInspectable var fontWeight: CGFloat = -1 {
        didSet {
            initializeContent()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeContent()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializeContent()
    }

    private func initializeContent() {
        let fontSize = NonNegative(self.fontSize)?.rawValue ?? font.pointSize
        let fontWeight = (NonNegative(self.fontWeight)?.rawValue)
            .map(UIFont.Weight.init(rawValue:)) ?? font.weight ?? UIFont.Weight.regular
        self.font = .monospacedDigitSystemFont(ofSize: fontSize, weight: fontWeight)
    }
}

extension UIFont {
    var weight: UIFont.Weight? {
        guard let weight = (traits?[.weight] as? NSNumber)?.doubleValue else {
            return nil
        }
        return .init(rawValue: CGFloat(weight))
    }

    private var traits: [UIFontDescriptor.TraitKey: Any]? {
        fontDescriptor.object(forKey: .traits) as? [UIFontDescriptor.TraitKey: Any]
    }
}

#if canImport(SwiftUI)
import SwiftUI

struct TimerLabel_Previews: PreviewProvider {
    struct Representable: UIViewRepresentable {
        let text: String?
        let fontSize: CGFloat
        let fontWeight: UIFont.Weight

        func makeUIView(context: Context) -> TimerLabel {
            TimerLabel()
        }

        func updateUIView(_ label: TimerLabel, context: Context) {
            label.text = text
            label.fontSize = fontSize
            label.fontWeight = fontWeight.rawValue
            label.textAlignment = .center
        }
    }

    static var previews: some View {
        Representable(text: "98:76:54:32:10", fontSize: 60, fontWeight: UIFont.Weight.medium)
            .preferredColorScheme(.light)
            .previewDevice("iPhone 8")
            .previewInterfaceOrientation(.portrait)
            .previewLayout(.fixed(width: 300, height: 100))
            .scaleEffect(0.6)
    }
}
#endif
