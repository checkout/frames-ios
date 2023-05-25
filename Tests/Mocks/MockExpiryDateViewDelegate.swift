//
//  MockExpiryDateViewDelegate.swift
//  
//
//  Created by Alex Ioja-Yang on 17/05/2023.
//

import Foundation
import Checkout
@testable import Frames

final class MockExpiryDateViewDelegate: ExpiryDateViewDelegate {
    
    var receivedResults = [Result<Checkout.ExpiryDate, Frames.ExpiryDateError>]()
    
    func update(result: Result<Checkout.ExpiryDate, Frames.ExpiryDateError>) {
        receivedResults.append(result)
    }
    
}
