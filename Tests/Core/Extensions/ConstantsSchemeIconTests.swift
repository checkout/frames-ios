//
//  ConstantsSchemeIconTests.swift
//  FramesTests
//
//  Created by Harry Brown on 13/07/2022.
//  Copyright © 2022 Checkout. All rights reserved.
//

import XCTest
@testable import Frames
import Checkout


final class ConstantsSchemeIconTests: XCTestCase {
  func test_schemeInit() {
    let testCases: [Card.Scheme: Constants.Bundle.SchemeIcon] = [
      .americanExpress: .americanExpress,
      .dinersClub: .dinersClub,
      .discover: .discover,
      .jcb: .jcb,
      .maestro(): .maestro,
      .mastercard: .mastercard,
      .visa: .visa,
      .mada: .mada,
      .unknown: .blank
    ]

    testCases.forEach { scheme, expectedIcon in
      XCTAssertEqual(Constants.Bundle.SchemeIcon(scheme: scheme), expectedIcon, "expected \(expectedIcon) for \(scheme)")
    }
  }

  func test_allIconsHaveImage() {
    let testCases = Constants.Bundle.SchemeIcon.allCases

    testCases.forEach { schemeIconLocation in
      XCTAssertNotNil(schemeIconLocation.image, "no image found for \(schemeIconLocation)")
    }
  }
}
