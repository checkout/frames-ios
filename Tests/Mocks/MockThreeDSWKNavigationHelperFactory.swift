//
//  MockThreeDSWKNavigationHelperFactory.swift
//  FramesTests
//
//  Created by Harry Brown on 21/06/2022.
//  Copyright © 2022 Checkout. All rights reserved.
//

import Foundation
@testable import Frames
import Checkout

class MockThreeDSWKNavigationHelperFactory: ThreeDSWKNavigationHelperFactoryProtocol {

    private(set) var buildCalledWith: (successURL: URL?, failureURL: URL?)?
    var buildToReturn: ThreeDSWKNavigationHelping = MockThreeDSWKNavigationHelper()
    func build(successURL: URL?, failureURL: URL?) -> ThreeDSWKNavigationHelping {
        buildCalledWith = (successURL, failureURL)
        return buildToReturn
    }
}
