//
//  XCUIApplication+Extension.swift
//  iOS Example FrameUITests
//
//  Created by Alex Ioja-Yang on 24/08/2022.
//  Copyright © 2022 Checkout. All rights reserved.
//

import XCTest

extension XCUIApplication {

    private enum Constants {
        static let maximumWaitForElement = 10.0
    }

    // MARK: Buttons
    func tapButton(name: String) {
        let predicate = NSPredicate(format: "identifier LIKE %@", name)
        let button = buttons.element(matching: predicate)
        button.tap()
    }

    func getButton(name: String) -> XCUIElement {
        let predicate = NSPredicate(format: "identifier LIKE %@", name)
        return buttons.element(matching: predicate)
    }

    // MARK: Text input
    func enterText(_ text: String, into element: XCUIElement) {
        guard element.waitForExistence(timeout: Constants.maximumWaitForElement) else {
            return
        }
        element.tap()
        text.forEach { keys["\($0)"].tap() }
    }

    func deleteCharacter(count: Int, from element: XCUIElement) {
        guard element.waitForExistence(timeout: Constants.maximumWaitForElement) else {
            return
        }
        element.tap()
        (0..<count).forEach { _ in keys["Delete"].tap() }
    }
}
