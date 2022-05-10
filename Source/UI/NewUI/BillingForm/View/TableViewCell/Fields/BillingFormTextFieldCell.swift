import UIKit
import PhoneNumberKit

protocol BillingFormTextFieldCellDelegate: AnyObject {
    func updateCountryCode(code: Int)
    func textFieldShouldBeginEditing(textField: UITextField)
    func textFieldShouldReturn()
    func textFieldShouldEndEditing(textField: UITextField, replacementString: String)
}

final class BillingFormTextFieldCell: UITableViewCell {
    weak var delegate: BillingFormTextFieldCellDelegate?
    var style: BillingFormTextFieldCellStyle? = nil

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    func update(style: BillingFormTextFieldCellStyle, tag: Int) {
        self.style = style
        self.tag = tag
        setupViews()
    }
    

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var paymentInputView: UIView = {
        guard let style = style else { return UIView() }
        let view = BillingFormTextFieldView(type: style.type, tag: tag, style: style ,delegate: self)
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
                equalTo: contentView.safeTopAnchor),
            paymentInputView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor),
            paymentInputView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor),
            paymentInputView.bottomAnchor.constraint(
                equalTo: contentView.safeBottomAnchor,
                constant: -24)
        ])
    }
}

extension BillingFormTextFieldCell: BillingFormTextFieldViewDelegate {
    func updateCountryCode(code: Int) {
        delegate?.updateCountryCode(code: code)
    }
    
    
    func textFieldShouldBeginEditing(textField: UITextField) {
        delegate?.textFieldShouldBeginEditing(textField: textField)
    }
    func textFieldShouldReturn() {
        delegate?.textFieldShouldReturn()
    }
    
    func textFieldShouldEndEditing(textField: UITextField, replacementString: String) {
        delegate?.textFieldShouldEndEditing(textField: textField, replacementString: replacementString)
    }
   
}
