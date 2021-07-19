import XCTest

@testable import Frames

final class CheckoutAPIClientIntegrationTests: XCTestCase {

    private var subject: CheckoutAPIClient!

    // MARK: - setUp

    override func setUp() {

        super.setUp()

        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [StubURLProtocol.self]

        let session = URLSession(configuration: configuration)

        subject = CheckoutAPIClient(
            publicKey: "pk_test_6ff46046-30af-41d9-bf58-929022d2cd14",
            environment: .live,
            session: session)
    }

    // MARK: - tearDown

    override func tearDown() {

        subject = nil

        StubURLProtocol.responseData = [:]

        super.tearDown()
    }

    // MARK: - getCardProviders

    func test_getCardProviders_validResponse_successHandlerCalledWithCorrectValue() throws {

        let data = try XCTUnwrap(load(resource: "cardProviders", withExtension: "json"))
        let url = URL(staticString: "https://api2.checkout.com/v2/providers/cards")
        StubURLProtocol.responseData[url] = data

        let expectation = XCTestExpectation(description: "Recieve card providers")
        let expectedCardProviders = [
            CardProvider(id: "cp_1", name: "VISA"),
            CardProvider(id: "cp_2", name: "MASTERCARD"),
            CardProvider(id: "cp_3", name: "AMEX"),
            CardProvider(id: "cp_4", name: "DISCOVER"),
            CardProvider(id: "cp_5", name: "DINERSCLUB"),
            CardProvider(id: "cp_6", name: "JCB")
        ]

        subject.getCardProviders { actualCardProviders in

            XCTAssertEqual(expectedCardProviders, actualCardProviders)
            expectation.fulfill()

        } errorHandler: { error in

            XCTFail(error.localizedDescription)
        }

        wait(for: [expectation], timeout: 1.0)
    }

    // MARK: - createCardToken

