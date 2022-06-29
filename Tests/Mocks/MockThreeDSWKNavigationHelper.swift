//
//  MockThreeDSWKNavigationHelper.swift
//  FramesTests
//
//  Created by Harry Brown on 21/06/2022.
//  Copyright © 2022 Checkout. All rights reserved.
//

import Foundation
@testable import Checkout

final class MockThreeDSWKNavigationHelper: NSObject, ThreeDSWKNavigationHelping {
    var delegate: ThreeDSWKNavigationHelperDelegate?
}
