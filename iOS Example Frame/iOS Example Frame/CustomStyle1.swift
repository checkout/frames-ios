//
//  CustomStyle1.swift
//  iOS Example Frame
//
//  Created by Deepesh.Vasthimal on 03/06/2022.
//  Copyright © 2022 Checkout. All rights reserved.
//

import UIKit
import Frames

//MARK: - Color Constants -

/// Predefined custom 1 theme colors
private enum Constants {
    static let fontColorLabel = UIColor(red: 40/255.0, green: 46/255.0, blue: 54/255.0, alpha: 1.0)
    static let grayBackgroundColor = UIColor(red: 240/255.0, green: 245/255.0, blue: 249/255.0, alpha: 1.0)
    static let whiteBackgroundColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
    static let errorLabelBackgroundColor = UIColor(red: 226/255.0, green: 27/255.0, blue: 46/255.0, alpha: 1.0)
    static let redBackgroundColor = UIColor(red: 226/255.0, green: 27/255.0, blue: 46/255.0, alpha: 1.0)
    static let textFieldBackgroundColor = UIColor(red: 240/255.0, green: 245/255.0, blue: 249/255.0, alpha: 1.0)
}

//**********************
//MARK: - Payment Form
//**********************

//MARK: - Main Payment Form

struct PaymentFormStyleCustom1: PaymentFormStyle {
    var addBillingSummary: CellButtonStyle?
    var editBillingSummary: BillingSummaryViewStyle? = EditBillingSummaryStyleCustom1()
    var expiryDate: CellTextFieldStyle? = ExpiryDateFormStyleCustom1()
}

//MARK: - Billing Form WITH Summary ( Edit details )

/// This style for summary view with pre-filled with Address or Phone
struct EditBillingSummaryStyleCustom1: BillingSummaryViewStyle {
    var isMandatory: Bool = true
    var cornerRadius: CGFloat = 10
    var borderWidth: CGFloat = 1.0
    var separatorLineColor: UIColor = Constants.redBackgroundColor
    var backgroundColor: UIColor = .clear
    var borderColor: UIColor = Constants.redBackgroundColor
    var button: ElementButtonStyle = SummaryButtonStyleCustom1()
    var title: ElementStyle? = TitleLabelStyleCustom1(text: "Billing address", textColor: Constants.fontColorLabel)
    var hint: ElementStyle? = HintInputLabelStyleCustom1(text: "We need this information as an additional security measure to verify this card.",
                                                         textColor: Constants.fontColorLabel)
    var summary: ElementStyle? = TitleLabelStyleCustom1(textColor: Constants.fontColorLabel)
    var mandatory: ElementStyle?
    var error: ElementErrorViewStyle?
}

//MARK: - Billing Form WITH Summary Button ( Edit details )

/// This style for summary button with pre-filled summary view style
struct SummaryButtonStyleCustom1: ElementButtonStyle {
    var image: UIImage? =  UIImage(named: "arrow_blue_right")
    var text: String = "Edit billing address"
    var font: UIFont = UIFont.systemFont(ofSize: 15)
    var textColor: UIColor = Constants.redBackgroundColor
    var disabledTextColor: UIColor = .clear
    var disabledTintColor: UIColor = .clear
    var activeTintColor: UIColor = Constants.redBackgroundColor
    var imageTintColor: UIColor = Constants.redBackgroundColor
    var backgroundColor: UIColor = .clear
    var normalBorderColor: UIColor = .clear
    var focusBorderColor: UIColor = .clear
    var errorBorderColor: UIColor = .clear
    var isHidden: Bool = false
    var isEnabled: Bool = true
    var height: Double = 56
    var width: Double = 0
    var cornerRadius: CGFloat = 10
    var borderWidth: CGFloat = 1
    var textLeading: CGFloat = 20
}

//MARK: - Billing Form WITHOUT Summary  ( Add details )

/// This style for `add billing details View` when summary is not provided
struct AddBillingDetailsViewStyleCustom1: CellButtonStyle {
    var mandatory: ElementStyle?
    var backgroundColor: UIColor = .clear
    var button: ElementButtonStyle = AddBillingDetailsButtonStyleCustom1()
    var isMandatory: Bool = true
    var title: ElementStyle? = TitleLabelStyleCustom1(text: "Billing address", textColor: Constants.fontColorLabel)
    var hint: ElementStyle? = HintInputLabelStyleCustom1(text: "We need this information as an additional security measure to verify this card.", textColor: Constants.fontColorLabel)
    var error: ElementErrorViewStyle?
}

//MARK: - Billing Form WITHOUT Summary Button ( Add details )

