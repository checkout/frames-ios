import UIKit
import Checkout

/**
 This class is for billing form list view model logic.
 */

final class DefaultBillingFormViewModel: BillingFormViewModel {

    // MARK: - Properties

    var style: BillingFormStyle
    var updateRow: (() -> Void)?
    var updatedRow: Int? {
        didSet { updateRow?() }
    }
    
    var errorFlagOfCellType = [Int: Bool]()
    var textValueOfCellType = [Int: String]()
    
    weak var editDelegate: BillingFormViewModelEditingDelegate?
    weak var textFieldDelegate: BillingFormTextFieldDelegate?
    weak var delegate: BillingFormViewModelDelegate?

    private var initialCountry: String
    private var initialRegionCode: String?
    private var countryCode: Int = 0

    // MARK: - Public methods

    /**
     Initializes view model with some required protocols

     - Parameters:
        - style: The bill form view Style implementation.
        - initialCountry: //TODO: will be implemented in country ticket
        - initialRegionCode: //TODO: will be implemented in country next ticket
        - delegate: Optional billing form view Model delegate
      */
    
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
        let isDoneButtonEnabled = textValueOfCellType.values.count == self.style.cells.count
        style.doneButton.isEnabled = isDoneButtonEnabled

        let view = BillingFormHeaderCell(style: style, delegate: delegate)
        view.update(style: style)
        self.editDelegate = view
        return view
    }

    func getCell(tableView: UITableView, indexPath: IndexPath,  delegate: CellTextFieldDelegate?) -> UITableViewCell {
        guard style.cells.count > indexPath.row, var viewStyle = style.cells[indexPath.row].style
        else { return UITableViewCell() }

        updateStyle(with: &viewStyle, cellStyle: style.cells[indexPath.row], tag: indexPath.row)

        return getCell(tableView: tableView,
                       viewStyle: &viewStyle,
                       cellStyle: style.cells[indexPath.row],
                       indexPath: indexPath,
                       delegate: delegate)
    }

    // MARK: - Private methods

    private func updateStyle(with viewStyle: inout CellTextFieldStyle, cellStyle: BillingFormCell, tag: Int) {
        if viewStyle.isOptional {
            textValueOfCellType[cellStyle.index, default: ""] += ""
            errorFlagOfCellType[cellStyle.index] = false
        }

        let hash = cellStyle.index
        updateErrorViewStyle(with: &viewStyle, hashValue: hash)
        updateTextFieldStyle(with: &viewStyle, hashValue: hash)
    }

    private func getCell(tableView: UITableView, viewStyle: inout CellTextFieldStyle, cellStyle: BillingFormCell, indexPath: IndexPath, delegate: CellTextFieldDelegate?) -> UITableViewCell {

        let cell: CellTextField = tableView.dequeueReusable(for: indexPath)
        cell.delegate = delegate
        cell.update(cellStyle: cellStyle, style: viewStyle, tag: indexPath.row)

        return cell
    }


    private func updateErrorViewStyle(with style: inout CellTextFieldStyle, hashValue: Int) {
        guard let hasError = errorFlagOfCellType[hashValue] else { return }
        style.error.isHidden = !hasError
    }
    
    private func updateTextFieldStyle(with style: inout CellTextFieldStyle, hashValue: Int) {
        guard let text = textValueOfCellType[hashValue] else { return }
        style.textfield.text = text
    }

    // MARK: - Text Field logic

    func validate(text: String?, cellStyle: BillingFormCell, row: Int)  {
        guard cellStyle.index <= errorFlagOfCellType.count,
              cellStyle.index >= 0,
              let style = cellStyle.style,
              !style.isOptional else {
            errorFlagOfCellType[cellStyle.index] = false
            return
        }
        errorFlagOfCellType[cellStyle.index] = cellStyle.validator.validate(text: text)
    }

    func validateTextFieldByCharacter(textField: UITextField, replacementString string: String) {
        guard let type = (textField as? BillingFormTextField)?.type else { return }

        validate(text: string , cellStyle: type, row: textField.tag)

        let shouldRemoveText = (textField.text?.count ?? 1 == 1) && !(type.style?.isOptional ?? false)

        if !string.isEmpty {
            textValueOfCellType[type.index] = string
        } else if shouldRemoveText {
            textValueOfCellType[type.index] = nil
        }

        let hasErrorValue = errorFlagOfCellType.isEmpty || errorFlagOfCellType.values.allSatisfy({$0})

        let areAllFieldsAreFulfilled = textValueOfCellType.values.count == style.cells.count && !hasErrorValue

        editDelegate?.didFinishEditingBillingForm(successfully:  areAllFieldsAreFulfilled)
    }

    private func validateTextOnEndEditing(textField: BillingFormTextField) {
        guard let type = textField.type else { return }

        validate(text: textField.text , cellStyle: type, row: textField.tag)

        let shouldSaveText = !(textField.text?.isEmpty ?? true) || (type.style?.isOptional ?? false)

        textValueOfCellType[type.index] =  shouldSaveText ? textField.text : nil

        updatedRow = textField.type?.index
    }
}

// MARK: - Table View Delegate

extension DefaultBillingFormViewModel: BillingFormTableViewDelegate {
    func tableView(estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        UITableView.automaticDimension
    }

    func tableView(numberOfRowsInSection section: Int) -> Int {
        style.cells.count
    }

    func tableView(tableView: UITableView, cellForRowAt indexPath: IndexPath, sender: UIViewController) -> UITableViewCell {
        getCell(tableView: tableView, indexPath: indexPath, delegate: sender as? BillingFormViewController)
    }
}

// MARK: - Text View Delegate

extension DefaultBillingFormViewModel: BillingFormTextFieldDelegate {
    func textFieldShouldEndEditing(textField: BillingFormTextField, replacementString: String) {
        validateTextOnEndEditing(textField: textField)
    }

    func textFieldShouldChangeCharactersIn(textField: UITextField, replacementString string: String) {
        validateTextFieldByCharacter(textField: textField, replacementString: string)
    }
}

// MARK: - Billing form view controller Delegate

extension DefaultBillingFormViewModel: BillingFormViewControllerDelegate {
    
    func updateCountryCode(code: Int) {
        countryCode = code
    }
    
    func getViewForHeader(sender: UIViewController) -> UIView? {
        return getHeaderView(delegate: sender as? BillingFormHeaderCellDelegate)
    }

    func doneButtonIsPressed(sender: UIViewController) {
        
        let phone = Phone(
            number: textValueOfCellType[BillingFormCell.phoneNumber(nil).index],
            country: nil)
        
        let address = Address(
            addressLine1: textValueOfCellType[BillingFormCell.addressLine1(nil).index],
            addressLine2: textValueOfCellType[BillingFormCell.addressLine2(nil).index],
            city: textValueOfCellType[BillingFormCell.city(nil).index],
            state: textValueOfCellType[BillingFormCell.state(nil).index],
            zip: textValueOfCellType[BillingFormCell.postcode(nil).index],
            country: nil)

        delegate?.onTapDoneButton(address: address, phone: phone)
        sender.dismiss(animated: true)
    }
    
    func cancelButtonIsPressed(sender: UIViewController) {
        sender.dismiss(animated: true)
    }
}
