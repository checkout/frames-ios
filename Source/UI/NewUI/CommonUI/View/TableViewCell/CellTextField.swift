import UIKit
import Checkout

protocol CellTextFieldDelegate: AnyObject {
    func phoneNumberIsUpdated(number: String, tag: Int)
    func textFieldShouldBeginEditing(textField: UITextField)
    func textFieldShouldReturn()
    func textFieldShouldEndEditing(textField: UITextField, replacementString: String)
    func textFieldShouldChangeCharactersIn(textField: UITextField, replacementString string: String)
}

final class CellTextField: UITableViewCell {
    weak var delegate: CellTextFieldDelegate?
    var type: BillingFormCell?
    var style: CellTextFieldStyle?

    private lazy var mainView: TextFieldView? = {
        let view = TextFieldView()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViewsInOrder()
        backgroundColor = .clear
    }

    func update(type: BillingFormCell?, style: CellTextFieldStyle?, tag: Int, textFieldValue: String?) {
        self.type = type
        self.style = style
        self.tag = tag
        mainView?.update(style: style, type: type, textFieldValue: textFieldValue, tag: tag)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CellTextField {

    private func setupViewsInOrder() {
        guard let mainView = mainView else { return }
        contentView.addSubview(mainView)
        mainView.setContentHuggingPriority(.defaultLow, for: .vertical)
        mainView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
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

extension CellTextField: TextFieldViewDelegate {
    func phoneNumberIsUpdated(number: String, tag: Int) {
        delegate?.phoneNumberIsUpdated(number: number, tag: tag)
    }

    func textFieldShouldChangeCharactersIn(textField: UITextField, replacementString string: String) {
        delegate?.textFieldShouldChangeCharactersIn(textField: textField, replacementString: string)
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
