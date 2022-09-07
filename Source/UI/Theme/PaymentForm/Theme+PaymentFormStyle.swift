//
//  Theme+PaymentFormStyle.swift
//  
//
//  Created by Alex Ioja-Yang on 09/08/2022.
//

import UIKit

// swiftlint:disable function_parameter_count
public extension Theme {

    /// Theme generated payment form
    struct ThemePaymentForm: PaymentFormStyle {
        public var backgroundColor: UIColor
        public var headerView: PaymentHeaderCellStyle
        public var addBillingSummary: CellButtonStyle?
        public var editBillingSummary: BillingSummaryViewStyle?
        public var cardholderInput: CellTextFieldStyle?
        public var cardNumber: CellTextFieldStyle
        public var expiryDate: CellTextFieldStyle
        public var securityCode: CellTextFieldStyle?
        public var payButton: ElementButtonStyle
    }

    /// Create a Payment Form from the provided Styles for each section
    func buildPaymentForm(headerView: PaymentHeaderCellStyle,
                          addBillingButton: CellButtonStyle?,
                          billingSummary: BillingSummaryViewStyle?,
                          cardholder: CellTextFieldStyle?,
                          cardNumber: CellTextFieldStyle,
                          expiryDate: CellTextFieldStyle,
                          securityCode: CellTextFieldStyle?,
                          payButton: ElementButtonStyle) -> ThemePaymentForm {
        ThemePaymentForm(backgroundColor: self.backgroundColor,
                         headerView: headerView,
                         addBillingSummary: addBillingButton,
                         editBillingSummary: billingSummary,
                         cardholderInput: cardholder,
                         cardNumber: cardNumber,
                         expiryDate: expiryDate,
                         securityCode: securityCode,
                         payButton: payButton)
    }

}
