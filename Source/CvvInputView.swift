import UIKit

/// Cvv Input View containing a label and an input field.
/// Handles the formatting of the text field.
@IBDesignable public class CvvInputView: StandardInputView, UITextFieldDelegate {

    // MARK: - Properties

    let maxLengthCvv = 4
    var cardType: CardType?
    /// Text field delegate
    public weak var delegate: UITextFieldDelegate?
    public weak var onChangeDelegate: CvvInputViewDelegate?

    // MARK: - Initialization

    /// Initializes and returns a newly allocated view object with the specified frame rectangle.
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    /// Returns an object initialized from data in a given unarchiver.
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
        if let cardType = self.cardType {
            if cvv.count > cardType.validCvvLengths.last! { return false }
        }
        return true
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
