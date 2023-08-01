//
//  ExpiryDateFormatter.swift
//
//
//  Created by Alex Ioja-Yang on 16/05/2023.
//
import Foundation
import Checkout

struct ExpiryDateFormatter {

    let separator: String
    let dateFormatTextCount: Int
    private let cardValidator: CardValidating

    init(componentSeparator: String = "/",
         cardValidator: CardValidating = CardValidator(environment: .sandbox)) {
        self.separator = componentSeparator
        // The expected full input will be of format MM{separator}YY
        // Which leads to our text could being a sum of MM (2 characters), YY (2 characters) and Separator length
        self.dateFormatTextCount = 2 + componentSeparator.count + 2
        self.cardValidator = cardValidator
    }

    func createCardExpiry(from input: String) -> Result<ExpiryDate, ValidationError.ExpiryDate> {
        let components = getComponents(from: input)
        guard let month = components.month else {
            return .failure(.invalidMonth)
        }

        guard let year = components.year else {
            return .failure(.invalidYear)
        }

        let validationOutcome = cardValidator.validate(expiryMonth: month, expiryYear: year)
        switch validationOutcome {
        case .success(let expiryDate):
            return .success(expiryDate)
        case .failure(let error):
            return .failure(error)
        }
    }

    /// Propose a display formatted expiry date that may be shown to the user
    /// If the cardScheme is `unknown`, this validates that the cvv is conforming to internal generic standards
    /// - Parameters:
    ///   - input: The input as received from the user facing UI component
    /// - Returns: A formatted input for displaying to the user and nil if presented input is not valid.
    /// If displayString is nil, the text in the UI component should be rejected at last valid input should be maintained!
    func formatForDisplay(input: String) -> String? {
        guard input.count <= dateFormatTextCount else {
            return nil
        }
        let (month, year) = getComponents(from: input)

        guard let month else {
            return nil
        }
        var displayString = ""
        if month.count == 1 {
            displayString = month
        } else {
            displayString = month + separator
        }

        guard let year,
              let yearInt = Int(year) else {
            return displayString
        }

        displayString += year
        let currentYear = Calendar(identifier: .gregorian).component(.year, from: Date())
        let currentYearLast2Digits = currentYear % 100

        if year.count == 1 {
            let currentDecade = Int(currentYearLast2Digits / 10)
            if yearInt < currentDecade {
                return displayString
            } else {
                return displayString
            }
        }
        if yearInt < currentYearLast2Digits {
            return displayString
        } else {
            return displayString
        }
    }

    private func getComponents(from string: String) -> (month: String?, year: String?) {
        let components = string.components(separatedBy: separator)
            .map {
                $0.filter(\.isWholeNumber)
            }
        if components.isEmpty || components.count > 2 {
            return (nil, nil)
        }
        var finalMonth = ""
        if let month = components.first,
           let monthInt = Int(month) {
            if monthInt > 12 {
                return (nil, nil)
            } else if month.count == 2 {
                finalMonth = month
            } else if monthInt > 1 && monthInt < 10 {
                finalMonth = "0\(monthInt)"
            } else {
                return (month, nil)
            }
        } else {
            return (nil, nil)
        }
        guard components.count == 2,
              let year = components.last?.suffix(2) else {
            return (finalMonth, nil)
        }
        return (finalMonth, String(year))
    }
}
