import UIKit

final class DefaultBillingFormViewModel: BillingFormViewModel {
    var style: BillingFormStyle
    var updateRow: (() -> Void)?
    var updatedRow: Int? {
        didSet {
            updateRow?()
        }
    }
    
    var errorFlagOfCellType = [Int: Bool]()
    var textValueOfCellType = [Int: String]()
    
    var editDelegate: BillingFormViewModelEditingDelegate?
    weak var delegate: BillingFormViewModelDelegate?
    
    private var initialCountry: String
    private var initialRegionCode: String?
    private var countryCode: Int = 0
    
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
        style.doneButton.isEnabled = textValueOfCellType.values.count == self.style.cells.count
        let view = BillingFormHeaderCell(style: style, delegate: delegate)
        self.editDelegate = view
        return view
    }
    
    func getCell( row: Int,  delegate: BillingFormTextFieldCellDelegate?) -> UITableViewCell {
        let currentStyle = style.cells[row]
        guard style.cells.count > row,
              var cellStyle = currentStyle.style
        else { return UITableViewCell() }
        
        if cellStyle.isOptinal {
            textValueOfCellType[currentStyle.hash, default: ""] += ""
            errorFlagOfCellType[currentStyle.hash] = false
        }
        
        let hash = currentStyle.hash
        updateErrorView(with: &cellStyle, hashValue: hash)
        updateTextField(with: &cellStyle, hashValue: hash)
        
        let cell = BillingFormTextFieldCell()
        cell.delegate = delegate
        cell.update(cellStyle: currentStyle, style: cellStyle, tag: row)
        return cell
    }
    
    private func updateErrorView(with style: inout BillingFormTextFieldCellStyle, hashValue: Int) {
        guard let hasError = errorFlagOfCellType[hashValue] else { return }
        style.error.isHidden = !hasError
    }
    
    private func updateTextField(with style: inout BillingFormTextFieldCellStyle, hashValue: Int) {
        guard let text = textValueOfCellType[hashValue] else { return }
        style.textfield.text = text
    }
}

extension DefaultBillingFormViewModel: BillingFormViewControllerdelegate {
    
    func updateCountryCode(code: Int) {
        countryCode = code
    }
    
    func getViewForHeader(sender: UIViewController) -> UIView? {
        return getHeaderView(delegate: sender as? BillingFormHeaderCellDelegate)
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func textFieldShouldEndEditing(textField: BillingFormTextField, replacementString: String) {
        validate(text: textField.text , cellStyle: textField.type, row: textField.tag)
        
        if !(textField.text?.isEmpty ?? true) || textField.type.style?.isOptinal ?? false {
            textValueOfCellType[textField.type.hash] = textField.text
        } else {
            textValueOfCellType[textField.type.hash] = nil
            
        }
        updatedRow = textField.tag
    }
    
    func textFieldShouldChangeCharactersIn(textField: UITextField, replacementString string: String) {
        guard let textField = textField as? BillingFormTextField else { return }
        validate(text: string , cellStyle: textField.type, row: textField.tag)
        
        if !(string.isEmpty)  {
            textValueOfCellType[textField.type.hash] = string
        } else if textField.text?.count ?? 1 == 1, !(textField.type.style?.isOptinal ?? false)  {
            textValueOfCellType[textField.type.hash] = nil
        }
        
        let isSuccessful =  textValueOfCellType.values.count == style.cells.count && !(errorFlagOfCellType.isEmpty || errorFlagOfCellType.values.allSatisfy({$0}))
        editDelegate?.didFinishEditingBillingForm(successfully:  isSuccessful)
    }
    
    
    func tableView(estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(numberOfRowsInSection section: Int) -> Int {
        style.cells.count
    }
    
    func tableView(tableView: UITableView, cellForRowAt indexPath: IndexPath, sender: UIViewController) -> UITableViewCell {
        getCell(row: indexPath.row, delegate: sender as? BillingFormViewController)
    }
    
    func doneButtonIsPressed(sender: UIViewController) {
        let phone = CkoPhoneNumber(countryCode: "\(countryCode)",
                                   number: textValueOfCellType[BillingFormCell.phoneNumber(nil).hash])
        let address = CkoAddress(addressLine1: textValueOfCellType[BillingFormCell.addressLine1(nil).hash],
                                 addressLine2: textValueOfCellType[BillingFormCell.addressLine2(nil).hash],
                                 city: textValueOfCellType[BillingFormCell.city(nil).hash],
                                 state: textValueOfCellType[BillingFormCell.state(nil).hash],
                                 zip: textValueOfCellType[BillingFormCell.postcode(nil).hash],
                                 country: textValueOfCellType[BillingFormCell.country(nil).hash])
        delegate?.onTapDoneButton(address: address, phone: phone)
        sender.dismiss(animated: true)
    }
    
    func cancelButtonIsPressed(sender: UIViewController) {
        sender.dismiss(animated: true)
    }
    
    internal func validate(text: String?, cellStyle: BillingFormCell, row: Int)  {
        guard let style = cellStyle.style, !style.isOptinal else {
            errorFlagOfCellType[cellStyle.hash] = false
            return
        }
        errorFlagOfCellType[cellStyle.hash] = cellStyle.validator.validate(text: text)
    }
}
