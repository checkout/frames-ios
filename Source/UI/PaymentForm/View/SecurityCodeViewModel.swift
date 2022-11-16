//
//  SecurityCodeViewModel.swift
//  
//
//  Created by Alex Ioja-Yang on 28/07/2022.
//

import Checkout

protocol SecurityCodeViewModelDelegate: AnyObject {
    func schemeChanged()
}

final class SecurityCodeViewModel {

    weak var delegate: SecurityCodeViewModelDelegate?

    private(set) var inputMaxLength: Int
    private(set) var cvv = ""
    private(set) var isInputValid = false
    private var scheme = Card.Scheme.unknown
    private let cardValidator: CardValidating

    init(cardValidator: CardValidating) {
        self.cardValidator = cardValidator
        inputMaxLength = cardValidator.maxLengthCVV(for: .unknown)
    }

    func updateScheme(to newScheme: Card.Scheme) {
        guard newScheme != scheme else {
            return
        }
        self.scheme = newScheme
        inputMaxLength = cardValidator.maxLengthCVV(for: newScheme)
        updateInput(to: cvv)
        delegate?.schemeChanged()
    }

    func updateInput(to newInput: String?) {
        defer {
            isInputValid = cardValidator.validate(cvv: cvv, cardScheme: scheme) == .success
        }

        guard let cleanedInput = newInput?.decimalDigits,
              cleanedInput.count <= inputMaxLength else {
            return
        }
        cvv = cleanedInput
    }
}
