import UIKit

protocol ButtonViewDelegate: AnyObject {
    func selectionButtonIsPressed(sender: UIView)
}

class ButtonView: UIView {
    weak var delegate: ButtonViewDelegate?
    var style: ElementButtonStyle?
    lazy var constraintLeading: NSLayoutConstraint? = buttonTextLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 120.0)

    private(set) lazy var borderView: BorderView = {
        BorderView().disabledAutoresizingIntoConstraints()
    }()

    var isEnabled = true {
        didSet {
            if let style = style {
                self.style?.isEnabled = isEnabled
                button.isEnabled = isEnabled
                updateLabelStyle(with: style)
                updateButtonStyle(with: style)
            }
        }
    }

    var isLoading = false {
        didSet {
            updateLoadingState()
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

    private var loadingOverlay: UIView?

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
        clipsToBounds = true
        borderView.update(with: style.borderStyle)
        borderView.updateBorderColor(to: style.borderStyle.normalColor)
        updateButtonStyle(with: style)
        updateLabelStyle(with: style)
    }

    @objc private func selectionButtonIsPressed() {
        delegate?.selectionButtonIsPressed(sender: self)
    }

    private func updateButtonStyle(with style: ElementButtonStyle) {
        borderView.backgroundColor = isEnabled ? style.backgroundColor : style.disabledTintColor
        button.tintColor = .clear
        button.heightAnchor.constraint(equalToConstant: style.height).isActive = true
        button.accessibilityIdentifier = style.text
    }

    private func updateLoadingState() {
        let contentAlpha: CGFloat = isLoading ? 0 : 1
        UIView.animate(withDuration: 0.25) { [weak self] in
            if self?.isLoading == true {
                self?.setupLoadingOverlay()
                self?.backgroundColor = self?.backgroundColor?.withAlphaComponent(contentAlpha)
            } else {
                self?.loadingOverlay?.removeFromSuperview()
                self?.loadingOverlay = nil

                if let style = self?.style {
                    self?.update(with: style)
                }
            }
            self?.button.alpha = contentAlpha
            self?.buttonTextLabel.alpha = contentAlpha
        }
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
        setupBorderView()
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

    private func setupBorderView() {
        addSubview(borderView)
        borderView.setupConstraintEqualTo(view: self)
    }

    private func setupLoadingOverlay() {
        let loadingOverlay = UIView()
        loadingOverlay.translatesAutoresizingMaskIntoConstraints = false
        loadingOverlay.backgroundColor = style?.disabledTintColor
        loadingOverlay.tintColor = .clear

        let loadingSpinner = UIActivityIndicatorView()
        loadingSpinner.translatesAutoresizingMaskIntoConstraints = false
        loadingSpinner.color = style?.disabledTextColor
        loadingSpinner.startAnimating()
        loadingOverlay.addSubview(loadingSpinner)
        loadingSpinner.setupConstraintEqualTo(view: loadingOverlay)

        addSubview(loadingOverlay)
        loadingOverlay.setupConstraintEqualTo(view: self)
        bringSubviewToFront(loadingOverlay)

        self.loadingOverlay = loadingOverlay
    }
}
