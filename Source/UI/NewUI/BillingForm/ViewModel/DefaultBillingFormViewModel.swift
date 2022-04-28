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
    
    func getCell(for row: Int, delegate: UIViewController? = nil) -> UITableViewCell {
        if row == 0 {
            return getHeaderCell(delegate: delegate as? BillingFormHeaderCellDelegate)
        }
        return getFieldCell(for: row, delegate: delegate as? BillingFormTextFieldCellDelegate)
    }
     
    private func getHeaderCell(delegate: BillingFormHeaderCellDelegate?) -> UITableViewCell {
        var style = style.header
        updateHeaderView(with: &style)
        let cell = BillingFormHeaderCell(style: style, delegate: delegate)
        self.editDelegate = cell
        return cell
    }
    
    private func getFieldCell(for row: Int, delegate: BillingFormTextFieldCellDelegate?) -> UITableViewCell {
        guard let type = BillingFormCellType(rawValue: row) else { return UITableViewCell()}
        var style = style.fields[row - 1]
        updateErrorView(with: &style, type: type)
        updateTextField(with: &style, type: type)
        return BillingFormTextFieldCell(type: type, style: style, delegate: delegate)
    }
    
    private func updateHeaderView(with style: inout BillingFormHeaderCellStyle) {
        style.doneButton.isEnabled = textValueOfCellType.values.count == self.style.fields.count
    }
    
    private func updateErrorView(with style: inout BillingFormTextFieldCellStyle, type: BillingFormCellType) {
        guard let hasError = errorFlagOfCellType[type] else { return }
        style.error.isHidden = !hasError
    }
    
    private func updateTextField(with style: inout BillingFormTextFieldCellStyle, type: BillingFormCellType) {
        guard let text = textValueOfCellType[type] else { return }
        style.textfield.text = text
    }
}

extension DefaultBillingFormViewModel: BillingFormViewControllerdelegate {
    func textFieldIsChanged(textField: BillingFormTextField, replacementString: String) {
        if !replacementString.isEmpty {
            textValueOfCellType[textField.type] = replacementString
        }

        if textValueOfCellType.values.count == style.fields.count {
            editDelegate?.didFinishEditingBillingForm(successfully: !errorFlagOfCellType.values.allSatisfy({$0}))
        }
    }
    
    func tableView(estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(numberOfRowsInSection section: Int) -> Int {
        style.fields.count + 1
    }
    
    func tableView(cellForRowAt indexPath: IndexPath, sender: UIViewController) -> UITableViewCell {
        getCell(for: indexPath.row, delegate: sender)
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
        textValueOfCellType[type] = text
        
        guard !type.validator.validate(text: textField.text) else {
            errorFlagOfCellType[type] = true
            updatedRow = type.rawValue
            return
        }
        errorFlagOfCellType[type] = false
        updatedRow = type.rawValue
    }
}
