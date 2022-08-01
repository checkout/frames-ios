//
//  MockSecurityCodeDelegate.swift
//  
//
//  Created by Alex Ioja-Yang on 28/07/2022.
//

@testable import Frames
import XCTest

class MockSecurityCodeDelegate: SecurityCodeViewModelDelegate {
    
    var schemeChangedCompletion = { XCTFail("Not setup to happen") }
    
    func schemeChanged() {
        schemeChangedCompletion()
    }
}
