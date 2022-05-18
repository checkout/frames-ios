import UIKit

protocol CKOCellTextFieldDelegate: AnyObject {
    func updateCountryCode(code: Int)
    func textFieldShouldBeginEditing(textField: UITextField)
    func textFieldShouldReturn()
    func textFieldShouldEndEditing(textField: UITextField, replacementString: String)
    func textFieldShouldChangeCharactersIn(textField: UITextField, replacementString string: String)
}

final class CKOCellTextField: UITableViewCell {
    weak var delegate: CKOCellTextFieldDelegate?
    var cellStyle: BillingFormCell? = nil
    var style: CKOCellTextFieldStyle? = nil

    private var mainView: UIView
    init(mainView: UIView) {
        self.mainView = mainView
        super.init(style: .default, reuseIdentifier: nil)
        self.setupViewsInOrder()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CKOCellTextField {
    
    private func setupViewsInOrder() {
        mainView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(mainView)
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(
                equalTo: contentView.topAnchor),
            mainView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor),
            mainView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor),
            mainView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -24)
        ])
    }
}

extension CKOCellTextField: CKOTextFieldViewDelegate {
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
