//
//  CardSchemeTests.swift
//  
//
//  Created by Alex Ioja-Yang on 05/08/2022.
//

import XCTest
@testable import Frames

final class CardSchemeTests: XCTestCase {
    func testMapMada() {
        let scheme = CardScheme.mada
        XCTAssertEqual(scheme.mapToCheckoutCardScheme(), .mada)
    }

    func testMapVisa() {
        let scheme = CardScheme.visa
        XCTAssertEqual(scheme.mapToCheckoutCardScheme(), .visa)
    }

    func testMapMastercard() {
        let scheme = CardScheme.mastercard
        XCTAssertEqual(scheme.mapToCheckoutCardScheme(), .mastercard)
    }

    func testMapMaestro() {
        let scheme = CardScheme.maestro
        XCTAssertEqual(scheme.mapToCheckoutCardScheme(), .maestro(length: 0))
    }

    func testMapAmericanExpress() {
        let scheme = CardScheme.americanExpress
        XCTAssertEqual(scheme.mapToCheckoutCardScheme(), .americanExpress)
    }

    func testMapDiscover() {
        let scheme = CardScheme.discover
        XCTAssertEqual(scheme.mapToCheckoutCardScheme(), .discover)
    }

    func testMapDinersClub() {
        let scheme = CardScheme.dinersClub
        XCTAssertEqual(scheme.mapToCheckoutCardScheme(), .dinersClub)
    }

    func testMapJCB() {
        let scheme = CardScheme.jcb
        XCTAssertEqual(scheme.mapToCheckoutCardScheme(), .jcb)
    }
}
