//
//  RemoteProcessorMetadata+extensions.swift
//  Frames
//
//  Created by Harry Brown on 03/05/2022.
//  Copyright © 2022 Checkout. All rights reserved.
//

import CheckoutEventLoggerKit

extension RemoteProcessorMetadata {

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
