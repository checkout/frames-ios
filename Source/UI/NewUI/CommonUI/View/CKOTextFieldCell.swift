import UIKit
import PhoneNumberKit

protocol BillingFormTextFieldCellDelegate: AnyObject {
    func updateCountryCode(code: Int)
    func textFieldShouldBeginEditing(textField: UITextField)
    func textFieldShouldReturn()
    func textFieldShouldEndEditing(textField: UITextField, replacementString: String)
    func textFieldShouldChangeCharactersIn(textField: UITextField, replacementString string: String)
}

final class CKOTextFieldCell: UITableViewCell {
    weak var delegate: BillingFormTextFieldCellDelegate?
    var cellStyle: BillingFormCell? = nil
    var style: CKOTextFieldCellStyle? = nil

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    func update(cellStyle:BillingFormCell, style: CKOTextFieldCellStyle, tag: Int) {
        self.cellStyle = cellStyle
        self.style = style
        self.tag = tag
        setupViewsInOrder()
    }
    

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var paymentInputView: UIView = {
        guard let cellStyle = cellStyle, let style = style else { return UIView() }
        let view = CKOTextFieldView(type: cellStyle, tag: tag, style: style ,delegate: self)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
}

extension CKOTextFieldCell {
    
    private func setupViewsInOrder() {
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

extension CKOTextFieldCell: BillingFormTextFieldViewDelegate {
    func textFieldShouldChangeCharactersIn(textField: UITextField, replacementString string: String) {
        delegate?.textFieldShouldChangeCharactersIn(textField: textField, replacementString: string)
    }
    
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
