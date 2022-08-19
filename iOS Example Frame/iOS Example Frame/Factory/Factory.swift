//
//  Factory.swift
//  iOS Example Frame
//
//  Created by Ehab Alsharkawy.
//  Copyright © 2022 Checkout. All rights reserved.
//

import Frames
import Checkout
import UIKit

struct Factory {
  static let successURL = URL(string: "https://httpstat.us/200")!
  static let failureURL = URL(string: "https://httpstat.us/403")!
  private static let apiKey = "pk_test_6e40a700-d563-43cd-89d0-f9bb17d35e73"
  private static let environment: Frames.Environment = .sandbox

  static func getDefaultPaymentViewController(completionHandler: @escaping (Result<TokenDetails, TokenisationError.TokenRequest>) -> Void) -> UIViewController {

    let country = Country(iso3166Alpha2: "GB")!

    let address = Address(addressLine1: "Test line1",
                          addressLine2: nil,
                          city: "London",
                          state: "London",
                          zip: "N12345",
                          country: country)

    let phone = Phone(number: "77 1234 1234", country: country)

    let billingFormData = BillingForm(name: "User 1", address: address, phone: phone)

    let billingFormStyle = FramesFactory.defaultBillingFormStyle

    let paymentFormStyle = FramesFactory.defaultPaymentFormStyle

    let supportedSchemes: [CardScheme] = [.visa, .mastercard, .maestro]

    let configuration = PaymentFormConfiguration(apiKey: apiKey,
                                                 environment: environment,
                                                 supportedSchemes: supportedSchemes,
                                                 billingFormData: billingFormData)

    let style = PaymentStyle(paymentFormStyle: paymentFormStyle,
                             billingFormStyle: billingFormStyle)

    let viewController = PaymentFormFactory.buildViewController(configuration: configuration,
                                                                style: style,
                                                                completionHandler: completionHandler)

    return viewController
  }

  static func getMatrixPaymentViewController(completionHandler: @escaping (Result<TokenDetails, TokenisationError.TokenRequest>) -> Void) -> UIViewController {

    let country = Country(iso3166Alpha2: "GB")!

    let address = Address(addressLine1: "Test line1",
                          addressLine2: nil,
                          city: "London",
                          state: "London",
                          zip: "N12345",
                          country: country)

    let phone = Phone(number: "77 1234 1234", country: country)

    let billingFormData = BillingForm(name: "User 1", address: address, phone: phone)

    let billingFormStyle = Style.billingForm

    let paymentFormStyle = Style.paymentForm

    let supportedSchemes: [CardScheme] = [.visa, .mastercard, .maestro]

    let configuration = PaymentFormConfiguration(apiKey: apiKey,
                                                 environment: environment,
                                                 supportedSchemes: supportedSchemes,
                                                 billingFormData: billingFormData)

    let style = PaymentStyle(paymentFormStyle: paymentFormStyle,
                             billingFormStyle: billingFormStyle)

    let viewController = PaymentFormFactory.buildViewController(configuration: configuration,
                                                                style: style,
                                                                completionHandler: completionHandler)

    return viewController
  }

  static func getOtherPaymentViewController(completionHandler: @escaping (Result<TokenDetails, TokenisationError.TokenRequest>) -> Void) -> UIViewController {

    let address = Address(addressLine1: "78 Marvelous Rd",
                          addressLine2: nil,
                          city: "London",
                          state: nil,
                          zip: nil,
                          country: Country(iso3166Alpha2: "GB"))

    let billingFormData = BillingForm(name: "Bob Higgins", address: address, phone: nil)

    let supportedSchemes: [CardScheme] = [.visa, .mastercard, .maestro, .americanExpress, .mada]

    let configuration = PaymentFormConfiguration(apiKey: apiKey,
                                                 environment: environment,
                                                 supportedSchemes: supportedSchemes,
                                                 billingFormData: billingFormData)

    let style = ThemeDemo.buildCustom2Example()

    let viewController = PaymentFormFactory.buildViewController(configuration: configuration,
                                                                style: style,
                                                                completionHandler: completionHandler)

    return viewController
  }

}
