//
//  PaymentFormConfiguration.swift
//  
//
//  Created by Alex Ioja-Yang on 26/07/2022.
//

import Foundation

public struct PaymentFormConfiguration {
    let serviceAPIKey: String
    let environment: Environment
    let supportedSchemes: [Card.Scheme]
    let billingFormData: BillingForm?

    /**
     Create a configuration for the Payment form
     
     - Parameters:
        - apiKey: API Key provided by Checkout enabling you access to our services
        - environment: Enum describing whether the SDK is running in a testing/sandbox/dev environment or if its been shipped to end customer for a live environment
        - supportedSchemes: Card schemes supported for receiving payments. Accurate declaration of supported schemes will improve customer experience
        - billingFormData: Pre filled Billing form information to be included and help reduce user input if known
     */
    public init(apiKey: String,
                environment: Environment,
                supportedSchemes: [Card.Scheme],
                billingFormData: BillingForm?) {
        self.serviceAPIKey = apiKey
        self.environment = environment
        self.supportedSchemes = supportedSchemes
        self.billingFormData = billingFormData
    }
}
