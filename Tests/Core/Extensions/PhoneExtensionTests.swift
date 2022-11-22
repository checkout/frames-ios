//
//  File.swift
//  
//
//  Created by Ehab Alsharkawy on 22/11/2022.
//

import XCTest
@testable import Frames
import Checkout


final class PhoneTests: XCTestCase {
    func testDisplayFormatted() {
        let country = Country(iso3166Alpha2: "GB")
        let phone = Phone(number: "123456789", country: country)

        let displayFormatted = phone.displayFormatted()

        XCTAssertEqual(displayFormatted, "+44 123456789")
    }
}
