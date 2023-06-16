import UIKit

final class BorderView: UIView {

    private var style: ElementBorderStyle?

    /// shaper layer that draw edges and corners
    private var borderLayer = CAShapeLayer()
    private var backgroundLayer = CAShapeLayer()

    override var backgroundColor: UIColor? {
        get { UIColor(cgColor: backgroundLayer.backgroundColor ?? UIColor.clear.cgColor) }
        set {
            backgroundLayer.fillColor = newValue?.cgColor
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(backgroundLayer)
        layer.addSublayer(borderLayer)
        backgroundColor = .clear
    }

    // Keep border layer size in sync with owning view
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundLayer.frame = bounds
        borderLayer.frame = bounds
        guard let style = style else { return }
        backgroundLayer.createBackground(with: style)
        borderLayer.createCustomBorder(with: style)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Update edges and corners style
    /// - Parameter style: protocol with some parameters for styling border and corners
    func update(with style: ElementBorderStyle) {
        guard !compareCurrentStyleWith(style: style) else { return }
        self.style = style
        borderLayer.createCustomBorder(with: style)
    }

    func updateBorderColor(to newBorderColor: UIColor) {
        borderLayer.strokeColor = newBorderColor.cgColor
    }

    private func compareCurrentStyleWith(style: ElementBorderStyle ) -> Bool {
        self.style?.cornerRadius == style.cornerRadius &&
        self.style?.borderWidth == style.borderWidth &&
        self.style?.edges == style.edges &&
        self.style?.corners == style.corners
    }
}
