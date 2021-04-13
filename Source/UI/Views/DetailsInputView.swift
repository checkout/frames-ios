import UIKit

/// A details input view. Use this when you want to link to another view controller.
/// Add a gesture recognizer and an handler on tap, or a segue.
@IBDesignable public class DetailsInputView: UIView, UIGestureRecognizerDelegate {

    // MARK: - Properties

    let stackView = UIStackView()
    /// Label
    public let label = UILabel()
    /// Value label
    public let value = UILabel()
    /// Button
    public var button = UIButton()

    @IBInspectable var text: String = "Label" {
        didSet {
            label.text = text
        }
    }

    // MARK: - Initialization

    /// Initializes and returns a newly allocated view object with the specified frame rectangle.
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    /// Returns an object initialized from data in a given unarchiver.
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Setup

    private func setup() {
        // add values
        label.text = text
        label.textColor = CheckoutTheme.color
        value.textColor = CheckoutTheme.secondaryColor
        label.font = CheckoutTheme.font
        value.font = CheckoutTheme.font

        #if TARGET_INTERFACE_BUILDER
        self.button = UIButton(type: .contactAdd)
        value.text = "value"
        #else
        let image = "keyboard-next".image(forClass: DetailsInputView.self).withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = CheckoutTheme.chevronColor
        #endif
        // add to view
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(value)
        stackView.addArrangedSubview(button)
        addSubview(stackView)
        // add constraints
        addConstraints()
    }

    func set(label: String, backgroundColor: UIColor) {
        self.label.text = label.localized(forClass: DetailsInputView.self)
        self.backgroundColor = backgroundColor
    }

    private func addConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 8).isActive = true
        heightAnchor.constraint(equalToConstant: 48).isActive = true
        stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true

        value.setContentHuggingPriority(.defaultLow, for: .horizontal)
        button.heightAnchor.constraint(equalToConstant: 32).isActive = true
        button.widthAnchor.constraint(equalToConstant: 16).isActive = true
    }

}
