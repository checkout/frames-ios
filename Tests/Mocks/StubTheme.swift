//
//  StubTheme.swift
//  FramesTests
//
//  Created by Harry Brown on 24/03/2022.
//  Copyright © 2022 Checkout. All rights reserved.
//

import Foundation
import CheckoutEventLoggerKit
@testable import Frames

final class StubTheme: Theme {
    private(set) var propertiesCalled = false
    var propertiesToReturn: [FramesLogEvent.Property: AnyCodable] = [:]

    override var properties: [FramesLogEvent.Property: AnyCodable] {
        propertiesCalled = true
        return propertiesToReturn
    }
}
