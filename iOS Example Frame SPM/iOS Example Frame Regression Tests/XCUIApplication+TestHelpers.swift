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

    // MARK: Static Texts
    func label(containingText string: String) -> XCUIElement {
        let predicate = NSPredicate(format: "label CONTAINS %@", string)
        return staticTexts.element(matching: predicate)
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
        text.forEach {
            keyboardInput(char: $0)
        }
    }

    func deleteCharacter(count: Int, from element: XCUIElement) {
        guard element.waitForExistence(timeout: Constants.maximumWaitForElement) else {
            return
        }
        element.tap()
        (0..<count).forEach { _ in
            if keys["delete"].exists {
                keys["delete"].tap()
            } else if keys["Delete"].exists {
                keys["Delete"].tap()
            }
        }
    }

    private func keyboardInput(char: Character, retryInputIfFailed: Bool = true) {
        var key = "\(char)"
        if key == " " {
            key = "space"
        }
        // We don't know state of keyboard but if the keyboard doesn't contain character
        //   we can try to toggle its inputs with more & shift
        //   and hope it is found
        if !keys[key].exists {
            /// Shift can be found as a key, as well as a button, depending on simulator and OS
            if buttons["shift"].exists {
                buttons["shift"].tap()
            } else if keys["Shift"].exists {
                keys["Shift"].tap()
            }
        }

        if !keys[key].exists {
            keys["more"].tap()
            keyboardInput(char: char, retryInputIfFailed: false)
            return
        }

        // A fresh simulator will display a hint on using keyboard to the user
        // If this is the first attempt at setting input we can check for it
        if retryInputIfFailed,
           staticTexts["Continue"].exists {
            staticTexts["Continue"].tap()
            keyboardInput(char: char, retryInputIfFailed: false)
            return
        }

        // If after all checks the key is still not found, we will still invoke it
        //   allowing test to fail and snapshot to be generated showing UI
        keys[key].tap()
    }
}
