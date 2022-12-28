//
//  BillingFormStyleTests.swift
//  
//
//  Created by Alex Ioja-Yang on 28/12/2022.
//

import XCTest
@testable import Frames

final class BillingFormStyleTests: XCTestCase {
    
    // MARK: Test with different cell configurations
    func testSummaryFromNoCells() {
        var style = DefaultBillingFormStyle()
        style.cells = []
        
        let testBillingForm = BillingForm(name: "John",
                                          address: Address(addressLine1: "Kong Drive",
                                                           addressLine2: "Blister",
                                                           city: "Dreamland",
                                                           state: "Brilliant place",
                                                           zip: "DR38ML",
                                                           country: Country.allAvailable.first),
                                          phone: nil)
        let summary = style.summaryFrom(form: testBillingForm)
        XCTAssertTrue(summary.isEmpty)
    }
    
    func testSummaryOnlyFullNameCell() {
        var style = DefaultBillingFormStyle()
        style.cells = [.fullName(DefaultBillingFormFullNameCellStyle())]
        let testBillingForm = BillingForm(name: "John",
                                          address: Address(addressLine1: "Kong Drive",
                                                           addressLine2: "Blister",
                                                           city: "Dreamland",
                                                           state: "Brilliant place",
                                                           zip: "DR38ML",
                                                           country: Country.allAvailable.first),
                                          phone: Phone(number: "123456", country: Country.allAvailable.last))
        let summary = style.summaryFrom(form: testBillingForm)
        
        let expectedSummary = "John"
        XCTAssertEqual(summary, expectedSummary)
    }
    
    func testSummaryOnlyAddressLine1Cell() {
        var style = DefaultBillingFormStyle()
        style.cells = [.addressLine1(DefaultBillingFormAddressLine1CellStyle())]
        let testBillingForm = BillingForm(name: "John",
                                          address: Address(addressLine1: "Kong Drive",
                                                           addressLine2: "Blister",
                                                           city: "Dreamland",
                                                           state: "Brilliant place",
                                                           zip: "DR38ML",
                                                           country: Country.allAvailable.first),
                                          phone: Phone(number: "123456", country: Country.allAvailable.last))
        let summary = style.summaryFrom(form: testBillingForm)
        
        let expectedSummary = "Kong Drive"
        XCTAssertEqual(summary, expectedSummary)
    }
    
    func testSummaryOnlyAddressLine2Cell() {
        var style = DefaultBillingFormStyle()
        style.cells = [.addressLine2(DefaultBillingFormAddressLine2CellStyle())]
        let testBillingForm = BillingForm(name: "John",
                                          address: Address(addressLine1: "Kong Drive",
                                                           addressLine2: "Blister",
                                                           city: "Dreamland",
                                                           state: "Brilliant place",
                                                           zip: "DR38ML",
                                                           country: Country.allAvailable.first),
                                          phone: Phone(number: "123456", country: Country.allAvailable.last))
        let summary = style.summaryFrom(form: testBillingForm)
        
        let expectedSummary = "Blister"
        XCTAssertEqual(summary, expectedSummary)
    }
    
    func testSummaryOnlyCityCell() {
        var style = DefaultBillingFormStyle()
        style.cells = [.city(DefaultBillingFormCityCellStyle())]
        let testBillingForm = BillingForm(name: "John",
                                          address: Address(addressLine1: "Kong Drive",
                                                           addressLine2: "Blister",
                                                           city: "Dreamland",
                                                           state: "Brilliant place",
                                                           zip: "DR38ML",
                                                           country: Country.allAvailable.first),
                                          phone: Phone(number: "123456", country: Country.allAvailable.last))
        let summary = style.summaryFrom(form: testBillingForm)
        
        let expectedSummary = "Dreamland"
        XCTAssertEqual(summary, expectedSummary)
    }
    
    func testSummaryOnlyStateCell() {
        var style = DefaultBillingFormStyle()
        style.cells = [.state(DefaultBillingFormStateCellStyle())]
        let testBillingForm = BillingForm(name: "John",
                                          address: Address(addressLine1: "Kong Drive",
                                                           addressLine2: "Blister",
                                                           city: "Dreamland",
                                                           state: "Brilliant place",
                                                           zip: "DR38ML",
                                                           country: Country.allAvailable.first),
                                          phone: Phone(number: "123456", country: Country.allAvailable.last))
        let summary = style.summaryFrom(form: testBillingForm)
        
        let expectedSummary = "Brilliant place"
        XCTAssertEqual(summary, expectedSummary)
    }
    
    func testSummaryOnlyPostcodeCell() {
        var style = DefaultBillingFormStyle()
        style.cells = [.postcode(DefaultBillingFormPostcodeCellStyle())]
        let testBillingForm = BillingForm(name: "John",
                                          address: Address(addressLine1: "Kong Drive",
                                                           addressLine2: "Blister",
                                                           city: "Dreamland",
                                                           state: "Brilliant place",
                                                           zip: "DR38ML",
                                                           country: Country.allAvailable.first),
                                          phone: Phone(number: "123456", country: Country.allAvailable.last))
        let summary = style.summaryFrom(form: testBillingForm)
        
        let expectedSummary = "DR38ML"
        XCTAssertEqual(summary, expectedSummary)
    }
    