/// This style for `add billing details Button` when summary is not provided
struct AddBillingDetailsButtonStyleCustom1: ElementButtonStyle {
    var image: UIImage? =  UIImage(named: "arrow_blue_right")
    var text: String = "Add billing address"
    var font: UIFont = UIFont.systemFont(ofSize: 15)
    var textColor: UIColor = .brandeisBlue
    var disabledTextColor: UIColor = .mediumGray
    var disabledTintColor: UIColor = .mediumGray
    var activeTintColor: UIColor = .brandeisBlue
    var backgroundColor: UIColor = .clear
    var normalBorderColor: UIColor = .brandeisBlue
    var focusBorderColor: UIColor = .mediumGray
    var errorBorderColor: UIColor = .tallPoppyRed
    var imageTintColor: UIColor = .brandeisBlue
    var isHidden: Bool = false
    var isEnabled: Bool = true
    var height: Double = 56
    var width: Double = 0
    var cornerRadius: CGFloat = 10
    var borderWidth: CGFloat = 1
    var textLeading: CGFloat = 20
}

//MARK: - Expiry Date

public struct ExpiryDateFormStyleCustom1 : CellTextFieldStyle {
    public var isMandatory: Bool = true
    public var backgroundColor: UIColor = .clear
    public var title: ElementStyle? = TitleLabelStyleCustom1(text: "Expiry date")
    public var hint: ElementStyle? = HintInputLabelStyleCustom1(text: "Format is MM/YY")
    public var mandatory: ElementStyle?
    public var textfield: ElementTextFieldStyle = TextFieldCustom1(placeHolder: "MM/YY")
    public var error: ElementErrorViewStyle? = ErrorInputLabelStyleCustom1(text: "please fill expiry date")
}

//**********************
//MARK: - Billing Form
//**********************

//MARK: - Main Billing Form

struct BillingFormStyleCustom1: BillingFormStyle {
    var mainBackground: UIColor = Constants.grayBackgroundColor
    var header: BillingFormHeaderCellStyle = BillingFormHeaderCellStyleCustom1()
    var cells: [BillingFormCell] = [.fullName(BillingFormFullNameCellStyleCustom1()),
                                    .addressLine1(BillingFormAddressLine1CellStyleCustom1()),
                                    .country(BillingFormCountryCellStyleCustom1()),
                                    .phoneNumber(BillingFormPhoneNumberCellStyleCustom1())]
}

//MARK: - Full Name

struct BillingFormFullNameCellStyleCustom1 : CellTextFieldStyle {
    var isMandatory: Bool = true
    var isOptional: Bool = false
    var backgroundColor: UIColor = Constants.grayBackgroundColor
    var title: ElementStyle? = TitleLabelStyleCustom1(text: "Full Name", textColor: Constants.fontColorLabel)
    var hint: ElementStyle? = nil
    var mandatory: ElementStyle? = nil
    var textfield: ElementTextFieldStyle = TextFieldCustom1()
    var error: ElementErrorViewStyle? = ErrorInputLabelStyleCustom1(text: "Enter Name", textColor: Constants.errorLabelBackgroundColor)
}

//MARK: - Address Line 1

struct BillingFormAddressLine1CellStyleCustom1 : CellTextFieldStyle {
    var isMandatory: Bool = true
    var isOptional: Bool = true
    var backgroundColor: UIColor = Constants.grayBackgroundColor
    var title: ElementStyle? = TitleLabelStyleCustom1(text:  "Address Line 1*", textColor: Constants.fontColorLabel)
    var hint: ElementStyle? = nil
    var mandatory: ElementStyle? = nil
    var textfield: ElementTextFieldStyle = TextFieldCustom1()
    var error: ElementErrorViewStyle? = ErrorInputLabelStyleCustom1(text:  "Enter Address Line 1", textColor: Constants.errorLabelBackgroundColor)
}

//MARK: - Address Line 2

struct BillingFormAddressLine2CellStyleCustom1 : CellTextFieldStyle {
    var isMandatory: Bool = true
    var isOptional: Bool = true
    var backgroundColor: UIColor = Constants.grayBackgroundColor
    var title: ElementStyle? = TitleLabelStyleCustom1(text:  "Address Line 2", textColor: Constants.fontColorLabel)
    var hint: ElementStyle? = nil
    var mandatory: ElementStyle? = nil
    var textfield: ElementTextFieldStyle = TextFieldCustom1()
    var error: ElementErrorViewStyle? = ErrorInputLabelStyleCustom1(text: "Enter Address Line 2", textColor: Constants.errorLabelBackgroundColor)
}

//MARK: - City

