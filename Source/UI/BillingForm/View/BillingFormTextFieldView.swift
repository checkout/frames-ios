import UIKit
import Checkout

protocol PhoneNumberTextFieldDelegate: AnyObject {
    func phoneNumberIsUpdated(number: String, tag: Int)
}

class BillingFormTextFieldView: UIView {

    // MARK: - Properties

    weak var delegate: TextFieldViewDelegate?
    weak var phoneNumberDelegate: PhoneNumberTextFieldDelegate?

    private var style: CellTextFieldStyle?
    private var type: BillingFormCell?
    private lazy var textFieldContainerBottomAnchor = textFieldContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)

    // MARK: - UI elements

    private(set) lazy var headerLabel: LabelView = {
        LabelView().disabledAutoresizingIntoConstraints()
    }()

    private(set) lazy var mandatoryLabel: LabelView = {
        LabelView().disabledAutoresizingIntoConstraints()
    }()

    private(set) lazy var hintLabel: LabelView = {
        LabelView().disabledAutoresizingIntoConstraints()
    }()

    private(set) lazy var textFieldContainer: UIView = {
        let view = UIView().disabledAutoresizingIntoConstraints()
        view.backgroundColor = .clear
        return view
    }()

    private(set) lazy var textField: BillingFormTextField = {
        let view = DefaultBillingFormTextField(type: type, tag: tag).disabledAutoresizingIntoConstraints()
        view.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        view.autocorrectionType = .no
        view.delegate = self
        view.backgroundColor = .clear
        return  view
    }()

    private(set) var phoneNumberTextField: BillingFormTextField?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewsInOrder()
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

    func update(style: CellStyle?, type: BillingFormCell?, textFieldValue: String? = nil, tag: Int) {
        guard let type = type, let style = style as? CellTextFieldStyle else { return }
        self.type = type
        self.style = style
        backgroundColor = style.backgroundColor
        mandatoryLabel.isHidden = style.isMandatory
        refreshLayoutComponents()

        headerLabel.update(with: style.title)
        mandatoryLabel.update(with: style.mandatory)
        hintLabel.update(with: style.hint)

        updateTextFieldContainer(style: style)
        updateTextField(style: style, textFieldValue: textFieldValue, tag: tag)
        updateErrorView(style: style)
    }

    func refreshLayoutComponents() {
        let handlesPhoneNumber = isPhoneNumberType()
        textField.isHidden = handlesPhoneNumber
        if handlesPhoneNumber {
            addPhoneNumberTextField()
        } else {
            phoneNumberTextField?.removeFromSuperview()
            phoneNumberTextField = nil
        }
    }

    private func updateTextFieldContainer(style: CellTextFieldStyle) {
        let borderColor = !(style.error?.isHidden ?? true) ?
        style.textfield.borderStyle.errorColor.cgColor :
        style.textfield.normalBorderColor.cgColor

        textFieldContainer.layer.borderColor = borderColor
        textFieldContainer.layer.cornerRadius = style.textfield.cornerRadius
        textFieldContainer.layer.borderWidth = style.textfield.borderWidth
        textFieldContainer.backgroundColor = style.textfield.backgroundColor
    }

    private func update(textField: BillingFormTextField?, style: CellTextFieldStyle, textFieldValue: String?, tag: Int) {
        if let textFieldValue = textFieldValue {
            textField?.text = textFieldValue
        }
        textField?.type = type
        textField?.tag = tag
        textField?.keyboardType = style.textfield.isSupportingNumericKeyboard ? .phonePad : .default
        textField?.textContentType = style.textfield.isSupportingNumericKeyboard ? .telephoneNumber : .name
        textField?.text = style.textfield.text
        textField?.font = style.textfield.font
        textField?.placeholder = style.textfield.placeholder
        textField?.textColor = style.textfield.textColor
        textField?.tintColor = style.textfield.tintColor
    }

    private func updateTextField(style: CellTextFieldStyle, textFieldValue: String?, tag: Int) {
        if isPhoneNumberType() {
            update(textField: phoneNumberTextField, style: style, textFieldValue: textFieldValue, tag: tag)
            return
        }
        update(textField: textField, style: style, textFieldValue: textFieldValue, tag: tag)
    }

    private func isPhoneNumberType() -> Bool {
        self.type == .phoneNumber(nil)
    }

    private func updateErrorView(style: CellTextFieldStyle) {
        errorView.update(style: style.error)
        let shouldHideErrorView = style.error?.isHidden ?? false
        let expectedErrorViewHeight = style.error?.height ?? 0
        errorView.isHidden = shouldHideErrorView
        textFieldContainerBottomAnchor.constant = -(shouldHideErrorView ? 0 : expectedErrorViewHeight)
    }
}

