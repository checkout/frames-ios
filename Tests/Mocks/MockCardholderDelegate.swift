//
//  MockCardholderDelegate.swift
//  
//
//  Created by Alex Ioja-Yang on 18/08/2022.
//

import Foundation
@testable import Frames

final class MockCardholderDelegate: CardholderDelegate {
    
    var cardholderUpdatedReceivedArguments: [String] = []
    var cardhodlerUpdatedCompletion: (() -> Void)?
    
    func cardholderUpdated(to cardholderInput: String) {
        cardholderUpdatedReceivedArguments.append(cardholderInput)
        cardhodlerUpdatedCompletion?()
    }
    
}
