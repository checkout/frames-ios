import UIKit

protocol TextFieldViewDelegate: AnyObject {
    func textFieldShouldBeginEditing(textField: UITextField)
    func textFieldShouldReturn() -> Bool
    func textFieldShouldEndEditing(textField: UITextField, replacementString: String) -> Bool
    func textFieldShouldChangeCharactersIn(textField: UITextField, replacementString string: String)
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
}

class TextFieldView: UIView {
    weak var delegate: TextFieldViewDelegate?

    private(set) lazy var textField: UITextField = {
        let view = UITextField()
        view.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        view.autocorrectionType = .no
        view.delegate = self
        view.backgroundColor = .clear
        addKeyboardToolbarNavigation(textFields: [view])
        return  view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupConstraintsInOrder()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(with style: ElementTextFieldStyle) {
        textField.text = style.text
        textField.font = style.font
        textField.placeholder = style.placeholder
        textField.textColor = style.textColor
        textField.tintColor = style.tintColor
        textField.keyboardType = style.isSupportingNumericKeyboard ? .numberPad : .default
    }

    @objc func textFieldEditingChanged(textField: UITextField) {
        delegate?.textFieldShouldChangeCharactersIn(textField: textField, replacementString: "")
    }

    private func setupConstraintsInOrder() {
        let securedTextField = SecureDisplayView(secure: textField, acceptsInput: true).disabledAutoresizingIntoConstraints()
        addSubview(securedTextField)
        securedTextField.setupConstraintEqualTo(view: self)
    }
}

extension TextFieldView: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.textFieldShouldBeginEditing(textField: textField)
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        delegate?.textFieldShouldEndEditing(textField: textField, replacementString: textField.text ?? "") ?? true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.textFieldShouldReturn() ?? false
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        delegate?.textField(textField, shouldChangeCharactersIn: range, replacementString: string) ?? true
    }
}
