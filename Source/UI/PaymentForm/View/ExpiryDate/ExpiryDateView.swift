import UIKit
import Checkout

enum ExpiryDateError: Error {
  case invalidCode
}

protocol ExpiryDateViewDelegate: AnyObject {
  func update(result: Result<ExpiryDate, ExpiryDateError>)
}

final class ExpiryDateView: UIView {

  weak var delegate: ExpiryDateViewDelegate?

  private(set) var style: CellTextFieldStyle?
  private let dateFormatter: ExpiryDateFormatter

  private(set) lazy var dateInputView: InputView = {
    let view = InputView().disabledAutoresizingIntoConstraints()
    view.delegate = self
    return view
  }()

  init(cardValidator: CardValidator) {
    self.dateFormatter = ExpiryDateFormatter(cardValidator: cardValidator)
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

  // MARK: - private functions
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
    guard textField.text?.count ?? 0 != dateFormatter.dateFormatTextCount else {
      return true
    }
    let (displayValue, _) = dateFormatter.formatForDisplay(input: textField.text ?? "")
    updateErrorViewStyle(isHidden: false,
                         textfieldText: displayValue,
                         error: .incompleteYear)
    return true
  }

  func textFieldShouldChangeCharactersIn(textField: UITextField, replacementString string: String) {
    guard let style = style else { return }
    dateInputView.updateBorderColor(with: style.textfield.borderStyle.focusColor)
  }

  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let outputText = textField.replacingCharacters(in: range, with: string) ?? ""

    defer {
      delegate?.update(result: dateFormatter.createCardExpiry(from: outputText))
    }
    // If string is empty when this is called, it means there was no character added to the change
    // meaning it is a deletion. We will not reformat a deletion as we risk to block user
    // We will just allow TextField to do its lifecycle and record modified value
    guard !string.isEmpty else {
      style?.textfield.text = outputText
        return true
    }

    // When the input is changed we will reformat it for display, notifying its consumers
    // of the new value
    let (displayValue, error) = dateFormatter.formatForDisplay(input: outputText)

    // Receiving nil from the formatting means the new input is invalid and we should not accept it,
    // dropping it completely
    guard displayValue != nil else {
      return false
    }
    updateErrorViewStyle(isHidden: error == nil,
                         textfieldText: displayValue,
                         error: error)
    // As we notify consumers, we already update the input value, so we do not want
    // the lifecycle to duplicate the update
    return false
  }
}
