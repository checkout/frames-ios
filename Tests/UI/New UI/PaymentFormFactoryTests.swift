//
//  PaymentFormFactoryTests.swift
//  
//
//  Copyright © 2022 Checkout. All rights reserved.
//

import XCTest
import Checkout
@testable import Frames

class PaymentFormFactoryTests: XCTestCase {
    
  override func setUp() {
    super.setUp()
        
    UIFont.loadAllCheckoutFonts
  }
    
  func testGetPaymentFormViewController() throws {
    let billingFormStyle = BillingFormFactory.defaultBillingFormStyle
    let paymentFormStyle = BillingFormFactory.defaultPaymentFormStyle
    let address = Address(addressLine1: "Test line1",
                          addressLine2: nil,
                          city: "London",
                          state: "London",
                          zip: "N12345",
                          country: Country(iso3166Alpha2: "GB"))

    let phone = Phone(number: "77 1234 1234",
                      country: Country(iso3166Alpha2: "GB"))
    let name = "User 1"

    let billingForm = BillingForm(name: name, address: address, phone: phone)

    let formConfig = PaymentFormConfiguration(apiKey: "", environment: .sandbox, supportedSchemes: [.visa], billingFormData: billingForm)
    let formStyle = PaymentStyle(paymentFormStyle: paymentFormStyle, billingFormStyle: billingFormStyle)
    let viewController = PaymentFormFactory.buildViewController(configuration: formConfig, style: formStyle) { _ in }
    let paymentViewController = try XCTUnwrap(viewController as? PaymentViewController)
    let viewModel = try XCTUnwrap(paymentViewController.viewModel)

    XCTAssertNotNil(paymentViewController.viewModel)
    XCTAssertNotNil(viewModel.billingFormData)
    XCTAssertNotNil(viewModel.billingFormStyle)
    XCTAssertNotNil(viewModel.paymentFormStyle)
    XCTAssertNotNil(viewModel.cardValidator)
    XCTAssertEqual(viewModel.supportedSchemes, formConfig.supportedSchemes)
    XCTAssertEqual(viewModel.billingFormData, billingForm)
  }

    func testLoggerCorrelationIDUpdatedOnEachFactoryUse() {
        // This will be setup by some other tests running as part of full test suite
        let startCorrelationID = PaymentFormFactory.sessionCorrelationID
        
        let formConfig = PaymentFormConfiguration(apiKey: "", environment: .sandbox, supportedSchemes: [.visa], billingFormData: nil)
        let formStyle = PaymentStyle(paymentFormStyle: BillingFormFactory.defaultPaymentFormStyle,
                                     billingFormStyle: BillingFormFactory.defaultBillingFormStyle)
        
        // Creating a VC will generate a new session correlation id
        _ = PaymentFormFactory.buildViewController(configuration: formConfig, style: formStyle) { _ in }
        
        XCTAssertNotEqual(PaymentFormFactory.sessionCorrelationID, startCorrelationID)
    }
}