    func test_createCardToken_successfulResponse_completionCalledWithCorrectValue() throws {

        let data = try XCTUnwrap(load(resource: "cardToken", withExtension: "json"))
        let url = URL(staticString: "https://api.checkout.com/tokens")
        StubURLProtocol.responseData[url] = data

        let expectation = XCTestExpectation(description: "Recieve card token")
        let expectedCardTokenResponse = CkoCardTokenResponse(
            type: "card",
            token: "tok_76km7r4p7woezcod36qki37iiu",
            expiresOn: "2018-06-01T14:35:09Z",
            expiryMonth: 6,
            expiryYear: 2020,
            name: "",
            scheme: "Visa",
            last4: "4242",
            bin: "424242",
            cardType: "Credit",
            cardCategory: "Consumer",
            issuer: "GOTHAM STATE BANK",
            issuerCountry: "US",
            productID: "A",
            productType: "Visa Traditional",
            billingAddress: nil,
            phone: nil)

        let card = CkoCardTokenRequest(number: "", expiryMonth: "", expiryYear: "", cvv: "")
        subject.createCardToken(card: card) { result in

            switch result {
            case let .success(actualCardTokenResponse):
                XCTAssertEqual(expectedCardTokenResponse, actualCardTokenResponse)

            case let .failure(error):
                XCTFail(error.localizedDescription)
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func test_createCardToken_successfulResponseWithBillingDetails_completionCalledWithCorrectValue() throws {

        let data = try XCTUnwrap(load(resource: "cardTokenBillingDetails", withExtension: "json"))
        let url = URL(staticString: "https://api.checkout.com/tokens")
        StubURLProtocol.responseData[url] = data

        let expectation = XCTestExpectation(description: "Recieve card token")
        let expectedCardTokenResponse = CkoCardTokenResponse(
            type: "card",
            token: "tok_76km7r4p7woezcod36qki37iiu",
            expiresOn: "2018-06-01T14:35:09Z",
            expiryMonth: 6,
            expiryYear: 2020,
            name: "",
            scheme: "Visa",
            last4: "4242",
            bin: "424242",
            cardType: "Credit",
            cardCategory: "Consumer",
            issuer: "GOTHAM STATE BANK",
            issuerCountry: "US",
            productID: "A",
            productType: "Visa Traditional",
            billingAddress: CkoAddress(
                addressLine1: "Test Line1",
                addressLine2: "Test Line2",
                city: "London",
                state: "London",
                zip: "N1 7LH",
                country: "GB"),
            phone: CkoPhoneNumber(
                countryCode: "+44",
                number: "7456354812"))

        let card = CkoCardTokenRequest(number: "", expiryMonth: "", expiryYear: "", cvv: "")
        subject.createCardToken(card: card) { result in

            switch result {
            case let .success(actualCardTokenResponse):
                XCTAssertEqual(expectedCardTokenResponse, actualCardTokenResponse)

            case let .failure(error):
                XCTFail(error.localizedDescription)
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func test_createCardToken_errorResponse_completionCalledWithCorrectValue() throws {

        let data = try XCTUnwrap(load(resource: "cardTokenInvalidNumber", withExtension: "json"))
        let url = URL(staticString: "https://api.checkout.com/tokens")
        StubURLProtocol.responseData[url] = data

        let expectation = XCTestExpectation(description: "Recieve card token")
        let expectedError = NetworkError.checkout(
            requestId: "3c3ad5a5-d513-44c9-92ae-f8d9b3557567",
            errorType: "request_invalid",
            errorCodes: ["card_number_invalid"])

        let card = CkoCardTokenRequest(number: "", expiryMonth: "", expiryYear: "", cvv: "")
        subject.createCardToken(card: card) { result in

            switch result {
            case .success:
                XCTFail("Expected failure result")

            case let .failure(actualError):
                XCTAssertEqual(expectedError, actualError)
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    // MARK: - createApplePayToken

    func test_createApplePayToken_successfulResponse_completionCalledWithCorrectValue() throws {

        let data = try XCTUnwrap(load(resource: "applePayToken", withExtension: "json"))
        let url = URL(staticString: "https://api.checkout.com/tokens")
        StubURLProtocol.responseData[url] = data

        let expectation = XCTestExpectation(description: "Recieve Apple Pay token")
        let expectedCardTokenResponse = CkoCardTokenResponse(
            type: "applepay",
            token: "tok_ymu4qlccztkedmd6b7c3hcf6ae",
            expiresOn: "2019-10-21T10:48:35Z",
            expiryMonth: 8,
            expiryYear: 2023,
            name: nil,
            scheme: "Visa",
            last4: "6222",
            bin: "481891",
            cardType: "Debit",
            cardCategory: "Consumer",
            issuer: "HSBC BANK PLC",
            issuerCountry: "GB",
            productID: "F",
            productType: "Visa Classic",
            billingAddress: nil,
            phone: nil)

        let paymentData = Data()
        subject.createApplePayToken(paymentData: paymentData) { result in

            switch result {
            case let .success(actualCardTokenResponse):
                XCTAssertEqual(expectedCardTokenResponse, actualCardTokenResponse)

            case let .failure(error):
                XCTFail(error.localizedDescription)
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func test_createApplePayToken_errorResponse_completionCalledWithCorrectValue() throws {

        let data = try XCTUnwrap(load(resource: "applePayTokenInvalid", withExtension: "json"))
        let url = URL(staticString: "https://api.checkout.com/tokens")
        StubURLProtocol.responseData[url] = data

        let expectation = XCTestExpectation(description: "Recieve card token")
        let expectedError = NetworkError.checkout(
            requestId: "0HL80RJLS76I7",
            errorType: "request_invalid",
            errorCodes: ["payment_source_required"])

        let paymentData = Data()
        subject.createApplePayToken(paymentData: paymentData) { result in

            switch result {
            case .success:
                XCTFail("Expected failure result")

            case let .failure(actualError):
                XCTAssertEqual(expectedError, actualError)
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    // MARK: - Private

    private func load(resource: String, withExtension ext: String) throws -> Data? {

        #if SWIFT_PACKAGE
        let bundle = Bundle.module
        #else
        let bundle = Bundle(for: type(of: self))
        #endif

        guard let url = bundle.url(forResource: resource, withExtension: ext) else { return nil }
        return try Data(contentsOf: url)
    }

}
