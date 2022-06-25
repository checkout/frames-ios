import UIKit

protocol TextFieldViewDelegate: AnyObject {
    func textFieldShouldBeginEditing(textField: UITextField)
    func textFieldShouldReturn()
    func textFieldShouldEndEditing(textField: UITextField, replacementString: String)
    func textFieldShouldChangeCharactersIn(textField: UITextField, replacementString string: String)
}

class TextFieldView: UIView {
    weak var delegate: TextFieldViewDelegate?

    private(set) lazy var textField: UITextField? = {
        let view = UITextField().disabledAutoresizingIntoConstraints()
        view.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        view.autocorrectionType = .no
        view.delegate = self
        view.backgroundColor = .clear
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
        textField?.textContentType = style.isSupportingNumericKeyboard ? .telephoneNumber : .name
        textField?.text = style.text
        textField?.font = style.font
        textField?.placeholder = style.placeHolder
        textField?.textColor = style.textColor
        textField?.tintColor = style.tintColor
    }

    @objc func textFieldEditingChanged(textField: UITextField) {
        delegate?.textFieldShouldChangeCharactersIn(textField: textField, replacementString: "")
    }
    
    private func setupConstraintsInOrder() {
        guard let textField = textField else { return }
        addSubview(textField)
        textField.setupConstraintEqualTo(view: self)
    }
}

extension TextFieldView: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.textFieldShouldBeginEditing(textField: textField)
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
