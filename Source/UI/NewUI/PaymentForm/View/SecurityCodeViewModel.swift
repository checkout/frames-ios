//
//  SecurityCodeViewModel.swift
//  
//
//  Created by Alex Ioja-Yang on 28/07/2022.
//

import Checkout

protocol SecurityCodeDelegate: AnyObject {
    func schemeChanged()
}

final class SecurityCodeViewModel {

    weak var delegate: SecurityCodeDelegate?

    private(set) var inputMaxLength: Int
    private(set) var cvv = ""
    private(set) var isInputValid = false
    private var scheme = Card.Scheme.unknown
    private let cardValidator: CardValidating

    init(cardValidator: CardValidating) {
        self.cardValidator = cardValidator
        inputMaxLength = cardValidator.maxLenghtCVV(for: .unknown)
    }

    func updateScheme(to newScheme: Card.Scheme) {
        guard newScheme != scheme else {
            return
        }
        self.scheme = newScheme
        inputMaxLength = cardValidator.maxLenghtCVV(for: newScheme)
        updateInput(to: cvv)
        delegate?.schemeChanged()
    }

    func updateInput(to newInput: String?) {
        guard let cleanedInput = newInput?.filter({ !$0.isWhitespace }),
              (Int(cleanedInput) ?? 0 > 0) || cleanedInput == "",
              cleanedInput.count <= inputMaxLength else {
            return
        }
        cvv = cleanedInput
        isInputValid = cardValidator.validate(cvv: cvv, cardScheme: scheme) == .success
    }
}
