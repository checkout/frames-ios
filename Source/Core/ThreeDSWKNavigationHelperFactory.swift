//
//  ThreeDSWKNavigationHelperFactory.swift
//  Frames
//
//  Created by Harry Brown on 21/06/2022.
//  Copyright © 2022 Checkout. All rights reserved.
//

import Foundation
import Checkout

protocol ThreeDSWKNavigationHelperFactoryProtocol {
    func build(successURL: URL?, failureURL: URL?) -> ThreeDSWKNavigationHelping
}

final class ThreeDSWKNavigationHelperFactory: ThreeDSWKNavigationHelperFactoryProtocol {

    func build(successURL: URL?, failureURL: URL?) -> ThreeDSWKNavigationHelping {
        return ThreeDSWKNavigationHelper(successURL: successURL, failureURL: failureURL)
    }
}
