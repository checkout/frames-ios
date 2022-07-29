//
//  CustomStyle2.swift
//  iOS Example Frame
//
//  Created by Deepesh.Vasthimal on 06/06/2022.
//  Copyright © 2022 Checkout. All rights reserved.
//

import UIKit
import Frames

// MARK: - Color Constants -

private enum Constants {
  static let fontColorLabel = UIColor(red: 35 / 255.0, green: 38 / 255.0, blue: 39 / 255.0, alpha: 1.0)
  static let grayBackgroundColor = UIColor(red: 249 / 255.0, green: 249 / 255.0, blue: 249 / 255.0, alpha: 1.0)
  static let whiteBackgroundColor = UIColor(red: 255 / 255.0, green: 255 / 255.0, blue: 255 / 255.0, alpha: 1.0)
  static let errorLabelBackgroundColor = UIColor(red: 79 / 255.0, green: 191 / 255.0, blue: 74 / 255.0, alpha: 1.0)
  static let greenBackgroundColor = UIColor(red: 79 / 255.0, green: 191 / 255.0, blue: 174 / 255.0, alpha: 1.0)
  static let textFieldBackgroundColor = UIColor(red: 255 / 255.0, green: 255 / 255.0, blue: 255 / 255.0, alpha: 1.0)
}

// **********************
// MARK: - Payment Form
// **********************

// MARK: - Main Payment Form

struct PaymentFormStyleCustom2: PaymentFormStyle {
  var backgroundColor: UIColor = Constants.whiteBackgroundColor
  var headerView: PaymentHeaderCellStyle = PaymentHeaderCellStyleCustom2()
  var addBillingSummary: CellButtonStyle? = AddBillingDetailsViewStyleCustom2()
  var editBillingSummary: BillingSummaryViewStyle? = EditBillingSummaryStyleCustom2()
  var cardNumber: CellTextFieldStyle?
  var expiryDate: CellTextFieldStyle? = ExpiryDateFormStyleCustom2()
  var securityCode: CellTextFieldStyle? =  SecurityCodeFormStyleCustom2()
}

// MARK: - Header View

struct PaymentHeaderCellStyleCustom2: PaymentHeaderCellStyle {
  var backgroundColor = Constants.greenBackgroundColor
  var headerLabel: ElementStyle? = HeaderLabelFormStyleCustom2(text: "Payment details")
  public var subtitleLabel: ElementStyle? = TitleLabelStyleCustom2(text: "Visa, Mastercard and American Express accepted.")
  public var schemeIcons: [UIImage?] = []
}

// MARK: - Billing Form WITH Summary ( Edit details )

/// This style for summary view with pre-filled with Address or Phone
struct EditBillingSummaryStyleCustom2: BillingSummaryViewStyle {
  var isMandatory = true
  var cornerRadius: CGFloat = 10
  var borderWidth: CGFloat = 1.0
  var separatorLineColor: UIColor = Constants.greenBackgroundColor
  var backgroundColor: UIColor = .clear
  var borderColor: UIColor = Constants.greenBackgroundColor
  var button: ElementButtonStyle = SummaryButtonStyleCustom2()
  var title: ElementStyle? = TitleLabelStyleCustom2(text: "Billing address")
  var hint: ElementStyle? = HintInputLabelStyleCustom2(text: "We need this information as an additional security measure to verify this card.")
  var summary: ElementStyle? = TitleLabelStyleCustom2(textColor: Constants.fontColorLabel)
  var mandatory: ElementStyle?
  var error: ElementErrorViewStyle?
}

// MARK: - Billing Form WITH Summary Button ( Edit details )

