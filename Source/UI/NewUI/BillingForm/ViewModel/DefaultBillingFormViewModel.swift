import UIKit

final class DefaultBillingFormViewModel: BillingFormViewModel {
    var style: BillingFormStyle
    var updateRow: (() -> Void)?
    var updatedRow: Int? {
        didSet {
            updateRow?()
        }
    }
    
    var errorFlagOfCellType = [BillingFormCellType: Bool]()
    var textValueOfCellType = [BillingFormCellType: String]()
    
    private var initialCountry: String
    private var initialRegionCode: String?
    var editDelegate: BillingFormViewModelEditingDelegate?
    var delegate: BillingFormViewModelDelegate?
    
    init(style: BillingFormStyle,
         initialCountry: String = "",
         initialRegionCode: String? = nil,
         delegate: BillingFormViewModelDelegate? = nil) {
        self.style = style
        self.initialCountry = initialCountry
        self.initialRegionCode = initialRegionCode
        self.delegate = delegate
    }
     
    func getHeaderView(delegate: BillingFormHeaderCellDelegate?) -> UIView {
        var style = style.header
        style.doneButton.isEnabled = textValueOfCellType.values.count == self.style.fields.count
        let view = BillingFormHeaderCell(style: style, delegate: delegate)
        self.editDelegate = view
        return view
    }
    
    func update(cell: BillingFormTextFieldCell, row: Int,  delegate: BillingFormTextFieldCellDelegate?) -> UITableViewCell {
        guard style.fields.count > row else { return UITableViewCell() }
        var style = style.fields[row]
        updateErrorView(with: &style)
        updateTextField(with: &style)
        cell.delegate = delegate
        cell.update(style: style, tag: row)
        return cell
    }
    
    private func updateErrorView(with style: inout BillingFormTextFieldCellStyle) {
        guard let hasError = errorFlagOfCellType[style.type] else { return }
        style.error.isHidden = !hasError
    }
    
    private func updateTextField(with style: inout BillingFormTextFieldCellStyle) {
        guard let text = textValueOfCellType[style.type] else { return }
        style.textfield.text = text
    }
}

extension DefaultBillingFormViewModel: BillingFormViewControllerdelegate {
    func getViewForHeader(sender: UIViewController) -> UIView? {
         return getHeaderView(delegate: sender as? BillingFormHeaderCellDelegate)
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func textFieldShouldEndEditing(textField: BillingFormTextField, replacementString: String) {
        validate(textField: textField)

        if !replacementString.isEmpty {
            textValueOfCellType[textField.type] = replacementString
        }

        if textValueOfCellType.values.count == style.fields.count {
            let isSuccessful =  (errorFlagOfCellType.isEmpty || errorFlagOfCellType.values.allSatisfy({$0}))
            editDelegate?.didFinishEditingBillingForm(successfully:  isSuccessful)
        }
    }
    
    func tableView(estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(numberOfRowsInSection section: Int) -> Int {
        style.fields.count
    }
    
    func tableView(tableView: UITableView, cellForRowAt indexPath: IndexPath, sender: UIViewController) -> UITableViewCell {
        let cell = BillingFormTextFieldCell()
        return update(cell: cell, row: indexPath.row, delegate: sender as? BillingFormViewController)
    }
    
    func doneButtonIsPressed(sender: UIViewController) {
//        let countryCode = "\(addressView.phoneInputView.phoneNumber?.countryCode ?? 44)"
        let phone = CkoPhoneNumber(countryCode: "44",
                                   number: textValueOfCellType[.phoneNumber])
        let address = CkoAddress(addressLine1: textValueOfCellType[.addressLine1],
                                 addressLine2: textValueOfCellType[.addressLine2],
                                 city: textValueOfCellType[.city],
                                 state: textValueOfCellType[.state],
                                 zip: textValueOfCellType[.postcode],
                                 country: textValueOfCellType[.country])
       delegate?.onTapDoneButton(address: address, phone: phone)
      sender.dismiss(animated: true)
    }
    
    func cancelButtonIsPressed(sender: UIViewController) {
        sender.dismiss(animated: true)
    }
    
    func validate(textField: BillingFormTextField)  {
        let type = textField.type
        let text = textField.text

        defer {
            textValueOfCellType[type] = text
            updatedRow = textField.tag
        }
        
        guard !type.validator.validate(text: textField.text) else {
            errorFlagOfCellType[type] = true
            return
        }
        errorFlagOfCellType[type] = false
    }
}
