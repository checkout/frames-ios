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
    
    var receivedResults = [Result<Checkout.ExpiryDate, ValidationError.ExpiryDate>]()
    
    func update(result: Result<Checkout.ExpiryDate, ValidationError.ExpiryDate>) {
        receivedResults.append(result)
    }
    
}