/// This style for summary button with pre-filled summary view style
struct SummaryButtonStyleCustom2: ElementButtonStyle {
  var image: UIImage? =  UIImage(named: "arrow_blue_right")?.imageFlippedForRightToLeftLayoutDirection()
  var text: String = "Edit billing address"
  var font = UIFont.systemFont(ofSize: 15)
  var textColor: UIColor = Constants.greenBackgroundColor
  var disabledTextColor: UIColor = .clear
  var disabledTintColor: UIColor = .clear
  var activeTintColor: UIColor = Constants.greenBackgroundColor
  var imageTintColor: UIColor = Constants.greenBackgroundColor
  var backgroundColor: UIColor = .clear
  var normalBorderColor: UIColor = .clear
  var focusBorderColor: UIColor = .clear
  var errorBorderColor: UIColor = .clear
  var isHidden = false
  var isEnabled = true
  var height: Double = 56
  var width: Double = 0
  var cornerRadius: CGFloat = 10
  var borderWidth: CGFloat = 1
  var textLeading: CGFloat = 20
}

// MARK: - Billing Form WITHOUT Summary  ( Add details )

/// This style for `add billing details View` when summary is not provided
struct AddBillingDetailsViewStyleCustom2: CellButtonStyle {
  var mandatory: ElementStyle?
  var backgroundColor: UIColor = .clear
  var button: ElementButtonStyle = AddBillingDetailsButtonStyleCustom2()
  var isMandatory = true
  var title: ElementStyle? = TitleLabelStyleCustom2(text: "Billing address")
  var hint: ElementStyle? = HintInputLabelStyleCustom2(text: "We need this information as an additional security measure to verify this card.")
  var error: ElementErrorViewStyle?
}

// MARK: - Billing Form WITHOUT Summary Button ( Add details )

/// This style for `add billing details Button` when summary is not provided
struct AddBillingDetailsButtonStyleCustom2: ElementButtonStyle {
  var image: UIImage? =  UIImage(named: "arrow_blue_right")?.imageFlippedForRightToLeftLayoutDirection()
  var text: String = "Add billing address"
  var font = UIFont.systemFont(ofSize: 15)
  var textColor: UIColor = Constants.greenBackgroundColor
  var disabledTextColor: UIColor = Constants.grayBackgroundColor
  var disabledTintColor: UIColor = Constants.grayBackgroundColor
  var activeTintColor: UIColor = Constants.greenBackgroundColor
  var backgroundColor: UIColor = .clear
  var normalBorderColor: UIColor = Constants.greenBackgroundColor
  var focusBorderColor: UIColor = Constants.greenBackgroundColor
  var errorBorderColor: UIColor = .tallPoppyRed
  var imageTintColor: UIColor = Constants.greenBackgroundColor
  var isHidden = false
  var isEnabled = true
  var height: Double = 56
  var width: Double = 0
  var cornerRadius: CGFloat = 10
  var borderWidth: CGFloat = 1
  var textLeading: CGFloat = 20
}

// MARK: - Expiry Date

public struct ExpiryDateFormStyleCustom2: CellTextFieldStyle {
  public var isMandatory = true
  public var backgroundColor: UIColor = .clear
  public var title: ElementStyle? = TitleLabelStyleCustom2(text: "Expiry date")
  public var hint: ElementStyle? = HintInputLabelStyleCustom2(text: "Format is MM/YY")
  public var mandatory: ElementStyle?
  public var textfield: ElementTextFieldStyle = TextFieldCustom2(placeHolder: "MM/YY")
  public var error: ElementErrorViewStyle? = ErrorInputLabelStyleCustom2(text: "please fill expiry date")
}

// MARK: - Security Code

public struct SecurityCodeFormStyleCustom2: CellTextFieldStyle {
  public var isMandatory = true
  public var backgroundColor: UIColor = .clear
  public var title: ElementStyle? = TitleLabelStyleCustom2(text: "Security code")
  public var hint: ElementStyle? = HintInputLabelStyleCustom2(text: "3 - 4 digit code on your card")
  public var mandatory: ElementStyle?
  public var textfield: ElementTextFieldStyle = TextFieldCustom2()
  public var error: ElementErrorViewStyle? = ErrorInputLabelStyleCustom2(text: "please fill security code")
}

// **********************
// MARK: - Billing Form
// **********************

