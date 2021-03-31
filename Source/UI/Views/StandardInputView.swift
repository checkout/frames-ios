import UIKit

/// Standard Input View containing a label and an input field.
@IBDesignable public class StandardInputView: UIView, UIGestureRecognizerDelegate {

    // MARK: - Properties

    /// Label
    public let label = UILabel()
    /// Text Field
    public var textField = UITextField()
    /// Error label
    public let errorLabel = UILabel()
    let tapGesture = UITapGestureRecognizer()
    // height constraint
    var heightConstraint: NSLayoutConstraint!
    let stackview = UIStackView()
    let contentView = UIView()
    let errorView = UIView()

    @IBInspectable var text: String = "Label" {
        didSet {
            label.text = text
        }
    }
    @IBInspectable var placeholder: String = "" {
        didSet {
            textField.placeholder = placeholder
        }
    }

    // MARK: - Initialization

    /// Initializes and returns a newly allocated view object with the specified frame rectangle.
    override public init(frame: CGRect) {
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
        tapGesture.addTarget(self, action: #selector(StandardInputView.onTapView))

        #if TARGET_INTERFACE_BUILDER
        if self.placeholder.isEmpty {
            self.placeholder = "placeholder"
        }
        #endif

        // add gesture recognizer
        addGestureRecognizer(self.tapGesture)

        // add values
        textField.keyboardType = .default
        textField.textContentType = .name
        textField.textAlignment = .right
        stackview.axis = .vertical
        stackview.backgroundColor = .clear
        // inspectable
        label.text = text
        textField.placeholder = placeholder

        // add to view
        contentView.addSubview(label)
        contentView.addSubview(textField)
        errorView.addSubview(errorLabel)
        stackview.addArrangedSubview(contentView)
        stackview.addArrangedSubview(errorView)

        errorView.isHidden = true
        errorLabel.textColor = CheckoutTheme.errorColor
        errorLabel.font = CheckoutTheme.font
        label.textColor = CheckoutTheme.color
        label.font = CheckoutTheme.font
        textField.font = CheckoutTheme.font
        textField.textColor = CheckoutTheme.color

        addSubview(stackview)

        addConstraints()
    }

    @objc func onTapView() {
        textField.becomeFirstResponder()
    }

    private func addConstraints() {
        label.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        stackview.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        errorView.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.translatesAutoresizingMaskIntoConstraints = false

        stackview.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackview.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        stackview.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackview.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        heightConstraint = stackview.heightAnchor.constraint(equalToConstant: 48)
        heightConstraint.isActive = true

        errorView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        errorLabel.topAnchor.constraint(equalTo: errorView.topAnchor).isActive = true
        errorLabel.bottomAnchor.constraint(equalTo: errorView.bottomAnchor).isActive = true
        errorLabel.leadingAnchor.constraint(equalTo: errorView.leadingAnchor, constant: 16).isActive = true
        errorLabel.trailingAnchor.constraint(equalTo: errorView.trailingAnchor, constant: 8).isActive = true

        contentView.leadingAnchor.constraint(equalTo: stackview.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: stackview.trailingAnchor).isActive = true

        textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
        label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8)
            .isActive = true
        textField.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        textField.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 8).isActive = true
        if #available(iOS 11.0, *) {} else {
            label.widthAnchor.constraint(equalToConstant: 150).isActive = true
        }
    }

    func set(label: String, backgroundColor: UIColor) {
        self.label.text = label.localized(forClass: StandardInputView.self)
        self.backgroundColor = backgroundColor
    }

    // MARK: - Methods

    /// Show an error message
    ///
    /// - parameter message: Error message to show
    public func showError(message: String) {
        errorView.isHidden = false
        errorLabel.text = message
        heightConstraint.constant = 48 + 32
        layoutIfNeeded()
    }

    /// Hide the error message
    public func hideError() {
        errorView.isHidden = true
        heightConstraint.constant = 48
        layoutIfNeeded()
    }
}
