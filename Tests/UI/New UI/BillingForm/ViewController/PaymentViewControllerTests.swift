//
//  PaymentViewControllerTests.swift
//  
//
//  Created by Alex Ioja-Yang on 27/07/2022.
//

import XCTest
@testable import Frames
@testable import Checkout

final class PaymentViewControllerTests: XCTestCase {
    
    func testPaymentViewControllerNotSendingPaymentFormPresentedOnWrongLifecycleEvent() {
        let testLogger = StubFramesEventLogger()
        let testViewModel = DefaultPaymentViewModel(cardValidator: CardValidator(environment: .sandbox),
                                                    logger: testLogger,
                                                    billingFormData: nil,
                                                    paymentFormStyle: nil,
                                                    billingFormStyle: nil,
                                                    supportedSchemes: [])
        let testVC = PaymentViewController(viewModel: testViewModel)
        
        let expect = expectation(description: "Free up main thread in case UI work influences outcome")
        testVC.viewDidLoad()
        testVC.viewDidAppear(false)
        testVC.viewDidLayoutSubviews()
        testVC.viewWillDisappear(false)
        testVC.viewDidDisappear(false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 1)
        
        XCTAssertTrue(testLogger.addCalledWithMetadataPairs.isEmpty)
        XCTAssertTrue(testLogger.logCalledWithFramesLogEvents.isEmpty)
    }
    
    func testPaymentViewControllerSendingPaymentForPresentedOnLifecycleEvent() {
        let testLogger = StubFramesEventLogger()
        let testViewModel = DefaultPaymentViewModel(cardValidator: CardValidator(environment: .sandbox),
                                                    logger: testLogger,
                                                    billingFormData: nil,
                                                    paymentFormStyle: nil,
                                                    billingFormStyle: nil,
                                                    supportedSchemes: [])
        let testVC = PaymentViewController(viewModel: testViewModel)
        
        XCTAssertTrue(testLogger.addCalledWithMetadataPairs.isEmpty)
        XCTAssertTrue(testLogger.logCalledWithFramesLogEvents.isEmpty)
        
        testVC.viewWillAppear(false)
        
        XCTAssertTrue(testLogger.addCalledWithMetadataPairs.isEmpty)
        XCTAssertEqual(testLogger.logCalledWithFramesLogEvents.count, 1)
        XCTAssertEqual(testLogger.logCalledWithFramesLogEvents.first, .paymentFormPresented)
    }
    
}
