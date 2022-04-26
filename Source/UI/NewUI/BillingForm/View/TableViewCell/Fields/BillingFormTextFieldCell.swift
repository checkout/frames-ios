import UIKit
import PhoneNumberKit

protocol BillingFormTextFieldCellDelegate: AnyObject {
    func textFieldShouldBeginEditing(textField: UITextField)
    func textFieldShouldReturn()
    func textFieldDidEndEditing(textField: UITextField)
    func textFieldDidChangeCharacters(textField: UITextField, replacementString: String)
}

final class BillingFormTextFieldCell: UITableViewCell {
    weak var delegate: BillingFormTextFieldCellDelegate?
    private var style: BillingFormTextFieldCellStyle
    private var type: BillingFormCellType
    
    init(type: BillingFormCellType, style: BillingFormTextFieldCellStyle, delegate: BillingFormTextFieldCellDelegate?) {
        self.style = style
        self.type = type
        super.init(style: .default, reuseIdentifier: nil)
        self.delegate = delegate
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var paymentInputView: BillingFormTextFieldView = {
        let view = BillingFormTextFieldView(type: type, style: style,delegate: self) 
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
}

// setup views
extension BillingFormTextFieldCell {
    
    private func setupViews() {
        contentView.addSubview(paymentInputView)
        NSLayoutConstraint.activate([
            paymentInputView.topAnchor.constraint(
                equalTo: contentView.safeTopAnchor,
                constant: 0),
            paymentInputView.leadingAnchor.constraint(
                equalTo: contentView.safeLeadingAnchor,
                constant: 20),
            paymentInputView.trailingAnchor.constraint(
                equalTo: contentView.safeTrailingAnchor,
                constant: -20),
            paymentInputView.bottomAnchor.constraint(
                equalTo: contentView.safeBottomAnchor,
                constant: -24)
        ])
    }
}

extension BillingFormTextFieldCell: BillingFormTextFieldViewDelegate {
    func textFieldDidEndEditing(textField: UITextField) {
        delegate?.textFieldDidEndEditing(textField: textField)
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) {
        delegate?.textFieldShouldBeginEditing(textField: textField)
    }
    func textFieldShouldReturn() {
        delegate?.textFieldShouldReturn()
    }
    
    func textFieldDidChangeCharacters(textField: UITextField, replacementString: String) {
        delegate?.textFieldDidChangeCharacters(textField: textField, replacementString: replacementString)
    }
   
}
