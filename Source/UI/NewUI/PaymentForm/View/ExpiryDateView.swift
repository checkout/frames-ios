import UIKit
import Checkout

protocol ExpiryDateViewDelegate: AnyObject {
  func update(expiryDate: ExpiryDate)
}

public final class ExpiryDateView: UIView {
  weak var delegate: ExpiryDateViewDelegate?

  /// 5 is the expected text count, for example "11/35".
  private let dateFormatTextCount = 5
  private(set) var style: CellTextFieldStyle?
  private let cardValidator: CardValidator

  private lazy var dateInputView: InputView = {
    let view = InputView().disabledAutoresizingIntoConstraints()
    view.delegate = self
    return view
  }()

  init(cardValidator: CardValidator) {
    self.cardValidator = cardValidator
    super.init(frame: .zero)
    // setup expiry DateView
    addSubview(dateInputView)
    dateInputView.setupConstraintEqualTo(view: self)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func update(style: CellTextFieldStyle?) {
    self.style = style
    self.style?.textfield.isSupportingNumericKeyboard = true
    dateInputView.update(style: self.style)
  }

  func updateExpiryDate(to textfieldText: String, replacementText: String) -> Bool {
    let date = textfieldText + replacementText
    guard date.count == dateFormatTextCount else {
      updateErrorViewStyle(isHidden: false, textfieldText: textfieldText, error: .invalidYear)
      return false
    }
    let subString = date.split(separator: "/")
    guard let month = subString.first,
          month.count == 2,
          let monthDigit = Int(month),
          let year = subString.last,
          year.count == 2,
          let yearDigit = Int(year) else {
      updateErrorViewStyle(isHidden: false, textfieldText: textfieldText, error: .invalidYear)
      return false
    }

    switch cardValidator.validate(expiryMonth: monthDigit, expiryYear: yearDigit) {
      case .success:
        let expiryDate = ExpiryDate(month: monthDigit, year: yearDigit)
        delegate?.update(expiryDate: expiryDate)
        updateErrorViewStyle(isHidden: true, textfieldText: textfieldText)
        return true
      case .failure(let error):
        print(error)
        updateErrorViewStyle(isHidden: false, textfieldText: textfieldText, error: error)
        return false
    }
  }

  // MARK: - private functions

  /*
   Input validation from location 0 to 4 (MM/yy):
   ===============

   if location 0 (first month digit)
   if user enters a number between 2-9,
   then move to the year selector and append a 0 before the digit

   if location 1 (2nd month digit)
   if user enters a 0,
   then enter any digit between 1-9
   if user enters a 1,
   then enter any digit between 0-2

   if location 3 (backslash '/')
   then user must enter a number between 2-9 to start with

   if location 4 (first year digit)
   then user must enter a number between 2-9 to start with

   if location 5 (2nd year digit)
   then validate full Expiry Date
   */

  private func validateInput(_ textField: UITextField, currentDigit: Int, location: Int, replacementText: String) -> Bool {
    switch location {
      case 0 where 2...9 ~= currentDigit:
        textField.text = "0"

      case 1:
        guard let originalText = textField.text, let previousDigit = Int(originalText) else {
          updateErrorViewStyle(isHidden: false, textfieldText: textField.text, error: .invalidMonth)
          return false
        }

        switch previousDigit {
          case  0 where 1...9 ~= currentDigit,
                1 where 0...2 ~= currentDigit:
            break
          default:
            updateErrorViewStyle(isHidden: false, textfieldText: textField.text, error: .invalidMonth)
            return false
        }

      case 2:
        textField.text?.append("/")
        guard 2...9 ~= currentDigit else {
          updateErrorViewStyle(isHidden: false, textfieldText: textField.text, error: .invalidYear)
          return false
        }

      case 3:
        guard 2...9 ~= currentDigit else {
          updateErrorViewStyle(isHidden: false, textfieldText: textField.text, error: .invalidYear)
          return false
        }

      case 4:
        return updateExpiryDate(to: textField.text ?? "", replacementText: replacementText)
      default: break
    }

    return true
  }

  private func updateErrorViewStyle(isHidden: Bool, textfieldText: String?, error: ValidationError.ExpiryDate? = nil) {
    style?.error?.text = error == .inThePast ?
      Constants.LocalizationKeys.PaymentForm.ExpiryDate.Error.past :
      Constants.LocalizationKeys.PaymentForm.ExpiryDate.Error.invalid
    style?.error?.isHidden = isHidden
    style?.textfield.text = textfieldText ?? ""
    dateInputView.update(style: style)
  }
}

extension ExpiryDateView: TextFieldViewDelegate {
  func textFieldShouldBeginEditing(textField: UITextField) {}
  func textFieldShouldReturn() -> Bool { return false }
  func textFieldShouldEndEditing(textField: UITextField, replacementString: String) -> Bool {
    if textField.text?.count ?? 0 < dateFormatTextCount {
      updateErrorViewStyle(isHidden: false, textfieldText: textField.text, error: .invalidMonth)
    }
    return true
  }

  func textFieldShouldChangeCharactersIn(textField: UITextField, replacementString string: String) {
    dateInputView.textFieldContainer.layer.borderColor = style?.textfield.focusBorderColor.cgColor
  }

  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    updateErrorViewStyle(isHidden: true, textfieldText: textField.text)
    /*
     Expiry date text format is "MM/yy"
     5 is the expected text count, for example "11/35".
     location starts from 0 to dateFormatTextCount - 1
     */
    guard range.location < dateFormatTextCount else { return false }

    // Hide error view on remove from last location
    if range.location == dateFormatTextCount - 1 {
      updateErrorViewStyle(isHidden: true, textfieldText: textField.text)
    }

    if range.length > 0 {
      if range.location == dateFormatTextCount - 2 {
        var originalText = textField.text
        originalText = originalText?.replacingOccurrences(of: "/", with: "")
        textField.text = originalText
      }
      return true
    }

    // check for max length including added spacers which all equal to 5
    guard !string.isEmpty else { return false }
    let replacementText = string.replacingOccurrences(of: " ", with: "")

    // verify entered text is a numeric value
    guard CharacterSet(charactersIn: replacementText).isSubset(of: .decimalDigits) else { return false }
    guard let currentDigit = Int(replacementText) else { return false }

    return validateInput(textField, currentDigit: currentDigit, location: range.location, replacementText: replacementText)
  }
}
