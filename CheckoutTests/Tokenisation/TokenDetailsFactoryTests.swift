//
//  TokenDetailsFactoryTests.swift
//  
//
//  Created by Harry Brown on 06/12/2021.
//

import XCTest
@testable import Checkout

final class TokenDetailsFactoryTests: XCTestCase {
    
    func testPropertiesMapped() {
        let testType = TokenRequest.TokenType.card
        let testToken = "12345676sdgdh"
        let testExpiresOn = "tomorrow"
        let testExpiryMonth = 6
        let testExpiryYear = 3011
        let testScheme = "visa"
        let testSchemeLocal = "mada"
        let testLast4 = "0010"
        let testBin = "424244"
        let testCardType = "Credit"
        let testCardCategory = "Consumer"
        let testIssuer = "Barclays"
        let testIssuerCountry = "GB"
        let testProductID = "A"
        let testProductType = "Visa Traditional"
        let testBillingAddress = TokenRequest.Address(
            addressLine1: "Test line1",
            addressLine2: "Test line2",
            city: "London",
            state: "London",
            zip: "N12345",
            country: "GB")
        let testPhone = TokenRequest.Phone(
            number: "7712341234",
            countryCode: "44")
        let testName = "Tester testing"
        
        let tokenResponse = TokenResponse(
            type: testType,
            token: testToken,
            expiresOn: testExpiresOn,
            expiryMonth: testExpiryMonth,
            expiryYear: testExpiryYear,
            scheme: testScheme,
            schemeLocal: testSchemeLocal,
            last4: testLast4,
            bin: testBin,
            cardType: testCardType,
            cardCategory: testCardCategory,
            issuer: testIssuer,
            issuerCountry: testIssuerCountry,
            productId: testProductID,
            productType: testProductType,
            billingAddress: testBillingAddress,
            phone: testPhone,
            name: testName)
        
        let publicToken = TokenDetailsFactory().create(tokenResponse: tokenResponse)
        XCTAssertEqual(publicToken.type, .card)
        XCTAssertEqual(publicToken.token, testToken)
        XCTAssertEqual(publicToken.expiresOn, testExpiresOn)
        XCTAssertEqual(publicToken.expiryDate, ExpiryDate(month: testExpiryMonth, year: testExpiryYear))
        XCTAssertEqual(publicToken.scheme, "visa")
        XCTAssertEqual(publicToken.schemeLocal, testSchemeLocal)
        XCTAssertEqual(publicToken.last4, testLast4)
        XCTAssertEqual(publicToken.bin, testBin)
        XCTAssertEqual(publicToken.cardType, testCardType)
        XCTAssertEqual(publicToken.cardCategory, testCardCategory)
        XCTAssertEqual(publicToken.issuer, testIssuer)
        XCTAssertEqual(publicToken.issuerCountry, testIssuerCountry)
        XCTAssertEqual(publicToken.productId, testProductID)
        XCTAssertEqual(publicToken.productType, testProductType)
        XCTAssertEqual(publicToken.name, testName)
        
        XCTAssertEqual(publicToken.phone?.countryCode, testPhone.countryCode)
        XCTAssertEqual(publicToken.phone?.number, testPhone.number)
        
        XCTAssertEqual(publicToken.billingAddress?.addressLine1, testBillingAddress.addressLine1)
        XCTAssertEqual(publicToken.billingAddress?.addressLine2, testBillingAddress.addressLine2)
        XCTAssertEqual(publicToken.billingAddress?.city, testBillingAddress.city)
        XCTAssertEqual(publicToken.billingAddress?.country?.iso3166Alpha2, testBillingAddress.country)
        XCTAssertEqual(publicToken.billingAddress?.state, testBillingAddress.state)
        XCTAssertEqual(publicToken.billingAddress?.zip, testBillingAddress.zip)
    }
}
