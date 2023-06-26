//
//  Factory.swift
//  iOS Example Frame
//
//  Created by Ehab Alsharkawy.
//  Copyright © 2022 Checkout. All rights reserved.
//

import Frames
import UIKit

enum Factory {

    // swiftlint:disable:next force_unwrapping
  static let successURL = URL(string: "https://httpstat.us/200")!
    // swiftlint:disable:next force_unwrapping
  static let failureURL = URL(string: "https://httpstat.us/403")!
  static let apiKey = "pk_sbox_ym4kqv5lzvjni7utqbliqs2vhqc"
  static let environment: Frames.Environment = .sandbox

  static func getDefaultPaymentViewController(completionHandler: @escaping (Result<TokenDetails, TokenRequestError>) -> Void) -> UIViewController {
    #if UITEST
    return getMinimalUITestVC(completionHandler: completionHandler)
    #endif

    // swiftlint:disable:next force_unwrapping
    let country = Country(iso3166Alpha2: "GB")!

    let address = Address(addressLine1: "Test line1",
                          addressLine2: nil,
                          city: "London",
                          state: "London",
                          zip: "N12345",
                          country: country)

    let phone = Phone(number: "77 1234 1234", country: country)

    let billingFormData = BillingForm(name: "Bình Inyene", address: address, phone: phone)

    let billingFormStyle = FramesFactory.defaultBillingFormStyle

    let paymentFormStyle = FramesFactory.defaultPaymentFormStyle

    let supportedSchemes: [CardScheme] = [.mada, .visa, .mastercard, .maestro, .americanExpress, .discover, .dinersClub, .jcb]

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

    static func getBordersPaymentViewController(completionHandler: @escaping (Result<TokenDetails, TokenRequestError>) -> Void) -> UIViewController {

        let address = Address(addressLine1: "Address line 1",
                              addressLine2: "Address line 2",
                              city: "City",
                              state: "State",
                              zip: "Postcode",
                              country: Country(iso3166Alpha2: "GB"))
        let phone = Phone(number: "77 1234 1234", country: Country(iso3166Alpha2: "GB"))
        let billingFormData = BillingForm(name: "Full name", address: address, phone: phone)
        let supportedSchemes: [CardScheme] = [.visa, .mastercard, .maestro, .americanExpress, .mada]
        let configuration = PaymentFormConfiguration(apiKey: apiKey,
                                                     environment: environment,
                                                     supportedSchemes: supportedSchemes,
                                                     billingFormData: billingFormData)
        let style = ThemeDemo.buildBorderExample()
        let viewController = PaymentFormFactory.buildViewController(configuration: configuration,
                                                                    style: style,
                                                                    completionHandler: completionHandler)
        return viewController
    }

  static func getMatrixPaymentViewController(completionHandler: @escaping (Result<TokenDetails, TokenRequestError>) -> Void) -> UIViewController {
    #if UITEST
    return getCompleteUITestVC(completionHandler: completionHandler)
    #endif

    // swiftlint:disable:next force_unwrapping
    let country = Country(iso3166Alpha2: "GB")!

    let address = Address(addressLine1: "Test line1",
                          addressLine2: nil,
                          city: "London",
                          state: "London",
                          zip: "N12345",
                          country: country)

    let phone = Phone(number: "77 1234 1234", country: country)

    let billingFormData = BillingForm(name: "Şan Lacey", address: address, phone: phone)

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

  static func getOtherPaymentViewController(completionHandler: @escaping (Result<TokenDetails, TokenRequestError>) -> Void) -> UIViewController {

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
