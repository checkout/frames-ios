import UIKit

class InputView: UIView {

    // MARK: - Properties

    weak var delegate: TextFieldViewDelegate?
    private(set) var style: CellTextFieldStyle?
    private(set) lazy var iconViewWidthAnchor = iconView.widthAnchor.constraint(equalToConstant: 32)

    // MARK: - UI elements

    private lazy var stackView: UIStackView = {
      let view = UIStackView().disabledAutoresizingIntoConstraints()
      view.axis = .vertical
      view.spacing = 6
      return view
    }()

    private lazy var headerStackView: UIStackView = {
      let view = UIStackView().disabledAutoresizingIntoConstraints()
      view.axis = .vertical
      view.spacing = 6
      return view
    }()

    private(set) lazy var headerLabel: LabelView = {
        LabelView().disabledAutoresizingIntoConstraints()
    }()

    private(set) lazy var mandatoryLabel: LabelView = {
        LabelView().disabledAutoresizingIntoConstraints()
    }()

    private(set) lazy var hintLabel: LabelView = {
        LabelView().disabledAutoresizingIntoConstraints()
    }()

    private lazy var textFieldContainerBorder: BorderView = {
        BorderView().disabledAutoresizingIntoConstraints()
    }()

    private lazy var textFieldContainer: UIStackView = {
        let view = UIStackView().disabledAutoresizingIntoConstraints()
        view.axis = .horizontal
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        view.spacing = 16
        view.backgroundColor = .clear
        return view
    }()

    private(set) lazy var textFieldView: TextFieldView = {
        let view = TextFieldView().disabledAutoresizingIntoConstraints()
        view.delegate = self
        return view
    }()

    private lazy var iconView: ImageContainerView = {
        let view = ImageContainerView().disabledAutoresizingIntoConstraints()
        view.isHidden = true
        return view
    }()

    override init(frame: CGRect) {
      super.init(frame: frame)
      setupViewsInOrder()
      /// Tap Gesture to dismiss the keyboard on touch on view without canceling touches In current view
      addGestureRecognizer(UIView.keyboardDismissTapGesture)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func textFieldEditingChanged(textField: UITextField) {
        delegate?.textFieldShouldChangeCharactersIn(textField: textField, replacementString: "")
    }

    private(set) lazy var errorView: SimpleErrorView = {
        SimpleErrorView().disabledAutoresizingIntoConstraints()
    }()

    // MARK: - Update subviews style

    func update(style: CellTextFieldStyle? = nil, image: UIImage? = nil, animated: Bool = false) {
        updateTextFieldContainer(image: image, animated: animated)

        guard let style = style else { return }
        self.style = style
        backgroundColor = style.backgroundColor

        mandatoryLabel.isHidden = style.isMandatory || style.title == nil
        headerLabel.isHidden = style.title == nil
        hintLabel.isHidden = style.hint == nil

        headerLabel.update(with: style.title)
        mandatoryLabel.update(with: style.mandatory)
        hintLabel.update(with: style.hint)
        updateTextFieldContainer(style: style)
        textFieldView.update(with: style.textfield)
        updateErrorView(style: style)
    }

    func updateBorderColor(with color: UIColor) {
        textFieldContainerBorder.updateBorderColor(to: color)
    }

    private func updateTextFieldContainer(style: CellTextFieldStyle) {
        let borderColor = !(style.error?.isHidden ?? true) ?
        style.textfield.borderStyle.errorColor :
        style.textfield.borderStyle.normalColor

        textFieldContainerBorder.update(with: style.textfield.borderStyle)
        textFieldContainerBorder.updateBorderColor(to: borderColor)
        textFieldContainerBorder.backgroundColor = style.textfield.backgroundColor
        textFieldContainerBorder.setNeedsLayout()
    }

    private func updateTextFieldContainer(image: UIImage?, animated: Bool) {
        iconView.isHidden = image == nil
        iconView.update(with: image, animated: animated)
    }

    private func updateErrorView(style: CellTextFieldStyle) {
        errorView.update(style: style.error)
        errorView.isHidden = style.error?.isHidden ?? false
    }
}

// MARK: - Views Layout Constraint

extension InputView {

    private func setupViewsInOrder() {
        backgroundColor = style?.backgroundColor
        setupHeaderStackView()
        setupStackView()
        setupMandatoryLabel()
        setupIcon()
        setupTextField()
    }

    private func setupHeaderStackView() {
        addSubview(headerStackView)
        let arrangedSubviews = [
            headerLabel,
            hintLabel
        ]
        headerStackView.addArrangedSubviews(arrangedSubviews)
        NSLayoutConstraint.activate([
            headerStackView.topAnchor.constraint(equalTo: topAnchor),
            headerStackView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }

    private func setupStackView() {
        addSubview(stackView)
        let arrangedSubviews = [
            textFieldContainerBorder,
            errorView
        ]
        stackView.addArrangedSubviews(arrangedSubviews)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func setupMandatoryLabel() {
        addSubview(mandatoryLabel)
        NSLayoutConstraint.activate([
            mandatoryLabel.centerYAnchor.constraint(equalTo: headerStackView.centerYAnchor),
            mandatoryLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -60)
        ])
        mandatoryLabel.bringSubviewToFront(self)
    }

    private func setupIcon() {
        textFieldContainer.addArrangedSubview(iconView)

        NSLayoutConstraint.activate([
            iconViewWidthAnchor
        ])
    }

    private func setupTextField() {
        let heightStyle = style?.textfield.height ?? Constants.Style.BillingForm.InputTextField.height.rawValue
        textFieldContainer.addArrangedSubview(textFieldView)
        NSLayoutConstraint.activate([
            textFieldView.heightAnchor.constraint(equalToConstant: heightStyle)
        ])
        addSubview(textFieldContainer)
        textFieldContainer.setupConstraintEqualTo(view: textFieldContainerBorder)
    }

}

// MARK: - Text Field Delegate

extension InputView: TextFieldViewDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let shouldChangeCharacter = delegate?.textField(textField, shouldChangeCharactersIn: range, replacementString: string) ?? true
        if let color = style?.textfield.borderStyle.focusColor {
            textFieldContainerBorder.updateBorderColor(to: color)
        }
        return shouldChangeCharacter
    }

    func textFieldShouldBeginEditing(textField: UITextField) {
        delegate?.textFieldShouldBeginEditing(textField: textField)
        guard let color = style?.textfield.borderStyle.focusColor else { return }
        textFieldContainerBorder.updateBorderColor(to: color)
    }

    func textFieldShouldReturn() -> Bool {
         delegate?.textFieldShouldReturn() ?? false
    }

    func textFieldShouldEndEditing(textField: UITextField, replacementString: String) -> Bool {
        let shouldEndEditing = delegate?.textFieldShouldEndEditing(textField: textField, replacementString: replacementString) ?? true
        if let style = style, shouldEndEditing {
            let normalColor = style.textfield.borderStyle.normalColor
            let errorColor = style.textfield.borderStyle.errorColor
            let textfieldColor = style.error?.isHidden == true ? normalColor : errorColor
            textFieldContainerBorder.updateBorderColor(to: textfieldColor)
        }
        return shouldEndEditing
    }

    func textFieldShouldChangeCharactersIn(textField: UITextField, replacementString string: String) {
        delegate?.textFieldShouldChangeCharactersIn(textField: textField, replacementString: string)
    }
}
