import UIKit
import Checkout

class BillingFormTextFieldView: UIView {

    // MARK: - Properties

    weak var delegate: TextFieldViewDelegate?

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

    private(set) lazy var textFieldContainerBorder: BorderView = {
        BorderView().disabledAutoresizingIntoConstraints()
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

    private(set) lazy var textField: BillingFormTextField = {
        let view = DefaultBillingFormTextField(type: type).disabledAutoresizingIntoConstraints()
        view.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        view.autocorrectionType = .no
        view.delegate = self
        view.backgroundColor = .clear
        return  view
    }()

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
        textField.tag = tag
        textField.accessibilityIdentifier = type.accessibilityIdentifier
        backgroundColor = style.backgroundColor

        mandatoryLabel.isHidden = style.isMandatory || style.title == nil
        headerLabel.isHidden = style.title == nil
        hintLabel.isHidden = style.hint == nil

        addTextFieldToView(textField)

        headerLabel.update(with: style.title)
        mandatoryLabel.update(with: style.mandatory)
        hintLabel.update(with: style.hint)

        updateTextFieldContainer(style: style)
        update(textField: textField, style: style, textFieldValue: textFieldValue, tag: tag)
        updateErrorView(style: style)
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
        style.textfield.borderStyle.errorColor :
        style.textfield.borderStyle.normalColor
        textFieldContainerBorder.update(with: style.textfield.borderStyle)
        textFieldContainerBorder.updateBorderColor(to: borderColor)
        textFieldContainerBorder.backgroundColor = style.textfield.backgroundColor
    }

    private func update(textField: BillingFormTextField?, style: CellTextFieldStyle, textFieldValue: String?, tag: Int) {
        if let textFieldValue = textFieldValue {
            textField?.text = textFieldValue
        }
        textField?.type = type
        textField?.tag = tag
        textField?.keyboardType = style.textfield.isSupportingNumericKeyboard ? .phonePad : .default
        textField?.text = type?.validator.formatForDisplay(text: style.textfield.text) ?? style.textfield.text
        textField?.font = style.textfield.font
        textField?.placeholder = style.textfield.placeholder
        textField?.textColor = style.textfield.textColor
        textField?.tintColor = style.textfield.tintColor
        textField?.textContentType = suggestTextContentType(type: type)
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
        if let color = style?.textfield.borderStyle.focusColor {
            textFieldContainerBorder.updateBorderColor(to: color)
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text,
              let textRange = Range(range, in: text) else {
            return false
        }
        let newText = text.replacingCharacters(in: textRange,
                                               with: string)
        return type?.validator.shouldAccept(text: newText) == true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if let validator = type?.validator,
           let text = textField.text {
            textField.text = validator.formatForDisplay(text: text)
        }
        return delegate?.textFieldShouldEndEditing(textField: textField, replacementString: textField.text ?? "") ?? true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.textFieldShouldReturn() ?? true
    }

}
