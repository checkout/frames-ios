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
                          secondaryFontColor: UIColor(red: 114 / 255, green: 114 / 255, blue: 114 / 255, alpha: 1),
                          buttonFontColor: .blue,
                          errorFontColor: .red,
                          backgroundColor: .white,
                          errorBorderColor: .red)
        theme.headerFont = UIFont(robotoStyle: .regular,
                                  size: UIFont.preferredFont(forTextStyle: .title1).pointSize)
        theme.titleFont = UIFont(robotoStyle: .regular,
                                 size: UIFont.preferredFont(forTextStyle: .subheadline).pointSize)
        theme.subtitleFont = UIFont(robotoStyle: .regular,
                                    size: UIFont.preferredFont(forTextStyle: .footnote).pointSize)
        theme.inputFont = UIFont(robotoStyle: .regular,
                                 size: UIFont.preferredFont(forTextStyle: .headline).pointSize)
        theme.buttonFont = UIFont(robotoStyle: .bold,
                                  size: UIFont.preferredFont(forTextStyle: .subheadline).pointSize)
        theme.borderColor = .black
        theme.borderWidth = 1
        return PaymentStyle(paymentFormStyle: buildPaymentFormStyle(theme: theme),
                            billingFormStyle: buildBillingFormStyle(theme: theme))
    }

    private static func buildPaymentFormStyle(theme: Theme) -> Theme.ThemePaymentForm {
        var billingSummary = theme.buildBillingSummary(buttonText: "EDIT BILLING ADDRESS",
                                                       titleText: "BILLING ADDRESS")
        billingSummary.separatorLineColor = .clear
        billingSummary.borderStyle.normalColor = .black
        billingSummary.borderStyle.borderWidth = 1
        billingSummary.button.textColor = .black
        if #available(iOS 13.0, *) {
            billingSummary.button.image = UIImage(systemName: "arrow.right")
        }

        var payButton = theme.buildPayButton(text: "PAY £99.99")
        payButton.backgroundColor = .black
        payButton.textAlignment = .center
        payButton.textColor = .white
        payButton.disabledTextColor = .darkGray
        payButton.disabledTintColor = .lightGray.withAlphaComponent(0.2)

        let cardNumberInput = theme.buildPaymentInput(isTextFieldNumericInput: true,
                                                      titleText: "CARD NUMBER",
                                                      errorText: "Please enter valid card number")
        let expiryDateInput = theme.buildPaymentInput(textFieldPlaceholder: "__ / __",
                                                      isTextFieldNumericInput: false,
                                                      titleText: "EXPIRY DATE",
                                                      errorText: "Please enter valid expiry date")
        let securityCodeInput = theme.buildPaymentInput(isTextFieldNumericInput: true,
                                                        titleText: "SECURITY CODE",
                                                        errorText: "Please enter valid security code")

        var paymentHeader = theme.buildPaymentHeader(title: "Payment details",
                                                     subtitle: "")
        paymentHeader.shouldHideAcceptedCardsList = true
        return theme.buildPaymentForm(
            headerView: paymentHeader,
            addBillingButton: theme.buildAddBillingSectionButton(text: "ADD BILLING ADDRESS",
                                                                 isBillingAddressMandatory: false,
                                                                 titleText: "Billing address"),
            billingSummary: billingSummary,
            cardholder: nil,
            cardNumber: addBorders(to: cardNumberInput),
            expiryDate: addBorders(to: expiryDateInput),
            securityCode: addBorders(to: securityCodeInput),
            payButton: payButton)
    }

    private static func buildBillingFormStyle(theme: Theme) -> Theme.ThemeBillingForm {
        let billingNameCell = theme.buildBillingInput(text: "", isNumericInput: false, isMandatory: false, title: "FULL NAME")
        let billingAddressLine1Cell = theme.buildBillingInput(text: "", isNumericInput: false, isMandatory: true, title: "ADDRESS LINE 1")
        let billingAddressLine2Cell = theme.buildBillingInput(text: "",
                                                              isNumericInput: false,
                                                              isMandatory: false,
                                                              title: "ADDRESS LINE 2",
                                                              isRequiredText: "Optional")
        let billingCityCell = theme.buildBillingInput(text: "", isNumericInput: false, isMandatory: true, title: "CITY")
        let billingStateCell = theme.buildBillingInput(text: "", isNumericInput: false, isMandatory: true, title: "STATE")
        let billingPostcodeCell = theme.buildBillingInput(text: "", isNumericInput: false, isMandatory: true, title: "POSTCODE/ZIP")
        var billingCountryCell = theme.buildBillingCountryInput(buttonText: "Please select a country", title: "COUNTRY")
        if #available(iOS 13.0, *) {
            billingCountryCell.button.image = UIImage(systemName: "chevron.down")
        }
        let billingPhoneCell = theme.buildBillingInput(text: "",
                                                       isNumericInput: true,
                                                       isMandatory: true,
                                                       title: "PHONE NUMBER",
                                                       subtitle: "We will only use this to confirm identity if necessary")
        return theme.buildBillingForm(
            header: theme.buildBillingHeader(title: "Billing address",
                                             cancelButtonTitle: "CANCEL",
                                             doneButtonTitle: "DONE"),
            cells: [.fullName(addBorders(to: billingNameCell)),
                    .addressLine1(addBorders(to: billingAddressLine1Cell)),
                    .addressLine2(addBorders(to: billingAddressLine2Cell)),
                    .city(addBorders(to: billingCityCell)),
                    .state(addBorders(to: billingStateCell)),
                    .postcode(addBorders(to: billingPostcodeCell)),
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
