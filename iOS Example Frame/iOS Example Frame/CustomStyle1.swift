//
//  CustomStyle1.swift
//  iOS Example Frame
//
//  Created by Deepesh.Vasthimal on 03/06/2022.
//  Copyright © 2022 Checkout. All rights reserved.
//

import UIKit
import Frames

private enum Constants {
    static let fontColorLabel = UIColor(red: 40/255.0, green: 46/255.0, blue: 54/255.0, alpha: 1.0)
    static let grayBackgroundColor = UIColor(red: 240/255.0, green: 245/255.0, blue: 249/255.0, alpha: 1.0)
    static let whiteBackgroundColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
    static let errorLabelBackgroundColor = UIColor(red: 226/255.0, green: 27/255.0, blue: 46/255.0, alpha: 1.0)
    static let redBackgroundColor = UIColor(red: 226/255.0, green: 27/255.0, blue: 46/255.0, alpha: 1.0)
    static let textFieldBackgroundColor = UIColor(red: 240/255.0, green: 245/255.0, blue: 249/255.0, alpha: 1.0)
}

//MARK: Billing Form

struct BillingFormCustom1Style: BillingFormStyle {
    var mainBackground: UIColor = Constants.grayBackgroundColor
    var header: BillingFormHeaderCellStyle = BillingFormCustom1HeaderCellStyle()
    var cells: [BillingFormCell] = [.fullName(BillingFormFullNameCustom1CellStyle()),
                                           .addressLine1(BillingFormAddressLine1Custom1CellStyle()),
                                           .addressLine2(BillingFormAddressLine2Custom1CellStyle()),
                                           .city(BillingFormCityCustom1CellStyle()),
                                           .postcode(BillingFormPostcodeCustom1CellStyle()),
                                           .country(BillingFormCountryCustom1CellStyle()),
                                           .phoneNumber(BillingFormPhoneNumberCustom1CellStyle())]
}

struct BillingFormFullNameCustom1CellStyle : CellTextFieldStyle {
    var isMandatory: Bool = true
    var isOptional: Bool = false
    var backgroundColor: UIColor = Constants.grayBackgroundColor
    var title: ElementStyle? = TitleLabelCustom1Style(text:  "Full Name", textColor: Constants.fontColorLabel)
    var hint: ElementStyle? = nil
    var mandatory: ElementStyle? = nil
    var textfield: ElementTextFieldStyle = TextFieldCustom1()
    var error: ElementErrorViewStyle? = ErrorInputCustom1LabelStyle(text: "Enter Name", textColor: Constants.errorLabelBackgroundColor)
}

struct BillingFormAddressLine1Custom1CellStyle : CellTextFieldStyle {
    var isMandatory: Bool = true
    var isOptional: Bool = true
    var backgroundColor: UIColor = Constants.grayBackgroundColor
    var title: ElementStyle? = TitleLabelCustom1Style(text:  "Address Line 1*", textColor: Constants.fontColorLabel)
    var hint: ElementStyle? = nil
    var mandatory: ElementStyle? = nil
    var textfield: ElementTextFieldStyle = TextFieldCustom1()
    var error: ElementErrorViewStyle? = ErrorInputCustom1LabelStyle(text:  "Enter Address Line 1", textColor: Constants.errorLabelBackgroundColor)
}

struct BillingFormAddressLine2Custom1CellStyle : CellTextFieldStyle {
    var isMandatory: Bool = true
    var isOptional: Bool = true
    var backgroundColor: UIColor = Constants.grayBackgroundColor
    var title: ElementStyle? = TitleLabelCustom1Style(text:  "Address Line 2", textColor: Constants.fontColorLabel)
    var hint: ElementStyle? = nil
    var mandatory: ElementStyle? = nil
    var textfield: ElementTextFieldStyle = TextFieldCustom1()
    var error: ElementErrorViewStyle? = ErrorInputCustom1LabelStyle(text: "Enter Address Line 2", textColor: Constants.errorLabelBackgroundColor)
}

