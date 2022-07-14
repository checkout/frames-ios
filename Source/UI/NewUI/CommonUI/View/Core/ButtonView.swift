import UIKit

protocol ButtonViewDelegate: AnyObject {
    func selectionButtonIsPressed(sender: UIView)
}

class ButtonView: UIView {
    weak var delegate: ButtonViewDelegate?
    lazy var constraintLeading: NSLayoutConstraint = buttonTextLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 120.0)

    lazy var button: UIButton = {
        let view = UIButton().disabledAutoresizingIntoConstraints()
        view.addTarget(self, action: #selector(selectionButtonIsPressed), for: .touchUpInside)
        return view
    }()

    var style: ElementButtonStyle?

    private(set) lazy var buttonTextLabel: LabelView = {
        LabelView().disabledAutoresizingIntoConstraints()
    }()

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
        updateButtonStyle(with: style)
        updateLabelStyle(with: style)
    }

    @objc private func selectionButtonIsPressed() {
        delegate?.selectionButtonIsPressed(sender: self)
    }

    private func updateButtonStyle(with style: ElementButtonStyle) {
        button.tintColor = .clear
        button.clipsToBounds = true
        button.layer.borderColor = style.normalBorderColor.cgColor
        button.layer.cornerRadius = style.cornerRadius
        button.layer.borderWidth = style.borderWidth
        button.setTitleColor(style.disabledTextColor, for: .disabled)
        button.setTitleColor(style.textColor, for: .normal)
    }

    private func updateLabelStyle(with style: ElementButtonStyle) {
        button.isEnabled = true
        let buttonTextLabelStyle = DefaultHeaderLabelFormStyle(
            font: style.font,
            textColor: isEnabled ? style.textColor : style.disabledTextColor
        )
        buttonTextLabel.update(with: buttonTextLabelStyle)
        constraintLeading.constant = style.textLeading
        constraintLeading.priority = .required
        constraintLeading.isActive = true
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

extension ButtonView: Stateful {
    struct StateUpdate {
        let isEnabled: Bool?
        let buttonTextLabelUpdate: LabelView.StateUpdate?
    }

    func update(state update: StateUpdate) {
        if let isEnabled = update.isEnabled {
          button.isEnabled = isEnabled
          buttonTextLabel.update(state: LabelView.StateUpdate(
            labelText: nil,
            isHidden: nil,
            textColor: isEnabled ? style?.textColor : style?.disabledTextColor
          ))
        }

        if let buttonTextLabelUpdate = update.buttonTextLabelUpdate {
            buttonTextLabel.update(state: buttonTextLabelUpdate)
        }
    }
}
