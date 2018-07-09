import XCTest
@testable import FramesIos

import Mockingjay

class CheckoutAPIClientTests: XCTestCase {

    let checkoutAPIClient: CheckoutAPIClient = CheckoutAPIClient(
        publicKey: "pk_test_6ff46046-30af-41d9-bf58-929022d2cd14",
        environment: .sandbox)

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSuccessfulGetCardProviders() {
        // Stub the response
        let path = Bundle(for: type(of: self)).path(forResource: "cardProviders", ofType: "json")!
        let data = NSData(contentsOfFile: path)!
        stub(everything, delay: 0, jsonData(data as Data))
        // Test the function
        let expectation = XCTestExpectation(description: "Get card providers")
        checkoutAPIClient.getCardProviders(successHandler: { cardProviders in
            XCTAssertNotNil(cardProviders)
            expectation.fulfill()
        }, errorHandler: { _ in
        })

        wait(for: [expectation], timeout: 1.0)
    }

    func testFailedGetCardProviders() {
    }

    func testSuccessfulCreateCardToken() {
        // Stub the response
        let path = Bundle(for: type(of: self)).path(forResource: "cardToken", ofType: "json")!
        let data = NSData(contentsOfFile: path)!
        stub(everything, delay: 0, jsonData(data as Data))
        // Test the function
        let expectation = XCTestExpectation(description: "Create card token")
        let cardRequest = CardTokenRequest(number: "", expiryMonth: 0, expiryYear: 0, cvv: "")

        checkoutAPIClient.createCardToken(card: cardRequest, successHandler: { cardToken in
            XCTAssertNotNil(cardToken)
            XCTAssertNotNil(cardToken.token)
            expectation.fulfill()
        }, errorHandler: { _ in
        })

        wait(for: [expectation], timeout: 1.0)
    }

    func testFailedCreateCardToken() {
        // Stub the response
        let path = Bundle(for: type(of: self)).path(forResource: "cardTokenInvalidNumber", ofType: "json")!
        let data = NSData(contentsOfFile: path)!
        stub(everything, delay: 0, jsonData(data as Data, status: 401))
        // Test the function
        let expectation = XCTestExpectation(description: "Create card token (error)")
        let cardRequest = CardTokenRequest(number: "", expiryMonth: 0, expiryYear: 0, cvv: "")
        checkoutAPIClient.createCardToken(card: cardRequest, successHandler: { _ in
        }, errorHandler: { error in
            XCTAssertNotNil(error)
            XCTAssertEqual(error.errorCode, "70000")
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 1.0)
    }

    func testSuccessfulCreateCkoCardToken() {
        // Stub the response
        let path = Bundle(for: type(of: self)).path(forResource: "ckoCardToken", ofType: "json")!
        let data = NSData(contentsOfFile: path)!
        stub(everything, delay: 0, jsonData(data as Data))
        // Test the function
        let expectation = XCTestExpectation(description: "Create card token")
        let cardRequest = CkoCardTokenRequest(number: "", expiryMonth: "", expiryYear: "",
                                              cvv: "", name: nil, billingAddress: nil)

        checkoutAPIClient.createCardToken(card: cardRequest, successHandler: { cardToken in
            XCTAssertNotNil(cardToken)
            XCTAssertNotNil(cardToken.id)
            expectation.fulfill()
        }, errorHandler: { _ in
        })

        wait(for: [expectation], timeout: 1.0)
    }

    func testFailedCreateCkoCardToken() {
        // Stub the response
        let path = Bundle(for: type(of: self)).path(forResource: "cardTokenInvalidNumber", ofType: "json")!
        let data = NSData(contentsOfFile: path)!
        stub(everything, delay: 0, jsonData(data as Data, status: 401))
        // Test the function
        let expectation = XCTestExpectation(description: "Create card token (error)")
        let cardRequest = CkoCardTokenRequest(number: "", expiryMonth: "", expiryYear: "", cvv: "",
                                              name: nil, billingAddress: nil)
        checkoutAPIClient.createCardToken(card: cardRequest, successHandler: { _ in
        }, errorHandler: { error in
            XCTAssertNotNil(error)
            XCTAssertEqual(error.errorCode, "70000")
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 1.0)
    }

    func testSuccessfulCreateApplePayToken() {
        // Stub the response
        let path = Bundle(for: type(of: self)).path(forResource: "applePayToken", ofType: "json")!
        let data = NSData(contentsOfFile: path)!
        stub(everything, delay: 0, jsonData(data as Data))
        // Test the function
        let expectation = XCTestExpectation(description: "create apple pay token")
        let applePayData = Data()
        checkoutAPIClient.createApplePayToken(paymentData: applePayData, successHandler: { applePayToken in
            XCTAssertNotNil(applePayToken)
            XCTAssertNotNil(applePayToken.token)
            XCTAssertNotNil(applePayToken.expiresOn)
            expectation.fulfill()
        }, errorHandler: { _ in
        })

        wait(for: [expectation], timeout: 1.0)
    }

}
