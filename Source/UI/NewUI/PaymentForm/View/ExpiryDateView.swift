import UIKit
import Checkout

protocol ExpiryDateViewDelegate: AnyObject {
    func update(expiryDate: ExpiryDate)
}

final class ExpiryDateView: UIView {
    weak var delegate: ExpiryDateViewDelegate?

    /// 5 is the expected text count, for example "11/35".
    private let dateFormatTextCount = 5

    private(set) var style: CellTextFieldStyle?

    private lazy var cardValidator: CardValidator = {
        CardValidator(environment: .production)
    }()

    private lazy var expiryDateView: InputView = {
        let view = InputView().disabledAutoresizingIntoConstraints()
        view.delegate = self
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

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

    private func updateErrorView(isHidden: Bool, text: String?){
        style?.error?.isHidden = isHidden
        style?.textfield.text = text ?? ""
        expiryDateView.update(style: style)
    }

    func updateExpiryDate(to newDate: String?){
        guard newDate?.count == dateFormatTextCount else {
            updateErrorView(isHidden: false, text: newDate)
            return
        }
        let subString = newDate?.split(separator: "/")
        guard let month = subString?.first,
              month.count == 2,
              let monthDigit = Int(month),
              let year = subString?.last,
              year.count == 2,
              let yearDigit = Int(year) else {
            updateErrorView(isHidden: false, text: newDate)
            return
        }

        switch cardValidator.validate(expiryMonth: monthDigit, expiryYear: yearDigit) {
            case .success:
                let expiryDate = ExpiryDate(month: monthDigit, year: yearDigit)
                delegate?.update(expiryDate: expiryDate)
                updateErrorView(isHidden: true, text: newDate)
            case .failure(let error):
                print(error)
                updateErrorView(isHidden: false, text: newDate)
        }
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

        /// Expiry date text format is "MM/yy"
        /// 5 is the expected text count, for example "11/35".
        guard range.location < dateFormatTextCount else {
            return false
        }

        // Hide error view on remove 
        if range.location == 4 {
            updateErrorView(isHidden: true, text: textField.text)
        }

        if range.length > 0 {
            if range.location == 3 {
               var originalText = textField.text
               originalText = originalText?.replacingOccurrences(of: "/", with: "")
               textField.text = originalText
            }
            return true
        }

        //Check for max length including added spacers which all equal to 5
        guard !string.isEmpty else { return false }

        var originalText = textField.text
        let replacementText = string.replacingOccurrences(of: " ", with: "")

        //Verify entered text is a numeric value
        for char in replacementText.unicodeScalars where !CharacterSet.decimalDigits.contains(char) { return false }

        //Put / space after 2 digit
        if range.location == 2 {
            originalText?.append("/")
            textField.text = originalText
        }

        if range.location == 4 {
            updateExpiryDate(to: (originalText ?? "") + replacementText)
            return false
        }
        return true
    }
}
