//
//  CardDetailsTableViewCell.swift
//  CheckoutCocoapodsSample
//
//  Created by Daven.Gomes on 01/12/2021.
//

import UIKit

protocol CardDetailsTableViewCellDelegate: AnyObject {
    var cardNumberDelegate: UITextFieldDelegate { get }
}

final class CardDetailsTableViewCell: UITableViewCell {
    @IBOutlet private weak var cardNumberTextField: UITextField!
    @IBOutlet private weak var expiryMonthTextField: UITextField!
    @IBOutlet private weak var expiryYearTextField: UITextField!
    @IBOutlet private weak var cvvTextField: UITextField!
    @IBOutlet private weak var expiryTextFieldStackView: UIStackView!
    @IBOutlet private weak var expiryDatePickerField: UITextField!

    private enum ExpiryDateSegment: Int {
        case text = 0
        case dropdown = 1
    }

    struct ViewModel {
        var onCardNumberChange: ((String?) -> Void)?
        var onCVVChange: ((String?) -> Void)?

        var onExpiryMonthStringChange: ((String?) -> Void)?
        var onExpiryYearStringChange: ((String?) -> Void)?

        var onExpiryIntChange: ((_ month: Int, _ year: Int) -> Void)?
    }

    var viewModel: ViewModel? {
        didSet {
            expiryDatePickerField.inputView = expirationDatePicker
            expiryDatePickerField.inputAccessoryView = datePickerToolbar
            expiryDatePickerField.delegate = noTextEntryUITextFieldHelper
        }
    }

    private let expirationDatePicker = ExpirationDatePicker()
    private let noTextEntryUITextFieldHelper = NoTextEntryUITextFieldHelper()
    private let dateFormatter = DateFormatter()

    private lazy var datePickerToolbar: UIToolbar = {
        let pickerToolbar = UIToolbar()
        pickerToolbar.autoresizingMask = .flexibleHeight

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(Self.dateEditingDone))

        // add the items to the toolbar
        pickerToolbar.items = [flexSpace, doneButton]

        return pickerToolbar
    }()

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        expirationDatePicker.viewModel = ExpirationDatePicker.ViewModel(onDateChanged: onDateChanged)
        dateFormatter.dateFormat = "MM/YYYY"
    }

    func updateTextFieldValues(cardNumber: String, month: String, year: String, cvv: String) {
        cardNumberTextField.text = cardNumber
        expiryMonthTextField.text = month
        expiryYearTextField.text = year
        cvvTextField.text = cvv
    }

    private func onDateChanged(_ month: Int, _ year: Int) {
        guard let date = date(month: month, year: year) else {
            return
        }

        expiryDatePickerField.text = dateFormatter.string(from: date)
        viewModel?.onExpiryIntChange?(month, year)
    }

    private func date(month: Int, year: Int) -> Date? {
        var dateComponents = DateComponents()

        dateComponents.month = month
        dateComponents.year = year
        dateComponents.calendar = Calendar(identifier: .gregorian)
        dateComponents.timeZone = .utc

        return dateComponents.date
    }

    weak var delegate: CardDetailsTableViewCellDelegate? {
        didSet {
            guard let delegate = delegate else {
                return
            }

            cardNumberTextField.delegate = delegate.cardNumberDelegate
        }
    }

    @IBAction private func cardNumberTextFieldEditingChanged(_ sender: Any) {
        viewModel?.onCardNumberChange?(cardNumberTextField.text)
    }

    @IBAction private func expiryMonthTextFieldEditingChanged(_ sender: Any) {
        viewModel?.onExpiryMonthStringChange?(expiryMonthTextField.text)
    }

    @IBAction private func expiryYearTextFieldEditingChanged(_ sender: Any) {
        viewModel?.onExpiryYearStringChange?(expiryYearTextField.text)
    }

    @IBAction private func cvvTextFieldEditingChanged(_ sender: Any) {
        viewModel?.onCVVChange?(cvvTextField.text)
    }

    @IBAction private func expiryTypeChanged(_ sender: UISegmentedControl) {
        guard let segment = ExpiryDateSegment(rawValue: sender.selectedSegmentIndex) else {
            return
        }

        switch segment {
            case .text:
                expiryTextFieldStackView.isHidden = false
                expiryDatePickerField.isHidden = true
            case .dropdown:
                expiryTextFieldStackView.isHidden = true
                expiryDatePickerField.isHidden = false
        }
        
        endEditing(true)
    }

    @objc private func dateEditingDone() {
        endEditing(true)
    }
}
