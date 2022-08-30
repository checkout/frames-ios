import UIKit

protocol ButtonViewDelegate: AnyObject {
    func selectionButtonIsPressed(sender: UIView)
}

class ButtonView: UIView {
    weak var delegate: ButtonViewDelegate?
    var style: ElementButtonStyle?
    lazy var constraintLeading: NSLayoutConstraint? = buttonTextLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 120.0)

    var isEnabled: Bool = true {
        didSet {
            if let style = style {
                self.style?.isEnabled = isEnabled
                button.isEnabled = isEnabled
                updateLabelStyle(with: style)
                updateButtonStyle(with: style)
            }
        }
    }

    lazy var button: UIButton = {
        let view = UIButton().disabledAutoresizingIntoConstraints()
        view.addTarget(self, action: #selector(selectionButtonIsPressed), for: .touchUpInside)
        view.isEnabled = isEnabled
        return view
    }()

    private(set) lazy var buttonTextLabel: LabelView = {
        LabelView().disabledAutoresizingIntoConstraints()
    }()

    convenience init(startEnabled: Bool = true) {
        self.init(frame: .zero)

        self.isEnabled = startEnabled
        button.isEnabled = startEnabled
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraintsInOrder()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(with style: ElementButtonStyle) {
        self.style = style
        backgroundColor = style.backgroundColor
        clipsToBounds = true
        layer.borderColor = style.normalBorderColor.cgColor
        layer.cornerRadius = style.cornerRadius
        layer.borderWidth = style.borderWidth
        updateButtonStyle(with: style)
        updateLabelStyle(with: style)
    }

    @objc private func selectionButtonIsPressed() {
        delegate?.selectionButtonIsPressed(sender: self)
    }

    private func updateButtonStyle(with style: ElementButtonStyle) {
        backgroundColor = isEnabled ? style.backgroundColor : style.disabledTintColor
        button.tintColor = .clear
        button.heightAnchor.constraint(equalToConstant: style.height).isActive = true
        button.accessibilityIdentifier = style.text
    }

    private func updateLabelStyle(with style: ElementButtonStyle) {
      let buttonTextLabelStyle = DefaultHeaderLabelFormStyle(textAlignment: style.textAlignment,
                                                             text: style.text,
                                                             font: style.font,
                                                             textColor: isEnabled ? style.textColor : style.disabledTextColor)
        buttonTextLabel.update(with: buttonTextLabelStyle)
        constraintLeading?.constant = style.textLeading
        constraintLeading?.priority = .required
        constraintLeading?.isActive = true
    }

    private func setupConstraintsInOrder() {
        setupButtonTextLabel()
        setupButton()
    }

    private func setupButton() {
        addSubview(button)
        button.setupConstraintEqualTo(view: self)
    }

    private func setupButtonTextLabel() {
        addSubview(buttonTextLabel)
        NSLayoutConstraint.activate([
            buttonTextLabel.topAnchor.constraint(equalTo: topAnchor),
            buttonTextLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            buttonTextLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
