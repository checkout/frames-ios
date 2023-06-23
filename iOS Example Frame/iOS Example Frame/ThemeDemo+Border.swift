//
//  ThemeDemo+Border.swift
//  iOS Example Frame
//
//  Created by Alex Ioja-Yang on 23/06/2023.
//  Copyright © 2023 Checkout. All rights reserved.
//

import UIKit
import Frames

extension ThemeDemo {

    static func buildBorderExample() -> PaymentStyle {
        var theme = Theme(primaryFontColor: .black,
                          secondaryFontColor: .darkGray,
                          buttonFontColor: .blue,
                          errorFontColor: .red,
                          backgroundColor: .white,
                          errorBorderColor: .red)
        theme.borderColor = .black
        theme.borderWidth = 1
        return PaymentStyle(paymentFormStyle: buildPaymentFormStyle(theme: theme),
                            billingFormStyle: buildBillingFormStyle(theme: theme))
    }

    private static func buildPaymentFormStyle(theme: Theme) -> Theme.ThemePaymentForm {
        var billingSummary = theme.buildBillingSummary(buttonText: "Change billing details",
                                                       titleText: "Billing details")
        billingSummary.borderStyle.normalColor = .black
        billingSummary.borderStyle.cornerRadius = 8
        billingSummary.borderStyle.borderWidth = 1

        var payButton = theme.buildPayButton(text: "Pay now")
        payButton.borderStyle = DefaultBorderStyle(cornerRadius: 8,
                                                   borderWidth: 1,
                                                   normalColor: .black,
                                                   focusColor: .clear,
                                                   errorColor: .clear,
                                                   edges: [.top, .bottom],
                                                   corners: .allCorners)
        payButton.textAlignment = .center

        let cardNumberInput = theme.buildPaymentInput(isTextFieldNumericInput: true,
                                                      titleText: "Card number",
                                                      errorText: "Please enter valid card number",
                                                      errorImage: UIImage(named: "warning"))
        let expiryDateInput = theme.buildPaymentInput(textFieldPlaceholder: "__ / __",
                                                      isTextFieldNumericInput: false,
                                                      titleText: "Expiry date",
                                                      errorText: "Please enter valid expiry date",
                                                      errorImage: UIImage(named: "warning"))
        let securityCodeInput = theme.buildPaymentInput(isTextFieldNumericInput: true,
                                                        titleText: "CVV date",
                                                        errorText: "Please enter valid security code",
                                                        errorImage: UIImage(named: "warning"))

        return theme.buildPaymentForm(
            headerView: theme.buildPaymentHeader(title: "Payment details",
                                                 subtitle: "Accepting your favourite payment methods"),
            addBillingButton: theme.buildAddBillingSectionButton(text: "Add billing details",
                                                                 isBillingAddressMandatory: false,
                                                                 titleText: "Billing details"),
            billingSummary: billingSummary,
            cardholder: nil,
            cardNumber: addBorders(to: cardNumberInput),
            expiryDate: addBorders(to: expiryDateInput),
            securityCode: addBorders(to: securityCodeInput),
            payButton: payButton)
    }

    private static func buildBillingFormStyle(theme: Theme) -> Theme.ThemeBillingForm {
        let billingNameCell = theme.buildBillingInput(text: "", isNumericInput: false, isMandatory: false, title: "Your name")
        let billingAddressLine1Cell = theme.buildBillingInput(text: "", isNumericInput: false, isMandatory: true, title: "Address")
        let billingCityCell = theme.buildBillingInput(text: "", isNumericInput: false, isMandatory: true, title: "City")
        let billingCountryCell = theme.buildBillingCountryInput(buttonText: "Select your country", title: "Country")
        let billingPhoneCell = theme.buildBillingInput(text: "", isNumericInput: true, isMandatory: true, title: "Phone number")
        return theme.buildBillingForm(
            header: theme.buildBillingHeader(title: "Billing information",
                                             cancelButtonTitle: "Cancel",
                                             doneButtonTitle: "Done"),
            cells: [.fullName(addBorders(to: billingNameCell)),
                    .addressLine1(addBorders(to: billingAddressLine1Cell)),
                    .city(addBorders(to: billingCityCell)),
                    .country(addBorders(to: billingCountryCell)),
                    .phoneNumber(addBorders(to: billingPhoneCell))])
    }

    private static func addBorders(to inputSection: Theme.ThemePaymentInput) -> Theme.ThemePaymentInput {
        guard var textField = inputSection.textfield as? Theme.ThemeTextField else {
            return inputSection
        }
        var newInputSection = inputSection
        let borderStyle = DefaultBorderStyle(cornerRadius: 0,
                                             borderWidth: 1,
                                             normalColor: .black,
                                             focusColor: .blue,
                                             errorColor: .red,
                                             edges: .bottom,
                                             corners: [])
        textField.borderStyle = borderStyle
        newInputSection.textfield = textField
        return newInputSection
    }

    private static func addBorders(to billingSection: Theme.ThemeBillingInput) -> Theme.ThemeBillingInput {
        guard var textField = billingSection.textfield as? Theme.ThemeTextField else {
            return billingSection
        }
        var newBillingSection = billingSection
        let borderStyle = DefaultBorderStyle(cornerRadius: 0,
                                             borderWidth: 1,
                                             normalColor: .black,
                                             focusColor: .blue,
                                             errorColor: .red,
                                             edges: .bottom,
                                             corners: [])
        textField.borderStyle = borderStyle
        newBillingSection.textfield = textField
        return newBillingSection
    }

    private static func addBorders(to country: Theme.ThemeBillingCountryInput) -> Theme.ThemeBillingCountryInput {
        var newCountry = country
        guard var newButton = country.button as? Theme.CountryListButton else {
            return country
        }
        newButton.borderStyle = DefaultBorderStyle(cornerRadius: 0,
                                                   borderWidth: 1,
                                                   normalColor: .black,
                                                   focusColor: .blue,
                                                   errorColor: .red,
                                                   edges: .bottom,
                                                   corners: [])
        newCountry.button = newButton
        return newCountry
    }
}
