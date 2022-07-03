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
  private let environment: Environment

  private lazy var cardValidator: CardValidator = {
    CardValidator(environment: environment.checkoutEnvironment)
  }()
  
  private lazy var expiryDateView: InputView = {
    let view = InputView().disabledAutoresizingIntoConstraints()
    view.delegate = self
    return view
  }()
  
  init(environment: Environment) {
    self.environment = environment
    super.init(frame: .zero)
    // setup expiry DateView
    addSubview(expiryDateView)
    expiryDateView.setupConstraintEqualTo(view: self)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func update(style: CellTextFieldStyle?) {
    self.style = style
    expiryDateView.update(style: style)
  }
  
  private func updateErrorView(isHidden: Bool, text: String?, error: ValidationError.ExpiryDate? = nil){
    defer {
      style?.error?.isHidden = isHidden
      style?.textfield.text = text ?? ""
      expiryDateView.update(style: style)
    }

    guard let error = error else { return }
    var errorText = ""
    switch error {
      case .invalidMonthString,
          .invalidYearString,
          .invalidMonth,
          .invalidYear:
        errorText = Constants.LocalizationKeys.PaymentForm.ExpiryDate.Error.invalid
      case .incompleteMonth,
          .incompleteYear:
        errorText = Constants.LocalizationKeys.PaymentForm.ExpiryDate.Error.missing
      case .inThePast:
        errorText = Constants.LocalizationKeys.PaymentForm.ExpiryDate.Error.past
    }
    style?.error?.text = errorText
  }
  
  func updateExpiryDate(to newDate: String?){
    guard newDate?.count == dateFormatTextCount else {
      updateErrorView(isHidden: false, text: newDate, error: .invalidYear)
      return
    }
    let subString = newDate?.split(separator: "/")
    guard let month = subString?.first,
          month.count == 2,
          let monthDigit = Int(month),
          let year = subString?.last,
          year.count == 2,
          let yearDigit = Int(year) else {
      updateErrorView(isHidden: false, text: newDate, error: .invalidYear)
      return
    }
    
    switch cardValidator.validate(expiryMonth: monthDigit, expiryYear: yearDigit) {
      case .success:
        let expiryDate = ExpiryDate(month: monthDigit, year: yearDigit)
        delegate?.update(expiryDate: expiryDate)
        updateErrorView(isHidden: true, text: newDate)
      case .failure(let error):
        print(error)
        updateErrorView(isHidden: false, text: newDate, error: error)
    }
  }

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
          updateErrorView(isHidden: false, text: textField.text, error: .invalidMonth)
          return false
        }

        switch previousDigit {
          case  0 where 1...9 ~= currentDigit,
                1 where 0...2 ~= currentDigit: break
          default:
            updateErrorView(isHidden: false, text: textField.text, error: .invalidMonth)
            return false
        }

      case 2:
        textField.text?.append("/")
        guard 2...9 ~= currentDigit else {
          updateErrorView(isHidden: false, text: textField.text, error: .invalidYear)
          return false
        }

      case 3:
        guard 2...9 ~= currentDigit else {
          updateErrorView(isHidden: false, text: textField.text, error: .invalidYear)
          return false
        }

      case 4:
        updateExpiryDate(to: (textField.text ?? "") + replacementText)
        return false

      default: break
    }

    return true
  }
}

extension ExpiryDateView: TextFieldViewDelegate {
  func textFieldShouldBeginEditing(textField: UITextField) {}
  func textFieldShouldReturn() -> Bool {  return true }
  func textFieldShouldEndEditing(textField: UITextField, replacementString: String) -> Bool { return true }
  
  func textFieldShouldChangeCharactersIn(textField: UITextField, replacementString string: String) {
    expiryDateView.textFieldContainer.layer.borderColor = style?.textfield.focusBorderColor.cgColor
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    updateErrorView(isHidden: true, text: textField.text)
    /*
     Expiry date text format is "MM/yy"
     5 is the expected text count, for example "11/35".
     location starts from 0 to dateFormatTextCount - 1
     */
    guard range.location < dateFormatTextCount else {
      updateErrorView(isHidden: false, text: textField.text, error: .invalidMonth)
      return false
    }
    
    // Hide error view on remove from last location
    if range.location == dateFormatTextCount - 1 {
      updateErrorView(isHidden: true, text: textField.text)
    }
    
    if range.length > 0 {
      if range.location == dateFormatTextCount - 2 {
        var originalText = textField.text
        originalText = originalText?.replacingOccurrences(of: "/", with: "")
        textField.text = originalText
      }
      return true
    }
    
    //check for max length including added spacers which all equal to 5
    guard !string.isEmpty else { return false }
    
    let replacementText = string.replacingOccurrences(of: " ", with: "")
    
    //verify entered text is a numeric value
    guard CharacterSet(charactersIn: replacementText).isSubset(of: .decimalDigits) else { return false }
    guard let currentDigit = Int(replacementText) else { return false }

    return validateInput(textField, currentDigit: currentDigit, location: range.location, replacementText: replacementText)
  }
}
