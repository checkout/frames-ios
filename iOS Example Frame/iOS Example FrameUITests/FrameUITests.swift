//
//  FrameUITests.swift
//  iOS Example Frame
//
//  Created by Alex Ioja-Yang on 22/08/2022.
//  Copyright © 2022 Checkout. All rights reserved.
//

import XCTest

// swiftlint:disable:file line_length
// swiftlint:disable:file function_body_length
// swiftlint:disable:file multiline_function_chains

final class FrameUITests: XCTestCase {

    func testPaymentWithMinimumInput() {
        let app = XCUIApplication()
        app.launch()

        app.tapButton(name: "UITestDefault")

        var cardNumberTextField = app.scrollViews
            .children(matching: .other).element(boundBy: 0)
            .children(matching: .other).element(boundBy: 2)
            .children(matching: .other).element
            .children(matching: .other).element(boundBy: 2)
            .children(matching: .other).element(boundBy: 1)
            .children(matching: .other).element

        var expiryTextField = app.scrollViews
            .children(matching: .other).element(boundBy: 0)
            .children(matching: .other).element(boundBy: 3)
            .children(matching: .other).element
            .children(matching: .other).element(boundBy: 2)
            .children(matching: .other).element
            .children(matching: .other).element

        let payButton = app.getButton(name: "Pay now")
        XCTAssertFalse(payButton.isEnabled)

        // 1. Enter complete valid card number
        app.enterText("4242424242424242", into: cardNumberTextField)
        app.staticTexts["Card number"].tap()
        XCTAssertFalse(payButton.isEnabled)

        // 2. Enter complete valid expiry date
        app.enterText("1288", into: expiryTextField)
        app.staticTexts["Expiry date"].tap()
        XCTAssertTrue(payButton.isEnabled)

        // 3. Make card number too short to be valid
        app.deleteCharacter(count: 1, from: cardNumberTextField)
        app.staticTexts["Card number"].tap()
        XCTAssertFalse(payButton.isEnabled)

        // bound is changed after showing error message
        cardNumberTextField = app.scrollViews
            .children(matching: .other).element(boundBy: 0)
            .children(matching: .other).element(boundBy: 2)
            .children(matching: .other).element
            .children(matching: .other).element(boundBy: 1)
            .children(matching: .other).element(boundBy: 1)
            .children(matching: .other).element

        // 4. Make card number too long to be valid
        app.enterText("25", into: cardNumberTextField)
        app.staticTexts["Card number"].tap()
        XCTAssertFalse(payButton.isEnabled)

        // 5. Make card number valid again
        app.deleteCharacter(count: 1, from: cardNumberTextField)
        app.staticTexts["Card number"].tap()
        XCTAssertTrue(payButton.isEnabled)

        // 6. Make expiry date too short to be valid
        app.deleteCharacter(count: 2, from: expiryTextField)
        app.staticTexts["Expiry date"].tap()
        XCTAssertFalse(payButton.isEnabled)

        // bound is changed after showing error message
        expiryTextField = app.scrollViews
            .children(matching: .other).element(boundBy: 0)
            .children(matching: .other).element(boundBy: 3)
            .children(matching: .other).element
            .children(matching: .other).element(boundBy: 1)
            .children(matching: .other).element
            .children(matching: .other).element

        // 7. Input previous year on expiry date
        app.enterText("01", into: expiryTextField)
        app.staticTexts["Expiry date"].tap()
        XCTAssertFalse(payButton.isEnabled)

        // 8. Input excess numbers on expiry date
        app.deleteCharacter(count: 6, from: expiryTextField)

        // bound is changed after hiding error message
        expiryTextField = app.scrollViews
            .children(matching: .other).element(boundBy: 0)
            .children(matching: .other).element(boundBy: 3)
            .children(matching: .other).element
            .children(matching: .other).element(boundBy: 2)
            .children(matching: .other).element
            .children(matching: .other).element

        app.enterText("1288", into: expiryTextField)
        app.staticTexts["Expiry date"].tap()
        XCTAssertTrue(payButton.isEnabled)

        // 9. Press button
        payButton.tap()
        let alert = app.alerts["Card Validation Error"]
        XCTAssertNotNil(alert)
        XCTAssertEqual(alert.label, "Card Validation Error")
    }