struct BillingFormCityCellStyleCustom1 : CellTextFieldStyle {
    var isMandatory: Bool = true
    var isOptional: Bool = false
    var backgroundColor: UIColor = Constants.grayBackgroundColor
    var title: ElementStyle? = TitleLabelStyleCustom1(text:  "Town*", textColor: Constants.fontColorLabel)
    var hint: ElementStyle? = nil
    var mandatory: ElementStyle? = nil
    var textfield: ElementTextFieldStyle = TextFieldCustom1()
    var error: ElementErrorViewStyle? = ErrorInputLabelStyleCustom1(text: "Enter Town", textColor: Constants.errorLabelBackgroundColor)
}

//MARK: - State - County

struct BillingFormStateCellStyleCustom1 : CellTextFieldStyle {
    var isMandatory: Bool = true
    var isOptional: Bool = false
    var backgroundColor: UIColor = Constants.grayBackgroundColor
    var title: ElementStyle? = TitleLabelStyleCustom1(text: "County", textColor: Constants.fontColorLabel)
    var hint: ElementStyle? = nil
    var mandatory: ElementStyle? = nil
    var textfield: ElementTextFieldStyle = TextFieldCustom1()
    var error: ElementErrorViewStyle? = ErrorInputLabelStyleCustom1(text: "Enter County", textColor: Constants.errorLabelBackgroundColor)
}

//MARK: - Postcode - zip

struct BillingFormPostcodeCellStyleCustom1 : CellTextFieldStyle {
    var isMandatory: Bool = true
    var isOptional: Bool = false
    var backgroundColor: UIColor = Constants.grayBackgroundColor
    var title: ElementStyle? = TitleLabelStyleCustom1(text:  "Postcode*", textColor: Constants.fontColorLabel)
    var hint: ElementStyle? = nil
    var mandatory: ElementStyle? = nil
    var textfield: ElementTextFieldStyle = TextFieldCustom1()
    var error: ElementErrorViewStyle? = ErrorInputLabelStyleCustom1(text: "Enter Postcode", textColor: Constants.errorLabelBackgroundColor)
}

//MARK: Country

struct BillingFormCountryCellStyleCustom1: CellButtonStyle {
    var isMandatory: Bool = true
    var backgroundColor: UIColor = Constants.grayBackgroundColor
    var button: ElementButtonStyle = CountryFormButtonStyleCustom1()
    var isOptional: Bool = false
    var title: ElementStyle? = TitleLabelStyleCustom1(text: "Country*", textColor: Constants.fontColorLabel)
    var hint: ElementStyle? = nil
    var mandatory: ElementStyle? = nil
    var error: ElementErrorViewStyle? = ErrorInputLabelStyleCustom1(text: "Enter Country", textColor: Constants.errorLabelBackgroundColor)
}

//MARK: - Phone Number

struct BillingFormPhoneNumberCellStyleCustom1 : CellTextFieldStyle {
    var isMandatory: Bool = true
    var isOptional: Bool = false
    var backgroundColor: UIColor = Constants.grayBackgroundColor
    var title: ElementStyle? = TitleLabelStyleCustom1(text:  "Phone*", textColor: Constants.fontColorLabel)
    var hint: ElementStyle? = HintInputLabelStyleCustom1(isHidden: true, text:  "")
    var textfield: ElementTextFieldStyle = TextFieldCustom1(isSupportingNumericKeyboard: true)
    var mandatory: ElementStyle? = nil
    var error: ElementErrorViewStyle? = ErrorInputLabelStyleCustom1(text:  "Enter Phone Number", textColor: Constants.errorLabelBackgroundColor)
}

//MARK: - Main Header

struct BillingFormHeaderCellStyleCustom1: BillingFormHeaderCellStyle {
    var backgroundColor = Constants.redBackgroundColor
    var headerLabel: ElementStyle = HeaderLabelFormStyleCustom1()
    var cancelButton: ElementButtonStyle = CancelButtonFormStyleCustom1()
    var doneButton: ElementButtonStyle = DoneFormButtonStyleCustom1()
}

//MARK: - Header title

struct HeaderLabelFormStyleCustom1: ElementStyle {
    var backgroundColor: UIColor = Constants.redBackgroundColor
    var isHidden: Bool = false
    var text: String = "Billing form"
    var font: UIFont = UIFont.systemFont(ofSize: 24.0)
    var textColor: UIColor  = .white
}

//MARK: - Header Cancel

struct CancelButtonFormStyleCustom1: ElementButtonStyle {
    var cornerRadius: CGFloat = 1.0
    var borderWidth: CGFloat = 1.0
    var image: UIImage?
    var text: String = "Cancel"
    var font: UIFont =  UIFont.systemFont(ofSize: 15)
    var disabledTextColor: UIColor = .doveGray
    var disabledTintColor: UIColor = .doveGray
    var activeTintColor: UIColor = .brandeisBlue
    var backgroundColor: UIColor = Constants.redBackgroundColor
    var textColor: UIColor = .white
    var normalBorderColor: UIColor = .clear
    var focusBorderColor: UIColor = .clear
    var errorBorderColor: UIColor = .clear
    var imageTintColor: UIColor = .clear
    var isHidden: Bool = false
    var isEnabled: Bool = true
    var height: Double = 44
    var width: Double = 53
    var textLeading: CGFloat = 0
}

