//
//  BottomFloatingItems.swift
//  TimerAssessment
//
//  Created by Takehito Koshimizu on 2022/03/03.
//

import UIKit

// MARK: -
@propertyWrapper
final class BottomFloatingItems: NSObject {
    var wrappedValue: [UIView]
    var projectedValue: BottomFloatingItems { self }

    init(wrappedValue: [UIView] = []) {
        self.wrappedValue = wrappedValue
    }

    func updateVisibility(_ scrollView: ScrollViewType) {
        UIView.perform(.delete, on: [], options: []) { [views = wrappedValue] in
            views.forEach { view in
                view.alpha = scrollView.isVisibleFloatingItems ? 1 : 0
            }
        }
    }
}

// MARK: -
protocol ScrollViewType: AnyObject {
    var bounds: CGRect { get }
    var contentSize: CGSize { get }
    var contentOffset: CGPoint { get }
    var safeAreaInsets: UIEdgeInsets { get }
}

// MARK: -
extension UIScrollView: ScrollViewType {
}

// MARK: -
extension ScrollViewType {
    var isVisibleFloatingItems: Bool {
        let contentAndInsets = contentSize.height + safeAreaInsets.top + safeAreaInsets.bottom
        let bounds = bounds.height
        let offset = contentOffset.y + bounds
        return contentAndInsets < bounds || contentAndInsets > offset
    }
}