struct BillingFormCityCustom1CellStyle : CellTextFieldStyle {
    var isMandatory: Bool = true
    var isOptional: Bool = false
    var backgroundColor: UIColor = Constants.grayBackgroundColor
    var title: ElementStyle? = TitleLabelCustom1Style(text:  "Town*", textColor: Constants.fontColorLabel)
    var hint: ElementStyle? = nil
    var mandatory: ElementStyle? = nil
    var textfield: ElementTextFieldStyle = TextFieldCustom1()
    var error: ElementErrorViewStyle? = ErrorInputCustom1LabelStyle(text: "Enter Town", textColor: Constants.errorLabelBackgroundColor)
}

struct BillingFormStateCustom1CellStyle : CellTextFieldStyle {
    var isMandatory: Bool = true
    var isOptional: Bool = false
    var backgroundColor: UIColor = Constants.grayBackgroundColor
    var title: ElementStyle? = TitleLabelCustom1Style(text: "County", textColor: Constants.fontColorLabel)
    var hint: ElementStyle? = nil
    var mandatory: ElementStyle? = nil
    var textfield: ElementTextFieldStyle = TextFieldCustom1()
    var error: ElementErrorViewStyle? = ErrorInputCustom1LabelStyle(text: "Enter County", textColor: Constants.errorLabelBackgroundColor)
}

struct BillingFormPostcodeCustom1CellStyle : CellTextFieldStyle {
    var isMandatory: Bool = true
    var isOptional: Bool = false
    var backgroundColor: UIColor = Constants.grayBackgroundColor
    var title: ElementStyle? = TitleLabelCustom1Style(text:  "Postcode*", textColor: Constants.fontColorLabel)
    var hint: ElementStyle? = nil
    var mandatory: ElementStyle? = nil
    var textfield: ElementTextFieldStyle = TextFieldCustom1()
    var error: ElementErrorViewStyle? = ErrorInputCustom1LabelStyle(text: "Enter Postcode", textColor: Constants.errorLabelBackgroundColor)
}

struct BillingFormCountryCustom1CellStyle: CellButtonStyle {
    var isMandatory: Bool = true
    var backgroundColor: UIColor = Constants.grayBackgroundColor
    var button: ElementButtonStyle = CountryCustom1FormButtonStyle()
    var isOptional: Bool = false
    var title: ElementStyle? = TitleLabelCustom1Style(text: "Country*", textColor: Constants.fontColorLabel)
    var hint: ElementStyle? = nil
    var mandatory: ElementStyle? = nil
    var error: ElementErrorViewStyle? = ErrorInputCustom1LabelStyle(text: "Enter Country", textColor: Constants.errorLabelBackgroundColor)
}

struct BillingFormPhoneNumberCustom1CellStyle : CellTextFieldStyle {
    var isMandatory: Bool = true
    var isOptional: Bool = false
    var backgroundColor: UIColor = Constants.grayBackgroundColor
    var title: ElementStyle? = TitleLabelCustom1Style(text:  "Phone*", textColor: Constants.fontColorLabel)
    var hint: ElementStyle? = HintInputCustom1LabelStyle(isHidden: true, text:  "")
    var textfield: ElementTextFieldStyle = TextFieldCustom1(isSupportingNumericKeyboard: true)
    var mandatory: ElementStyle? = nil
    var error: ElementErrorViewStyle? = ErrorInputCustom1LabelStyle(text:  "Enter Phone Number", textColor: Constants.errorLabelBackgroundColor)
}

struct BillingFormCustom1HeaderCellStyle: BillingFormHeaderCellStyle {
    var backgroundColor = Constants.redBackgroundColor
    var headerLabel: ElementStyle = HeaderCustom1LabelFormStyle()
    var cancelButton: ElementButtonStyle = CancelCustom1ButtonFormStyle()
    var doneButton: ElementButtonStyle = DoneCustom1FormButtonStyle()
}