// MARK: - Main Billing Form

struct BillingFormStyleCustom2: BillingFormStyle {
  var mainBackground: UIColor = Constants.grayBackgroundColor
  var header: BillingFormHeaderCellStyle = BillingFormHeaderCellStyleCustom2()
  var cells: [BillingFormCell] = [.fullName(BillingFormFullNameCellStyleCustom2()),
                                  .addressLine1(BillingFormAddressLine1CellStyleCustom2()),
                                  .addressLine2(BillingFormAddressLine2CellStyleCustom2()),
                                  .city(BillingFormCityCellStyleCustom2()),
                                  .state(BillingFormStateCellStyleCustom2()),
                                  .postcode(BillingFormPostcodeCellStyleCustom2()),
                                  .country(BillingFormCountryCellStyleCustom2()),
                                  .phoneNumber(BillingFormPhoneNumberCellStyleCustom2())]
}

// MARK: - Full Name

struct BillingFormFullNameCellStyleCustom2: CellTextFieldStyle {
  var isMandatory = true
  var isOptional = false
  var backgroundColor: UIColor = Constants.grayBackgroundColor
  var title: ElementStyle? = TitleLabelStyleCustom2(text: "Full Name")
  var hint: ElementStyle?
  var mandatory: ElementStyle?
  var textfield: ElementTextFieldStyle = TextFieldCustom2()
  var error: ElementErrorViewStyle? = ErrorInputLabelStyleCustom2(text: "Enter Name", textColor: Constants.errorLabelBackgroundColor)
}

// MARK: - Address Line 1

struct BillingFormAddressLine1CellStyleCustom2: CellTextFieldStyle {
  var isMandatory = true
  var isOptional = true
  var backgroundColor: UIColor = Constants.grayBackgroundColor
  var title: ElementStyle? = TitleLabelStyleCustom2(text: "Address Line 1*")
  var hint: ElementStyle?
  var mandatory: ElementStyle?
  var textfield: ElementTextFieldStyle = TextFieldCustom2()
  var error: ElementErrorViewStyle? = ErrorInputLabelStyleCustom2(text: "Enter Address Line 1", textColor: Constants.errorLabelBackgroundColor)
}

// MARK: - Address Line 2

struct BillingFormAddressLine2CellStyleCustom2: CellTextFieldStyle {
  var isMandatory = true
  var isOptional = true
  var backgroundColor: UIColor = Constants.grayBackgroundColor
  var title: ElementStyle? = TitleLabelStyleCustom2(text: "Address Line 2")
  var hint: ElementStyle?
  var mandatory: ElementStyle?
  var textfield: ElementTextFieldStyle = TextFieldCustom2()
  var error: ElementErrorViewStyle? = ErrorInputLabelStyleCustom2(text: "Enter Address Line 2", textColor: Constants.errorLabelBackgroundColor)
}

// MARK: - City

struct BillingFormCityCellStyleCustom2: CellTextFieldStyle {
  var isMandatory = true
  var isOptional = false
  var backgroundColor: UIColor = Constants.grayBackgroundColor
  var title: ElementStyle? = TitleLabelStyleCustom2(text: "Town*")
  var hint: ElementStyle?
  var mandatory: ElementStyle?
  var textfield: ElementTextFieldStyle = TextFieldCustom2()
  var error: ElementErrorViewStyle? = ErrorInputLabelStyleCustom2(text: "Enter Town", textColor: Constants.errorLabelBackgroundColor)
}

// MARK: - State - County

struct BillingFormStateCellStyleCustom2: CellTextFieldStyle {
  var isMandatory = true
  var isOptional = false
  var backgroundColor: UIColor = Constants.grayBackgroundColor
  var title: ElementStyle? = TitleLabelStyleCustom2(text: "County")
  var hint: ElementStyle?
  var mandatory: ElementStyle?
  var textfield: ElementTextFieldStyle = TextFieldCustom2()
  var error: ElementErrorViewStyle? = ErrorInputLabelStyleCustom2(text: "Enter County", textColor: Constants.errorLabelBackgroundColor)
}

