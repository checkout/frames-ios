//
//  PaymentFormConfiguration.swift
//  
//
//  Created by Alex Ioja-Yang on 26/07/2022.
//

import Foundation
import Checkout

public struct PaymentFormConfiguration {
    let serviceAPIKey: String
    let environment: Environment
    let supportedSchemes: [Card.Scheme]
    let billingFormData: BillingForm?
    let baseURLPrefix: String?

    /**
     Create a configuration for the Payment form
     
     - Parameters:
        - apiKey: API Key provided by Checkout enabling you access to our services
        - environment: Enum describing the environment the SDK is running in
        - supportedSchemes: Card schemes supported for receiving payments. Accurate declaration of supported schemes will improve customer experience
        - billingFormData: Pre filled Billing form information to be included and help reduce user input if known
        - baseURLPrefix: Optional subdomain prefix for the API base URL (e.g. "msdd" produces "msdd.api.checkout.com")
     */
    public init(apiKey: String,
                environment: Environment,
                supportedSchemes: [CardScheme],
                billingFormData: BillingForm?,
                baseURLPrefix: String? = nil) {
        self.serviceAPIKey = apiKey
        self.environment = environment
        self.supportedSchemes = supportedSchemes.compactMap { $0.mapToCheckoutCardScheme() }
        self.billingFormData = billingFormData
        self.baseURLPrefix = baseURLPrefix
    }
}
