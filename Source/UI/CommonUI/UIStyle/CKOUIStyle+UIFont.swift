import UIKit

enum CKOUIStyle {}

extension CKOUIStyle {

    enum Font {
        enum Title {
            static let title2 = CKOUIStyle.font(size: 24, weight: .medium)
            static let headline = CKOUIStyle.font(size: 17, weight: .semibold)
        }

        enum Body {
            static let large = CKOUIStyle.font(size: 17, weight: .regular)
            static let `default` = CKOUIStyle.font(size: 15, weight: .medium)
            static let defaultPlus = CKOUIStyle.font(size: 15, weight: .regular)
            static let small = CKOUIStyle.font(size: 13, weight: .medium)
            static let smallPlus = CKOUIStyle.font(size: 13, weight: .regular)
        }

        enum Input {
            static let label = CKOUIStyle.font(size: 15, weight: .regular)
        }

        enum Action {
            static let large = CKOUIStyle.font(size: 15, weight: .medium)
            static let `default` = CKOUIStyle.font(size: 15, weight: .regular)
        }

    }
}

private extension CKOUIStyle {
     static func font(size: CGFloat, weight: UIFont.Weight) -> UIFont {
        UIFont.systemFont(ofSize: size, weight: weight)
    }
}
