//
//  CardholderViewModel.swift
//  
//
//  Created by Alex Ioja-Yang on 16/08/2022.
//

import Foundation

protocol CardholderDelegate: AnyObject {
    func cardholderUpdated(to cardholderInput: String)
}

final class CardholderViewModel {

    private enum Constants {
        static let inputAllowedCharacterSet = CharacterSet.letters.union([" ", "-", "'"])
    }

    weak var delegate: CardholderDelegate?

    func inputUpdated(to newInput: String) {
        delegate?.cardholderUpdated(to: newInput)
    }

    func isNewInputValid(_ string: String) -> Bool {
        Constants.inputAllowedCharacterSet
            .isSuperset(of: CharacterSet(charactersIn: string))
    }

}
