import UIKit
import Checkout

/// Cvv Input View containing a label and an input field.
/// Handles the formatting of the text field.
@IBDesignable public class CvvInputView: StandardInputView, UITextFieldDelegate {

    // MARK: - Properties

    let maxLengthCvv = 4
    var scheme = Card.Scheme.unknown
    let cardValidator: CardValidating?
    /// Text field delegate
    public weak var delegate: UITextFieldDelegate?
    public weak var onChangeDelegate: CvvInputViewDelegate?

    // MARK: - Initialization

    /// Initializes and returns a newly allocated view object with the specified frame rectangle.
    public override init(frame: CGRect) {
        self.cardValidator = nil
        super.init(frame: frame)
        setup()
    }

    /// Returns an object initialized from data in a given unarchiver.
    public required init?(coder aDecoder: NSCoder) {
        self.cardValidator = nil
        super.init(coder: aDecoder)
        setup()
    }

    init(cardValidator: CardValidating?) {
        self.cardValidator = cardValidator
        super.init(frame: .zero)
        setup()
    }

    // MARK: - Setup

    private func setup() {
        textField.keyboardType = .asciiCapableNumberPad
        textField.textContentType = nil
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
    }

    // MARK: - UITextFieldDelegate

    /// Asks the delegate if the specified text should be changed.
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                          replacementString string: String) -> Bool {
        let cvv = "\(textField.text!)\(string)"
        guard cvv.count <= maxLengthCvv else {
            return false
        }

        guard let cardValidator = cardValidator else {
            return true
        }

        switch cardValidator.validate(cvv: cvv, cardScheme: scheme) {
        case .success:
            return true
        case .failure(let error):
            switch error {
            case .containsNonDigits:
                return false
            // TODO: we should add an error case for incomplete CVV
            case .invalidLength:
                return true
            }
        }
    }

    /// Tells the delegate that editing stopped for the specified text field.
    public func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.textFieldDidEndEditing?(textField)
    }

    /// Called when the text changed.
    @objc public func textFieldDidChange(textField: UITextField) {
        onChangeDelegate?.onChangeCvv()
    }
}