// MARK: - Views Layout Constraint

extension BillingFormTextFieldView {

    private func setupViewsInOrder() {
        backgroundColor = style?.backgroundColor
        setupHeaderLabel()
        setupMandatoryLabel()
        setupHintLabel()
        setupTextFieldContainer()
        addTextFieldToView(textField)
        setupErrorView()
    }

    private func setupHeaderLabel() {
        addSubview(headerLabel)
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: topAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }

    private func setupMandatoryLabel() {
        addSubview(mandatoryLabel)
        NSLayoutConstraint.activate([
            mandatoryLabel.topAnchor.constraint(equalTo: topAnchor),
            mandatoryLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            mandatoryLabel.leadingAnchor.constraint(greaterThanOrEqualTo: headerLabel.trailingAnchor)
        ])
    }

    private func setupHintLabel() {
        addSubview(hintLabel)
        NSLayoutConstraint.activate([
            hintLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor,
                                           constant: Constants.Padding.xxs.rawValue),
            hintLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            hintLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    private func setupTextFieldContainer() {
      textFieldContainer.setContentHuggingPriority(.required, for: .vertical)
        addSubview(textFieldContainer)
        NSLayoutConstraint.activate([
            textFieldContainer.topAnchor.constraint(equalTo: hintLabel.bottomAnchor,
                                                    constant: Constants.Padding.xs.rawValue),
            textFieldContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            textFieldContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            textFieldContainerBottomAnchor
        ])
    }

    private func addTextFieldToView(_ textField: UITextField) {
        let heightStyle = style?.textfield.height ?? Constants.Style.BillingForm.InputTextField.height.rawValue
        textFieldContainer.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: textFieldContainer.topAnchor),
            textField.leadingAnchor.constraint(equalTo: textFieldContainer.leadingAnchor,
                                               constant: Constants.Padding.l.rawValue),
            textField.trailingAnchor.constraint(equalTo: textFieldContainer.trailingAnchor,
                                                constant: -Constants.Padding.l.rawValue),
            textField.bottomAnchor.constraint(equalTo: textFieldContainer.bottomAnchor),
            textField.heightAnchor.constraint(equalToConstant: heightStyle)
        ])
    }

    private func addPhoneNumberTextField() {
        guard phoneNumberTextField == nil else { return }
        let phoneNumberTextField: BillingFormTextField = BillingFormPhoneNumberText(type: type, tag: tag, phoneNumberTextDelegate: self).disabledAutoresizingIntoConstraints()
        phoneNumberTextField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        phoneNumberTextField.autocorrectionType = .no
        phoneNumberTextField.delegate = self
        phoneNumberTextField.backgroundColor = .clear
        self.phoneNumberTextField = phoneNumberTextField
        addTextFieldToView(phoneNumberTextField)
    }

    private func setupErrorView() {
        addSubview(errorView)

        NSLayoutConstraint.activate([
            errorView.topAnchor.constraint(equalTo: textFieldContainer.bottomAnchor, constant: Constants.Padding.s.rawValue),
            errorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

// MARK: - Text Field Delegate

extension BillingFormTextFieldView: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.textFieldShouldBeginEditing(textField: textField)
        textFieldContainer.layer.borderColor = style?.textfield.borderStyle.focusColor.cgColor
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        delegate?.textFieldShouldEndEditing(textField: textField, replacementString: textField.text ?? "") ?? true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.textFieldShouldReturn() ?? true
    }

}

// MARK: - Phone Number Text Delegate

extension BillingFormTextFieldView: BillingFormPhoneNumberTextDelegate {
    func phoneNumberIsUpdated(number: String, tag: Int) {
        phoneNumberDelegate?.phoneNumberIsUpdated(number: number, tag: tag)
    }
}
