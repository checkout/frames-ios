import UIKit
import Checkout

protocol PhoneNumberTextFieldDelegate: AnyObject {
    func phoneNumberIsUpdated(number: Phone, tag: Int)
    func isValidPhoneMaxLength(text: String?) -> Bool
    func textFieldDidEndEditing(tag: Int)
}

class BillingFormTextFieldView: UIView {

    // MARK: - Properties

    weak var delegate: TextFieldViewDelegate?
    weak var phoneNumberDelegate: PhoneNumberTextFieldDelegate?

    private var style: CellTextFieldStyle?
    private var type: BillingFormCell?
    private lazy var textFieldContainerBottomAnchor = textFieldContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)

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

    private(set) lazy var textFieldContainerBorder: UIView = {
        let view = UIView().disabledAutoresizingIntoConstraints()
        view.backgroundColor = .clear
        return view
    }()

    private(set) lazy var textFieldContainer: UIStackView = {
        let view = UIStackView().disabledAutoresizingIntoConstraints()
        view.axis = .horizontal
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        view.spacing = 16
        view.backgroundColor = .clear
        return view
    }()

    private(set) var phoneNumberTextField: BillingFormTextField?
    private(set) var textField: BillingFormTextField?

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

        mandatoryLabel.isHidden = style.isMandatory || style.title == nil
        headerLabel.isHidden = style.title == nil
        hintLabel.isHidden = style.hint == nil

        refreshLayoutComponents()

        headerLabel.update(with: style.title)
        mandatoryLabel.update(with: style.mandatory)
        hintLabel.update(with: style.hint)

        updateTextFieldContainer(style: style)
        updateTextField(style: style, textFieldValue: textFieldValue, tag: tag)
        updateErrorView(style: style)
    }

    func refreshLayoutComponents() {
        guard isPhoneNumberType() else {
            phoneNumberTextField?.removeFromSuperview()
            phoneNumberTextField = nil
            guard textField == nil else { return }
            textField = createTextField()
            addTextFieldToView(textField)
            return
        }
        textField?.removeFromSuperview()
        textField = nil
        guard phoneNumberTextField == nil else { return }
        phoneNumberTextField = createPhoneNumberTextField()
        addTextFieldToView(phoneNumberTextField)
    }

    private func createTextField() -> BillingFormTextField {
        let view = DefaultBillingFormTextField(type: type, tag: tag).disabledAutoresizingIntoConstraints()
        view.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        view.autocorrectionType = .no
        view.delegate = self
        view.backgroundColor = .clear
        return  view
    }

    private func createPhoneNumberTextField() -> BillingFormPhoneNumberText {
        let view = BillingFormPhoneNumberText(type: type, tag: tag, phoneNumberTextDelegate: self).disabledAutoresizingIntoConstraints()
        view.autocorrectionType = .no
        view.backgroundColor = .clear
        return view
    }

    private func suggestTextContentType(type: BillingFormCell?) -> UITextContentType? {
        switch type {
            case .addressLine1: return .streetAddressLine1
            case .addressLine2: return .streetAddressLine2
            case .city: return .addressCity
            case .postcode: return .postalCode
            case .state: return .addressState
            case .fullName: return .name
            case .phoneNumber: return .telephoneNumber
            default: return nil
        }
    }

    private func updateTextFieldContainer(style: CellTextFieldStyle) {
        let borderColor = !(style.error?.isHidden ?? true) ?
        style.textfield.errorBorderColor.cgColor :
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
        textField?.text = style.textfield.text
        textField?.font = style.textfield.font
        textField?.placeholder = style.textfield.placeholder
        textField?.textColor = style.textfield.textColor
        textField?.tintColor = style.textfield.tintColor
        textField?.textContentType = suggestTextContentType(type: type)
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
        errorView.isHidden = style.error?.isHidden ?? false
    }
}

// MARK: - Views Layout Constraint

extension BillingFormTextFieldView {

    private func setupViewsInOrder() {
        backgroundColor = style?.backgroundColor
        setupHeaderStackView()
        setupStackView()
        setupMandatoryLabel()
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
            headerStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: style?.mandatory?.text.isEmpty ?? true ? 0 : -60)
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
            mandatoryLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        mandatoryLabel.bringSubviewToFront(self)
    }

    private func addTextFieldToView(_ textField: UITextField?) {
        guard let textField = textField else { return }
        let heightStyle = style?.textfield.height ?? Constants.Style.BillingForm.InputTextField.height.rawValue
        textFieldContainer.addArrangedSubview(textField)
        NSLayoutConstraint.activate([
            textField.heightAnchor.constraint(equalToConstant: heightStyle)
        ])
        addSubview(textFieldContainer)
        textFieldContainer.setupConstraintEqualTo(view: textFieldContainerBorder)
    }
}

// MARK: - Text Field Delegate

extension BillingFormTextFieldView: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.textFieldShouldBeginEditing(textField: textField)
        textFieldContainer.layer.borderColor = style?.textfield.focusBorderColor.cgColor
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
    func textFieldDidEndEditing(tag: Int) {
        phoneNumberDelegate?.textFieldDidEndEditing(tag: tag)
    }

    func isValidPhoneMaxLength(text: String?) -> Bool {
        phoneNumberDelegate?.isValidPhoneMaxLength(text: text) ?? true
    }

    func phoneNumberIsUpdated(number: Phone, tag: Int) {
        phoneNumberDelegate?.phoneNumberIsUpdated(number: number, tag: tag)
    }
}
