import UIKit
import Checkout

/// Card Number Input View containing a label and an input field.
/// Handles the formatting of the text field.
@IBDesignable public class CardNumberInputView: StandardInputView, UITextFieldDelegate {

    // MARK: - Properties

    var cardUtils: CardUtils!
    var cardValidator: CardValidating?
    /// Text field delegate
    public weak var delegate: CardNumberInputViewDelegate?

    private var previousTextCount = 0

    // MARK: - Initialization

    /// Initializes and returns a newly allocated view object with the specified frame rectangle.
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup(cardValidator: nil)
    }

    /// Returns an object initialized from data in a given unarchiver.
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup(cardValidator: nil)
    }

    public init(frame: CGRect = CGRect.zero, cardValidator: CardValidating?) {
        super.init(frame: frame)
        setup(cardValidator: cardValidator)
    }

    private func setup(cardValidator: CardValidating?) {
        #if !TARGET_INTERFACE_BUILDER
        cardUtils = CardUtils()
        self.cardValidator = cardValidator
        #endif
        textField.keyboardType = .default
        textField.textContentType = .creditCardNumber
        textField.font = CheckoutTheme.font
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
    }

    // MARK: - UITextFieldDelegate

    /// Tells the delegate that editing began in the specified text field.
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        hideError()
    }

    /// Asks the delegate if the specified text should be changed.
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                          replacementString string: String) -> Bool {
        guard let cardNumber = textField.text else {
            return false
        }

        guard let cardValidator = cardValidator else {
            return false
        }

        switch cardValidator.validate(cardNumber: "\(cardNumber)\(string)") {
        case .success(let scheme):
            return scheme != .unknown
        case .failure:
            return false
        }
    }

    /// Called when the text changed.
    @objc public func textFieldDidChange(textField: UITextField) {
        guard let cardUtils = cardUtils,
              let rawText = textField.text else {
            return
        }

        let cardNumber = cardUtils.removeNonDigits(from: rawText)
        let scheme = (try? cardValidator?.validate(cardNumber: cardNumber).get()) ?? .unknown

        delegate?.onChangeCardNumber(scheme: scheme)

        // Potential Task : add CardType and cardTypes to Checkout SDK and also format function.
        let cardNumberFormatted = cardUtils.format(cardNumber: cardNumber, scheme: scheme)
        textField.text = cardNumberFormatted

        previousTextCount = cardNumberFormatted.count
    }

    /// Tells the delegate that editing stopped for the specified text field.
    public func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.textFieldDidEndEditing(view: self)
    }
}
