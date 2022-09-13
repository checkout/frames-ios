import UIKit

extension CKOUIStyle {

    enum Color {
        enum Background {
            static let primary = UIColor(hex: "#FF FF FF")
        }

        enum Text {
            static let primary = UIColor(hex: "#00 00 00")
            static let secondary = UIColor(hex: "#72 72 72")
            static let actionPrimary = UIColor(hex: "#72 72 72")
            static let actionSecondary = UIColor(hex: "#0B 5F F0")
            static let disabled = UIColor(hex: "#72 72 72")
            static let error = UIColor(hex: "#AD 28 3E")
        }

        enum Border {
            static let primary = UIColor(hex: "#8A 8A 8A")
            static let secondary = UIColor(hex: "#D9 D9 D9")
            static let active = UIColor(hex: "#0B 5F F0")
            static let error = UIColor(hex: "#AD 28 3E")
        }

        enum Icon {
            static let primary = UIColor(hex: "#00 00 00")
            static let disabled = UIColor(hex: "#8A 8A 8A")
            static let action = UIColor(hex: "#0B 5F F0")
        }

        enum Action {
            static let primary = UIColor(hex: "#0B 5F F0")
            static let disabled = UIColor(hex: "#F0 F0 F0")
        }
    }
}