    func testPaymentWithFullInputProvided() {

        let app = XCUIApplication()
        app.launchArguments = ["-AppleLanguages", "(en)"]
        app.launch()

        app.tapButton(name: "UITestTheme1")

        // MARK: Full UI Payment
        let cardholderTextField = app.scrollViews
            .children(matching: .other).element(boundBy: 0)
            .children(matching: .other).element(boundBy: 2)
            .children(matching: .other).element
            .children(matching: .other).element(boundBy: 1)
            .children(matching: .other).element
            .children(matching: .other).element

        let cardNumberTextField = app.scrollViews
            .children(matching: .other).element(boundBy: 0)
            .children(matching: .other).element(boundBy: 3)
            .children(matching: .other).element
            .children(matching: .other).element(boundBy: 2)
            .children(matching: .other).element(boundBy: 1)
            .children(matching: .other).element

        let expiryTextField = app.scrollViews
            .children(matching: .other).element(boundBy: 0)
            .children(matching: .other).element(boundBy: 4)
            .children(matching: .other).element
            .children(matching: .other).element(boundBy: 2)
            .children(matching: .other).element
            .children(matching: .other).element

        let securityCodeTextField = app.scrollViews
            .children(matching: .other).element(boundBy: 0)
            .children(matching: .other).element(boundBy: 5)
            .children(matching: .other).element
            .children(matching: .other).element(boundBy: 2)
            .children(matching: .other).element
            .children(matching: .other).element

        let billingButton = app.getButton(name: "Add billing details")
        XCTAssertTrue(billingButton.isEnabled)

        let payButton = app.getButton(name: "Pay now")
        XCTAssertFalse(payButton.isEnabled)

        // 1. Enter complete valid card number
        app.enterText("4242424242424242", into: cardNumberTextField)
        app.staticTexts["Card number"].tap()
        XCTAssertFalse(payButton.isEnabled)

        // 2. Enter complete valid expiry date
        app.enterText("1288", into: expiryTextField)
        app.staticTexts["Expiry date"].tap()
        XCTAssertFalse(payButton.isEnabled)

        // 3. Enter valid security code
        app.enterText("123", into: securityCodeTextField)
        app.staticTexts["Security number"].tap()
        XCTAssertFalse(payButton.isEnabled)

        // 4. Enter cardholder name
        app.enterText("John Doe", into: cardholderTextField)
        app.staticTexts["Cardholder"].tap()
        XCTAssertTrue(payButton.isEnabled)

        // 5. Open billing
        billingButton.tap()

        // MARK: Full UI Billing

        let cancelButton = app.navigationBars.buttons.matching(identifier: "Cancel").element
        let doneButton = app.navigationBars.buttons.matching(identifier: "Done").element
        let addressLine1TextField = app.tables
            .cells.containing(.staticText, identifier: "Address line 1")
            .children(matching: .textField).element
        let addressLine2TextField = app.tables
            .cells.containing(.staticText, identifier: "Address line 2")
            .children(matching: .textField).element
        let cityTextField = app.tables
            .cells.containing(.staticText, identifier: "City")
            .children(matching: .textField).element
        let postcodeTextField = app.tables
            .cells.containing(.staticText, identifier: "Postcode")
            .children(matching: .textField).element
        let countryButton = app.tables.staticTexts["Select country"]
        let phoneTextField = app.tables
            .cells.containing(.staticText, identifier: "Phone number")
            .children(matching: .textField).element

        XCTAssertFalse(doneButton.isEnabled)
        XCTAssertTrue(cancelButton.isEnabled)

        // Compulsory elements ⬇️

        // 6. Enter Address
        let addressLine1 = "Famous Avenue, 14"
        app.enterText(addressLine1, into: addressLine1TextField)
        app.staticTexts["Address line 1"].tap()
        XCTAssertFalse(doneButton.isEnabled)

        // 7. Enter City
        let city = "Zlimont"
        app.enterText(city, into: cityTextField)
        app.staticTexts["City"].tap()
        XCTAssertFalse(doneButton.isEnabled)

        // 8. Select country
        let country = "Antarctica"
        XCTAssertFalse(app.staticTexts[country].exists)
        countryButton.tap()
        app.tables.staticTexts[country].tap()
        XCTAssertTrue(doneButton.isEnabled)
        XCTAssertTrue(app.staticTexts[country].exists)

        // Optional elements ⬇️

        // 9. Enter Address Line 2
        let addressLine2 = "Not Bad Neighbourhood"
        app.enterText(addressLine2, into: addressLine2TextField)
        app.staticTexts["Address line 2"].tap()
        XCTAssertTrue(doneButton.isEnabled)

        // 12. Enter postcode
        let postcode = "CZ34 9JK"
        app.enterText(postcode, into: postcodeTextField)
        app.staticTexts["Postcode"].tap()
        XCTAssertTrue(doneButton.isEnabled)

        // 11. Enter phone number
        let phoneNumber = "+441206123123"
        app.enterText(phoneNumber, into: phoneTextField)
        app.staticTexts["Phone number"].tap()
        XCTAssertTrue(doneButton.isEnabled)

        // 12. Confirm Billing input and return to Payment form
        doneButton.tap()

        // MARK: Complete Payment + Billing input
        // 13. Validate Billing input previously entered is now displayed
        XCTAssertTrue(app.label(containingText: addressLine1).exists)
        XCTAssertTrue(app.label(containingText: addressLine2).exists)
        XCTAssertTrue(app.label(containingText: postcode).exists)
        XCTAssertTrue(app.label(containingText: city).exists)
        XCTAssertTrue(app.label(containingText: country).exists)
        XCTAssertTrue(app.label(containingText: "+44 1206 123123").exists)
        XCTAssertTrue(payButton.isEnabled)

        // 14. Press Pay Button
        payButton.tap()
        let alert = app.alerts["Success"]
        XCTAssertNotNil(alert)
        XCTAssertEqual(alert.label, "Success")
    }

 }
