//
//  XCUIElement+TestHelpers.swift
//  iOS Example Frame Regression Tests
//
//  Created by Okhan Okbay on 19/07/2023.
//  Copyright © 2023 Checkout. All rights reserved.
//

import XCTest

extension XCUIElement {
    
    func contains(text: String) -> Bool {
        let predicate = NSPredicate(format: "label CONTAINS[c] %@", text)
        let elementQuery = staticTexts.containing(predicate)
        return elementQuery.count > 0
    }
}
