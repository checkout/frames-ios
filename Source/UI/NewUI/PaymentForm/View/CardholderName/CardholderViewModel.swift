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

    weak var delegate: CardholderDelegate?

    func inputUpdated(to newInput: String) {
        delegate?.cardholderUpdated(to: newInput)
    }
}