struct HeaderCustom1LabelFormStyle: ElementStyle {
    var backgroundColor: UIColor = Constants.redBackgroundColor
    var isHidden: Bool = false
    var text: String = "Billing form"
    var font: UIFont = UIFont.systemFont(ofSize: 24.0)
    var textColor: UIColor  = .white
}

struct CancelCustom1ButtonFormStyle: ElementButtonStyle {
    var cornerRadius: CGFloat = 1.0
    var borderWidth: CGFloat = 1.0
    var image: UIImage?
    var text: String = "Cancel"
    var font: UIFont =  UIFont.systemFont(ofSize: 20)
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
    var width: Double = 90
    var textLeading: CGFloat = 0
}

struct DoneCustom1FormButtonStyle: ElementButtonStyle {
    var cornerRadius: CGFloat = 1.0
    var borderWidth: CGFloat = 1.0
    var image: UIImage? = nil
    var text: String = "Done"
    var font: UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)
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

struct TitleLabelCustom1Style: ElementStyle {
    var backgroundColor: UIColor = .clear
    var isHidden: Bool = false
    var text: String = ""
    var font: UIFont = UIFont(name: "Helvetica Neue", size: 14)!
    var textColor: UIColor = .systemPink
}

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

struct ErrorInputCustom1LabelStyle: ElementErrorViewStyle {
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

struct CountryCustom1FormButtonStyle: ElementButtonStyle {
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

struct HintInputCustom1LabelStyle: ElementStyle {
    var backgroundColor: UIColor = .clear
    var isHidden: Bool = false
    var text: String = ""
    var font: UIFont = UIFont(name: "Helvetica Neue", size: 14)!
    var textColor: UIColor = .doveGray
}

//MARK: Payment Form

public struct Custom1SummaryViewStyle: SummaryViewStyle {
    public var isMandatory: Bool = true
    public var cornerRadius: CGFloat = 10
    public var borderWidth: CGFloat = 1.0
    public var separatorLineColor: UIColor = Constants.redBackgroundColor
    public var backgroundColor: UIColor = .clear
    public var borderColor: UIColor = Constants.redBackgroundColor
    public var button: ElementButtonStyle = Custom1SummaryButtonStyle()
    public var title: ElementStyle? = TitleLabelCustom1Style(text: "Billing address", textColor: Constants.fontColorLabel)
    public var hint: ElementStyle? = HintInputCustom1LabelStyle(text: "We need this information as an additional security measure to verify this card.", textColor: Constants.fontColorLabel)
    public var summary: ElementStyle = TitleLabelCustom1Style(textColor: Constants.fontColorLabel)
    public var mandatory: ElementStyle?
    public var error: ElementErrorViewStyle?
}

public class Custom1SummaryButtonStyle: ElementButtonStyle {
    public var image: UIImage? =  UIImage(named: "arrow_blue_right")
    public var text: String = "Edit billing address"
    public var font: UIFont = UIFont.systemFont(ofSize: 15)
    public var textColor: UIColor = Constants.redBackgroundColor
    public var disabledTextColor: UIColor = .clear
    public var disabledTintColor: UIColor = .clear
    public var activeTintColor: UIColor = Constants.redBackgroundColor
    public var imageTintColor: UIColor = Constants.redBackgroundColor
    public var backgroundColor: UIColor = .clear
    public var normalBorderColor: UIColor = .clear
    public var focusBorderColor: UIColor = .clear
    public var errorBorderColor: UIColor = .clear
    public var isHidden: Bool = false
    public var isEnabled: Bool = true
    public var height: Double = 56
    public var width: Double = 0
    public var cornerRadius: CGFloat = 10
    public var borderWidth: CGFloat = 1
    public var textLeading: CGFloat = 20
}
