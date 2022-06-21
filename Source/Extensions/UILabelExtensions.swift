import UIKit

extension UILabel {

    func addLineSpacing(spacingValue: CGFloat = 2) {
        guard let textString = text else { return }

        let attributedString = NSMutableAttributedString(string: textString)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = spacingValue
        if let font = font {
            attributedString.addAttribute(
                .font,
                value: font,
                range: NSRange(location: 0, length: attributedString.length)
            )
        }
        attributedString.addAttribute(
            .paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: attributedString.length)
        )
        attributedText = attributedString
    }
}
