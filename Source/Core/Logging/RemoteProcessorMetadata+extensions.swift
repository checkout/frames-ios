//
//  RemoteProcessorMetadata+extensions.swift
//  Frames
//
//  Created by Harry Brown on 03/05/2022.
//  Copyright © 2022 Checkout. All rights reserved.
//

import CheckoutEventLoggerKit
import UIKit

extension RemoteProcessorMetadata {

    init(environment: Environment) {
        let appPackageName = Bundle.main.bundleIdentifier
            ?? Constants.Bundle.FallbackValues.noBundleIdentifier.rawValue
        let appPackageVersion = Bundle.main.infoDictionary?[Constants.Bundle.version.rawValue] as? String
            ?? Constants.Bundle.FallbackValues.noVersion.rawValue

        self.init(environment: environment,
                  appPackageName: appPackageName,
                  appPackageVersion: appPackageVersion,
                  uiDevice: UIKit.UIDevice.current)
    }

    init(environment: Environment,
         appPackageName: String,
         appPackageVersion: String,
         uiDevice: UIDevice) {

        self.init(productIdentifier: Constants.productName,
                  productVersion: Constants.version,
                  environment: environment.rawValue,
                  appPackageName: appPackageName,
                  appPackageVersion: appPackageVersion,
                  deviceName: uiDevice.modelName,
                  platform: "iOS",
                  osVersion: uiDevice.systemVersion)
    }
}