// MARK: - Postcode - zip

struct BillingFormPostcodeCellStyleCustom2: CellTextFieldStyle {
  var isMandatory = true
  var isOptional = false
  var backgroundColor: UIColor = Constants.grayBackgroundColor
  var title: ElementStyle? = TitleLabelStyleCustom2(text: "Postcode*")
  var hint: ElementStyle?
  var mandatory: ElementStyle?
  var textfield: ElementTextFieldStyle = TextFieldCustom2()
  var error: ElementErrorViewStyle? = ErrorInputLabelStyleCustom2(text: "Enter Postcode", textColor: Constants.errorLabelBackgroundColor)
}

// MARK: Country

struct BillingFormCountryCellStyleCustom2: CellButtonStyle {
  var isMandatory = true
  var backgroundColor: UIColor = Constants.grayBackgroundColor
  var button: ElementButtonStyle = CountryFormButtonStyleCustom2()
  var isOptional = false
  var title: ElementStyle? = TitleLabelStyleCustom2(text: "Country*")
  var hint: ElementStyle?
  var mandatory: ElementStyle?
  var error: ElementErrorViewStyle? = ErrorInputLabelStyleCustom2(text: "Enter Country", textColor: Constants.errorLabelBackgroundColor)
}

// MARK: - Phone Number

struct BillingFormPhoneNumberCellStyleCustom2: CellTextFieldStyle {
  var isMandatory = true
  var isOptional = false
  var mandatory: ElementStyle?
  var backgroundColor: UIColor = Constants.grayBackgroundColor
  var title: ElementStyle? = TitleLabelStyleCustom2(text: "Phone*")
  var hint: ElementStyle? = HintInputLabelStyleCustom2(isHidden: true, text: "")
  var textfield: ElementTextFieldStyle = TextFieldCustom2(isSupportingNumericKeyboard: true)
  var error: ElementErrorViewStyle? = ErrorInputLabelStyleCustom2(text: "Enter Phone Number", textColor: Constants.errorLabelBackgroundColor)
}

// MARK: - Main Header

struct BillingFormHeaderCellStyleCustom2: BillingFormHeaderCellStyle {
  var backgroundColor: UIColor = Constants.greenBackgroundColor
  var headerLabel: ElementStyle = HeaderLabelFormStyleCustom2()
  var cancelButton: ElementButtonStyle = CancelButtonFormStyleCustom2()
  var doneButton: ElementButtonStyle = DoneFormButtonStyleCustom2()
}

// MARK: - Header title

struct HeaderLabelFormStyleCustom2: ElementStyle {
  var backgroundColor: UIColor = .clear
  var isHidden = false
  var text: String = "Billing Details"
  var font = UIFont.systemFont(ofSize: 24.0)
  var textColor: UIColor  = .white
}

// MARK: - Header Cancel

struct CancelButtonFormStyleCustom2: ElementButtonStyle {
  var image: UIImage?
  var text: String = "Cancel"
  var font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
  var disabledTextColor: UIColor = Constants.grayBackgroundColor
  var disabledTintColor: UIColor = Constants.grayBackgroundColor
  var activeTintColor: UIColor = Constants.greenBackgroundColor
  var backgroundColor: UIColor = Constants.greenBackgroundColor
  var textColor: UIColor = .white
  var normalBorderColor: UIColor = .clear
  var focusBorderColor: UIColor = .clear
  var errorBorderColor: UIColor = .clear
  var imageTintColor: UIColor = Constants.greenBackgroundColor
  var isHidden = false
  var isEnabled = true
  var height: Double = 44
  var width: Double = 53
  var cornerRadius: CGFloat = 10
  var borderWidth: CGFloat = 3
  var textLeading: CGFloat = 0
}

// MARK: - Header Done

