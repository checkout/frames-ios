//
//  CheckoutAPIService.swift
//  
//
//  Created by Harry Brown on 03/02/2022.
//

import Foundation
import UIKit
import Checkout
import CheckoutEventLoggerKit

protocol CheckoutAPIProtocol {
    func createToken(_ paymentSource: PaymentSource, completion: @escaping (Result<TokenDetails, TokenisationError.TokenRequest>) -> Void)
    var cardValidator: CardValidating { get }
    var logger: FramesEventLogging { get }
}

public class CheckoutAPIService: CheckoutAPIProtocol {

    private let checkoutAPIService: Checkout.CheckoutAPIProtocol
    let cardValidator: CardValidating
    let logger: FramesEventLogging

    public convenience init(publicKey: String, environment: Environment) {
        let checkoutAPIService = Checkout.CheckoutAPIService(publicKey: publicKey, environment: environment.checkoutEnvironment)
        let cardValidator = CardValidator(environment: environment.checkoutEnvironment)
        let logger = Self.buildFramesEventLogger(environment: environment, getCorrelationID: { checkoutAPIService.correlationID })

        self.init(checkoutAPIService: checkoutAPIService, cardValidator: cardValidator, logger: logger)
    }

    init(checkoutAPIService: Checkout.CheckoutAPIProtocol, cardValidator: CardValidating, logger: FramesEventLogger) {
        self.checkoutAPIService = checkoutAPIService
        self.cardValidator = cardValidator
        self.logger = logger
    }

    public func createToken(_ paymentSource: PaymentSource, completion: @escaping (Result<TokenDetails, TokenisationError.TokenRequest>) -> Void) {
        checkoutAPIService.createToken(paymentSource, completion: completion)
    }

    static func buildFramesEventLogger(environment: Environment, getCorrelationID: @escaping () -> String) -> FramesEventLogger {
        let checkoutEventLogger = CheckoutEventLogger(productName: Constants.productName)
        let appBundle = Foundation.Bundle.main
        let appPackageName = appBundle.bundleIdentifier ?? "unavailableAppPackageName"
        let appPackageVersion = appBundle.infoDictionary?["CFBundleShortVersionString"] as? String ?? "unavailableAppPackageVersion"

        let uiDevice = UIKit.UIDevice.current

        let remoteProcessorMetadata = Self.buildRemoteProcessorMetadata(environment: environment,
                                                                        appPackageName: appPackageName,
                                                                        appPackageVersion: appPackageVersion,
                                                                        uiDevice: uiDevice)

        checkoutEventLogger.enableRemoteProcessor(environment: environment.eventLoggerEnvironment, remoteProcessorMetadata: remoteProcessorMetadata)
        let dateProvider = DateProvider()

        return FramesEventLogger(getCorrelationID: getCorrelationID, checkoutEventLogger: checkoutEventLogger, dateProvider: dateProvider)
    }

    static func buildRemoteProcessorMetadata(environment: Environment,
                                             appPackageName: String,
                                             appPackageVersion: String,
                                             uiDevice: UIDevice) -> RemoteProcessorMetadata {

        return RemoteProcessorMetadata(productIdentifier: Constants.productName,
                                       productVersion: Constants.version,
                                       environment: environment.rawValue,
                                       appPackageName: appPackageName,
                                       appPackageVersion: appPackageVersion,
                                       deviceName: uiDevice.modelName,
                                       platform: "iOS",
                                       osVersion: uiDevice.systemVersion)
    }
}