//MARK: - Header Done

struct DoneFormButtonStyleCustom1: ElementButtonStyle {
    var cornerRadius: CGFloat = 1.0
    var borderWidth: CGFloat = 1.0
    var image: UIImage? = nil
    var text: String = "Done"
    var font: UIFont = UIFont.systemFont(ofSize: 15)
    var disabledTextColor: UIColor = .doveGray
    var disabledTintColor: UIColor = .doveGray
    var activeTintColor: UIColor = .brandeisBlue
    var backgroundColor: UIColor = Constants.redBackgroundColor
    var normalBorderColor: UIColor = .clear
    var focusBorderColor: UIColor = .clear
    var errorBorderColor: UIColor = .clear
    var imageTintColor: UIColor = .clear
    var textColor: UIColor = .white
    var isHidden: Bool = false
    var isEnabled: Bool = true
    var height: Double = 44
    var width: Double = 53
    var textLeading: CGFloat = 0
}

//MARK: - Common Title Label

struct TitleLabelStyleCustom1: ElementStyle {
    var backgroundColor: UIColor = .clear
    var isHidden: Bool = false
    var text: String = ""
    var font: UIFont = UIFont(name: "Helvetica Neue", size: 14)!
    var textColor: UIColor = .systemPink
}

//MARK: - Common TextField

struct TextFieldCustom1: ElementTextFieldStyle {
    var cornerRadius: CGFloat = 0
    var borderWidth: CGFloat = 0
    var isHidden: Bool = false
    var text: String = ""
    var placeHolder: String = ""
    var isPlaceHolderHidden: Bool  = false
    var font: UIFont = UIFont(name: "Helvetica Neue", size: 14)!
    var textColor: UIColor = UIColor(red: 40/255.0, green: 46/255.0, blue: 54/255.0, alpha: 1.0)
    var normalBorderColor: UIColor = .mediumGray
    var focusBorderColor: UIColor = .brandeisBlue
    var errorBorderColor: UIColor = .tallPoppyRed
    var backgroundColor: UIColor = Constants.whiteBackgroundColor
    var tintColor: UIColor = .codGray
    var width: Double = 335.0
    var height: Double = 56.0
    var isSecured: Bool = false
    var isSupportingNumericKeyboard: Bool = false
}

//MARK: - Common Error View

struct ErrorInputLabelStyleCustom1: ElementErrorViewStyle {
    var isHidden: Bool = true
    var isWarningImageOnLeft: Bool = true
    var backgroundColor: UIColor = UIColor(red: 240/255.0, green: 245/255.0, blue: 249/255.0, alpha: 1.0)
    var tintColor: UIColor = .tallPoppyRed
    var text: String = ""
    var font: UIFont = UIFont(name: "Helvetica Neue", size: 14)!
    var textColor: UIColor =  .tallPoppyRed
    var image: UIImage = UIImage(named: "warning")!
    var height: Double = 18
}

//MARK: - Country

struct CountryFormButtonStyleCustom1: ElementButtonStyle {
    var cornerRadius: CGFloat = 1.0
    var borderWidth: CGFloat = 1.0
    var image: UIImage? = UIImage(named: "arrow_blue_right")
    var text: String = "Country"
    var font: UIFont = UIFont(name: "Helvetica Neue", size: 14)!
    var disabledTextColor: UIColor = .mediumGray
    var disabledTintColor: UIColor = .mediumGray
    var activeTintColor: UIColor = .brandeisBlue
    var backgroundColor: UIColor = Constants.grayBackgroundColor
    var textColor: UIColor = .brandeisBlue
    var normalBorderColor: UIColor = .mediumGray
    var focusBorderColor: UIColor = .brandeisBlue
    var errorBorderColor: UIColor = .tallPoppyRed
    var imageTintColor: UIColor = .mediumGray
    var isHidden: Bool = false
    var isEnabled: Bool = true
    var height: Double = 56
    var width: Double = 0
    var textLeading: CGFloat = 20
}

//MARK: - Common Hint

struct HintInputLabelStyleCustom1: ElementStyle {
    var backgroundColor: UIColor = .clear
    var isHidden: Bool = false
    var text: String = ""
    var font: UIFont = UIFont(name: "Helvetica Neue", size: 14)!
    var textColor: UIColor = .doveGray
}