struct DoneFormButtonStyleCustom2: ElementButtonStyle {
  var image: UIImage?
  var text: String = "Done"
  var font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
  var disabledTextColor: UIColor = Constants.grayBackgroundColor
  var disabledTintColor: UIColor = .doveGray
  var activeTintColor: UIColor = .brandeisBlue
  var backgroundColor: UIColor = Constants.greenBackgroundColor
  var normalBorderColor: UIColor = .clear
  var focusBorderColor: UIColor = .clear
  var errorBorderColor: UIColor = .clear
  var imageTintColor: UIColor = Constants.greenBackgroundColor
  var textColor: UIColor = .white
  var isHidden = false
  var isEnabled = true
  var height: Double = 44
  var width: Double = 53
  var cornerRadius: CGFloat = 10
  var borderWidth: CGFloat = 3
  var textLeading: CGFloat = 0
}

// MARK: - Common Title Label

struct TitleLabelStyleCustom2: ElementStyle {
  var backgroundColor: UIColor = .clear
  var isHidden = false
  var text: String = ""
  var font = UIFont(name: "Helvetica Neue", size: 14)!
  var textColor: UIColor = Constants.fontColorLabel
}

// MARK: - Common TextField

struct TextFieldCustom2: ElementTextFieldStyle {
    var cornerRadius: CGFloat = 10
    var borderWidth: CGFloat = 1.0
    var isHidden: Bool = false
    var text: String = ""
    var placeHolder: String?
    var font: UIFont = UIFont(name: "Helvetica Neue", size: 14)!
    var textColor: UIColor = UIColor(red: 40/255.0, green: 46/255.0, blue: 54/255.0, alpha: 1.0)
    var normalBorderColor: UIColor = Constants.greenBackgroundColor
    var focusBorderColor: UIColor = .brandeisBlue
    var errorBorderColor: UIColor = .tallPoppyRed
    var backgroundColor: UIColor = Constants.textFieldBackgroundColor
    var tintColor: UIColor = .codGray
    var width: Double = 335.0
    var height: Double = 56.0
    var isSecured: Bool = false
    var isSupportingNumericKeyboard: Bool = false
}

// MARK: - Common Error View

struct ErrorInputLabelStyleCustom2: ElementErrorViewStyle {
  var isHidden = true
  var isWarningImageOnLeft = true
  var backgroundColor: UIColor = .clear
  var tintColor: UIColor = .tallPoppyRed
  var text: String = ""
  var font = UIFont(name: "Helvetica Neue", size: 14)!
  var textColor: UIColor =  .tallPoppyRed
  var image: UIImage? = UIImage(named: "warning")
  var height: Double = 18
}

// MARK: - Country

struct CountryFormButtonStyleCustom2: ElementButtonStyle {
  var image: UIImage? =  UIImage(named: "arrow_blue_right")?.imageFlippedForRightToLeftLayoutDirection()
  var text: String = Locale.current.regionCode ?? "Country"
  var font = UIFont(name: "Helvetica Neue", size: 14)!
  var disabledTextColor: UIColor = .mediumGray
  var disabledTintColor: UIColor = .mediumGray
  var activeTintColor: UIColor = .brandeisBlue
  var backgroundColor: UIColor = Constants.grayBackgroundColor
  var textColor: UIColor = .brandeisBlue
  var normalBorderColor: UIColor = .mediumGray
  var focusBorderColor: UIColor = .brandeisBlue
  var errorBorderColor: UIColor = .tallPoppyRed
  var imageTintColor: UIColor = Constants.greenBackgroundColor
  var isHidden = false
  var isEnabled = true
  var height: Double = 56
  var width: Double = 0
  var cornerRadius: CGFloat = 10
  var borderWidth: CGFloat = 1
  var textLeading: CGFloat = 20
}

// MARK: - Common Hint

struct HintInputLabelStyleCustom2: ElementStyle {
  var backgroundColor: UIColor = .clear
  var isHidden = false
  var text: String = ""
  var font = UIFont(name: "Helvetica Neue", size: 14)!
  var textColor: UIColor = .doveGray
}
