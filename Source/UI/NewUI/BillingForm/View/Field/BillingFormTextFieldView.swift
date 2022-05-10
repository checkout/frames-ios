import UIKit

protocol BillingFormTextFieldViewDelegate: AnyObject {
    func updateCountryCode(code: Int)
    func textFieldShouldBeginEditing(textField: UITextField)
    func textFieldShouldReturn()
    func textFieldShouldEndEditing(textField: UITextField, replacementString: String)
}

class BillingFormTextFieldView: UIView {
   
    
    private var style: BillingFormTextFieldCellStyle
    private var type: BillingFormCellType
    private weak var delegate: BillingFormTextFieldViewDelegate?
    
    private(set) lazy var headerLabel: UILabel = {
        let view = UILabel()
        view.text = style.title?.text
        view.font = style.title?.font
        view.textColor = style.title?.textColor
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    private(set) lazy var hintLabel: UILabel = {
        let view = UILabel()
        view.text = style.hint?.text
        view.font = style.hint?.font
        view.textColor = style.hint?.textColor
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    private(set) lazy var textFieldContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10.0
        view.layer.borderWidth = 1.0
        textField.autocorrectionType = .no
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = !style.error.isHidden ? style.textfield.errorBorderColor.cgColor : style.textfield.normalBorderColor.cgColor
        view.backgroundColor = style.textfield.backgroundColor
        textField.keyboardType = style.textfield.isSupprtingNumbericKeyboard ? .phonePad : .default
        textField.textContentType = style.textfield.isSupprtingNumbericKeyboard ? .telephoneNumber : .name
        return view
    }()
    
    private(set) lazy var textField: UITextField = {
        let view = self.type == .phoneNumber ? BillingFormPhoneNumberText(type: type, tag: tag, phoneNumberTextDelegate: self) : BillingFormTextField(type: self.type, tag: tag)
        view.text = style.textfield.text
        view.font = style.textfield.font
        view.placeholder = style.textfield.placeHolder
        view.textColor = style.textfield.textColor
        view.tintColor = style.textfield.tintColor
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private(set) lazy var errorView: BillingFormTextFieldErrorView = {
        let view = BillingFormTextFieldErrorView(style: style.error)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(type: BillingFormCellType, tag: Int, style: BillingFormTextFieldCellStyle, delegate: BillingFormTextFieldViewDelegate? = nil) {
        self.style = style
        self.type = type
        super.init(frame: .zero)
        self.delegate = delegate
        self.tag = tag
        self.setupViewsInOrder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension BillingFormTextFieldView {

    private func setupViewsInOrder(){
        backgroundColor = style.backgroundColor
        setupHeaderLabel()
        setupHintLabel()
        setupTextFieldContainer()
        setupTextField()
        setupErrorView()
    }
    
    private func setupHeaderLabel() {
        addSubview(headerLabel)
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: topAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func setupHintLabel() {
        addSubview(hintLabel)
        NSLayoutConstraint.activate([
            hintLabel.topAnchor.constraint(equalTo: headerLabel.safeBottomAnchor, constant: 2),
            hintLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            hintLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func setupTextField() {
        textFieldContainer.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: textFieldContainer.topAnchor),
            textField.leadingAnchor.constraint(equalTo: textFieldContainer.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: textFieldContainer.trailingAnchor, constant: -20),
            textField.bottomAnchor.constraint(equalTo: textFieldContainer.bottomAnchor)
        ])
    }
    
    private func setupTextFieldContainer() {
        addSubview(textFieldContainer)

        NSLayoutConstraint.activate([
            textFieldContainer.topAnchor.constraint(equalTo: hintLabel.bottomAnchor, constant: 6),
            textFieldContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            textFieldContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            textFieldContainer.heightAnchor.constraint(equalToConstant: style.textfield.height)
        ])
    }
    
    private func setupErrorView() {
        addSubview(errorView)
        NSLayoutConstraint.activate([
            errorView.topAnchor.constraint(equalTo: textFieldContainer.bottomAnchor, constant: 10),
            errorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            errorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            errorView.heightAnchor.constraint(equalToConstant: style.error.isHidden ? 0 : style.error.height)
        ])
    }
}

extension BillingFormTextFieldView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.textFieldShouldBeginEditing(textField: textField)
        textFieldContainer.layer.borderColor = style.textfield.focusBorderColor.cgColor

    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        delegate?.textFieldShouldEndEditing(textField: textField, replacementString: textField.text ?? "")
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.textFieldShouldReturn()
        return false
    }
}

extension BillingFormTextFieldView: BillingFormPhoneNumberTextDelegate {
    func updateCountryCode(code: Int) {
        delegate?.updateCountryCode(code: code)
    }
}