    func testSummaryOnlyCountryCell() {
        var style = DefaultBillingFormStyle()
        style.cells = [.country(DefaultBillingFormCountryCellStyle())]
        let testBillingForm = BillingForm(name: "John",
                                          address: Address(addressLine1: "Kong Drive",
                                                           addressLine2: "Blister",
                                                           city: "Dreamland",
                                                           state: "Brilliant place",
                                                           zip: "DR38ML",
                                                           country: Country.allAvailable.first),
                                          phone: Phone(number: "123456", country: Country.allAvailable.last))
        let summary = style.summaryFrom(form: testBillingForm)
        
        let expectedSummary = "Afghanistan"
        XCTAssertEqual(summary, expectedSummary)
    }
    
    func testSummaryOnlyPhoneNumberCell() {
        var style = DefaultBillingFormStyle()
        style.cells = [.phoneNumber(DefaultBillingFormPhoneNumberCellStyle())]
        let testBillingForm = BillingForm(name: "John",
                                          address: Address(addressLine1: "Kong Drive",
                                                           addressLine2: "Blister",
                                                           city: "Dreamland",
                                                           state: "Brilliant place",
                                                           zip: "DR38ML",
                                                           country: Country.allAvailable.first),
                                          phone: Phone(number: "123456", country: Country.allAvailable.last))
        let summary = style.summaryFrom(form: testBillingForm)
        
        let expectedSummary = "263123456"
        XCTAssertEqual(summary, expectedSummary)
    }
    
    // MARK: Test with different billing form data
    func testSummaryFromAllCellsFullInput() {
        let style = DefaultBillingFormStyle()
        let testBillingForm = BillingForm(name: "John",
                                          address: Address(addressLine1: "Kong Drive",
                                                           addressLine2: "Blister",
                                                           city: "Dreamland",
                                                           state: "Brilliant place",
                                                           zip: "DR38ML",
                                                           country: Country.allAvailable.first),
                                          phone: Phone(number: "123456", country: Country.allAvailable.last))
        let summary = style.summaryFrom(form: testBillingForm)
        
        let expectedSummary = "John\n\nKong Drive\n\nBlister\n\nDreamland\n\nBrilliant place\n\nDR38ML\n\nAfghanistan\n\n263123456"
        XCTAssertEqual(summary, expectedSummary)
    }
    
    func testSummaryFromAllCellsOnlyNameInput() {
        let style = DefaultBillingFormStyle()
        let testBillingForm = BillingForm(name: "John",
                                          address: nil,
                                          phone: nil)
        let summary = style.summaryFrom(form: testBillingForm)
        
        let expectedSummary = "John"
        XCTAssertEqual(summary, expectedSummary)
    }
    
    func testSummaryFromAllCellsOnlyAddressInput() {
        let style = DefaultBillingFormStyle()
        let testBillingForm = BillingForm(name: nil,
                                          address: Address(addressLine1: "Kong Drive",
                                                           addressLine2: "Blister",
                                                           city: "Dreamland",
                                                           state: "Brilliant place",
                                                           zip: "DR38ML",
                                                           country: Country.allAvailable.first),
                                          phone: nil)
        let summary = style.summaryFrom(form: testBillingForm)
        
        let expectedSummary = "Kong Drive\n\nBlister\n\nDreamland\n\nBrilliant place\n\nDR38ML\n\nAfghanistan"
        XCTAssertEqual(summary, expectedSummary)
    }
    
    func testSummaryFromAllCellsOnlyPartAddressInput() {
        let style = DefaultBillingFormStyle()
        let testBillingForm = BillingForm(name: nil,
                                          address: Address(addressLine1: "Kong Drive",
                                                           addressLine2: nil,
                                                           city: "Dreamland",
                                                           state: nil,
                                                           zip: "DR38ML",
                                                           country: nil),
                                          phone: nil)
        let summary = style.summaryFrom(form: testBillingForm)
        
        let expectedSummary = "Kong Drive\n\nDreamland\n\nDR38ML"
        XCTAssertEqual(summary, expectedSummary)
    }
    
    func testSummaryFromAllCellsOnlyPhoneInput() {
        let style = DefaultBillingFormStyle()
        let testBillingForm = BillingForm(name: nil,
                                          address: nil,
                                          phone: Phone(number: "123456", country: Country.allAvailable.last))
        let summary = style.summaryFrom(form: testBillingForm)
        
        let expectedSummary = "263123456"
        XCTAssertEqual(summary, expectedSummary)
    }
    
    func testSummaryWithNilForm() {
        let style = DefaultBillingFormStyle()
        let summary = style.summaryFrom(form: nil)
        
        let expectedSummary = ""
        XCTAssertEqual(summary, expectedSummary)
    }
}
