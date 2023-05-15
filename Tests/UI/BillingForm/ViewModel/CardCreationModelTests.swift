//
//  CardCreationModelTests.swift
//  
//
//  Created by Alex Ioja-Yang on 18/08/2022.
//

import XCTest
import Checkout
@testable import Frames

final class CardCreationModelTests: XCTestCase {
    
    func testInit() {
        let model = CardCreationModel()
        
        XCTAssertEqual(model.number, "")
        XCTAssertNil(model.expiryDate)
        XCTAssertEqual(model.name, "")
        XCTAssertEqual(model.cvv, "")
        XCTAssertNil(model.billingAddress)
        XCTAssertNil(model.phone)
        
        XCTAssertNil(model.getCard())
    }
    
    func testCreateCardWithoutNumber() {
        var model = CardCreationModel()
        model.number = ""
        model.expiryDate = ExpiryDate(month: 12, year: 2024)
        model.name = "Owner"
        model.cvv = "123"
        model.billingAddress = Address(addressLine1: "home", addressLine2: "sweet", city: "home", state: "nice", zip: "home", country: Country(iso3166Alpha2: "SG"))
        model.phone = Phone(number: "01111255632", country: Country(iso3166Alpha2: "SG"))
        
        XCTAssertNil(model.getCard())
    }
    
    func testCreateCardWithoutExpiryDate() {
        var model = CardCreationModel()
        model.number = "1234"
        model.expiryDate = nil
        model.name = "Owner"
        model.cvv = "123"
        model.billingAddress = Address(addressLine1: "home", addressLine2: "sweet", city: "home", state: "nice", zip: "home", country: Country(iso3166Alpha2: "SG"))
        model.phone = Phone(number: "01111255632", country: Country(iso3166Alpha2: "SG"))
        
        XCTAssertNil(model.getCard())
    }
    
    func testCreateCardWithoutOptionalProperties() {
        var model = CardCreationModel()
        model.number = "1234567"
        model.expiryDate = ExpiryDate(month: 12, year: 2024)
        model.name = ""
        model.cvv = ""
        model.billingAddress = nil
        model.phone = nil
        
        let card = model.getCard()
        XCTAssertNotNil(card)
        XCTAssertEqual(card?.number, model.number)
        XCTAssertEqual(card?.expiryDate, model.expiryDate)
        XCTAssertEqual(card?.name, model.name)
        XCTAssertEqual(card?.cvv, model.cvv)
        XCTAssertNil(card?.billingAddress)
        XCTAssertNil(card?.phone)
    }
    
    func testCreateCardWithAllProperties() {
        var model = CardCreationModel()
        model.number = "1234"
        model.expiryDate = ExpiryDate(month: 12, year: 2024)
        model.name = "Owner"
        model.cvv = "123"
        model.billingAddress = Address(addressLine1: "home", addressLine2: "sweet", city: "home", state: "nice", zip: "home", country: Country(iso3166Alpha2: "SG"))
        model.phone = Phone(number: "01111255632", country: Country(iso3166Alpha2: "SG"))
        
        let card = model.getCard()
        XCTAssertNotNil(card)
        XCTAssertEqual(card?.number, model.number)
        XCTAssertEqual(card?.expiryDate, model.expiryDate)
        XCTAssertEqual(card?.name, model.name)
        XCTAssertEqual(card?.cvv, model.cvv)
        XCTAssertEqual(card?.billingAddress, model.billingAddress)
        XCTAssertEqual(card?.phone, model.phone)
    }
    
    func testGetCardWithOptionalCVVInput() {
        var model = CardCreationModel(isCVVOptional: true)
        model.number = "1234"
        model.expiryDate = ExpiryDate(month: 12, year: 2077)
        
        let cardWithoutCVV = model.getCard()
        XCTAssertNotNil(cardWithoutCVV)
        XCTAssertNil(cardWithoutCVV?.cvv)
        
        model.cvv = "123"
        let cardWithCVV = model.getCard()
        XCTAssertNotNil(cardWithCVV)
        XCTAssertEqual(cardWithCVV?.cvv, "123")
        
        model.cvv = ""
        let cardWithErasedCVV = model.getCard()
        XCTAssertNotNil(cardWithErasedCVV)
        XCTAssertNil(cardWithErasedCVV?.cvv)
    }
    
    func testGetCardWithRequiredCVVInput() {
        var model = CardCreationModel(isCVVOptional: false)
        model.number = "1234"
        model.expiryDate = ExpiryDate(month: 12, year: 2077)
        
        let cardWithoutCVV = model.getCard()
        XCTAssertNotNil(cardWithoutCVV)
        XCTAssertEqual(cardWithoutCVV?.cvv, "")
        
        model.cvv = "123"
        let cardWithCVV = model.getCard()
        XCTAssertNotNil(cardWithCVV)
        XCTAssertEqual(cardWithCVV?.cvv, "123")
        
        model.cvv = ""
        let cardWithErasedCVV = model.getCard()
        XCTAssertNotNil(cardWithErasedCVV)
        XCTAssertEqual(cardWithErasedCVV?.cvv, "")
    }
}
