//
//  CustomStyle2.swift
//  iOS Example Frame
//
//  Created by Deepesh.Vasthimal on 06/06/2022.
//  Copyright © 2022 Checkout. All rights reserved.
//

import UIKit
import Frames

private enum Constants {
    static let fontColorLabel = UIColor(red: 35/255.0, green: 38/255.0, blue: 39/255.0, alpha: 1.0)
    static let grayBackgroundColor = UIColor(red: 249/255.0, green: 249/255.0, blue: 249/255.0, alpha: 1.0)
    static let whiteBackgroundColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
    static let errorLabelBackgroundColor = UIColor(red: 79/255.0, green: 191/255.0, blue: 74/255.0, alpha: 1.0)
    static let greenBackgroundColor = UIColor(red: 79/255.0, green: 191/255.0, blue: 174/255.0, alpha: 1.0)
    static let textFieldBackgroundColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
}

struct BillingFormCustom2Style: BillingFormStyle {
    var mainBackground: UIColor = Constants.grayBackgroundColor
    var header: BillingFormHeaderCellStyle = BillingFormCustom2HeaderCellStyle()
    var cells: [BillingFormCell] = [.fullName(BillingFormFullNameCustom2CellStyle()),
                                           .addressLine1(BillingFormAddressLine1Custom2CellStyle()),
                                           .addressLine2(BillingFormAddressLine2Custom2CellStyle()),
                                           .city(BillingFormCityCustom2CellStyle()),
                                           .state(BillingFormStateCustom2CellStyle()),
                                           .postcode(BillingFormPostcodeCustom2CellStyle()),
                                           .country(BillingFormCountryCustom2CellStyle()),
                                           .phoneNumber(BillingFormPhoneNumberCustom2CellStyle())]
}

struct BillingFormFullNameCustom2CellStyle : CellTextFieldStyle {
    var isMandatory: Bool = true
    var isOptional: Bool = false
    var backgroundColor: UIColor = Constants.grayBackgroundColor
    var title: ElementStyle? = TitleLabelCustom2Style(text:  "Full Name", textColor: Constants.fontColorLabel)
    var hint: ElementStyle? = nil
    var mandatory: ElementStyle? = nil
    var textfield: ElementTextFieldStyle = TextFieldCustom2()
    var error: ElementErrorViewStyle? = ErrorInputCustom2LabelStyle(text: "Enter Name", textColor: Constants.errorLabelBackgroundColor)
}

struct BillingFormAddressLine1Custom2CellStyle : CellTextFieldStyle {
    var isMandatory: Bool = true
    var isOptional: Bool = true
    var backgroundColor: UIColor = Constants.grayBackgroundColor
    var title: ElementStyle? = TitleLabelCustom2Style(text:  "Address Line 1*", textColor: Constants.fontColorLabel)
    var hint: ElementStyle? = nil
    var mandatory: ElementStyle? = nil
    var textfield: ElementTextFieldStyle = TextFieldCustom2()
    var error: ElementErrorViewStyle? = ErrorInputCustom2LabelStyle(text:  "Enter Address Line 1", textColor: Constants.errorLabelBackgroundColor)
}

struct BillingFormAddressLine2Custom2CellStyle : CellTextFieldStyle {
    var isMandatory: Bool = true
    var isOptional: Bool = true
    var backgroundColor: UIColor = Constants.grayBackgroundColor
    var title: ElementStyle? = TitleLabelCustom2Style(text:  "Address Line 2", textColor: Constants.fontColorLabel)
    var hint: ElementStyle? = nil
    var mandatory: ElementStyle? = nil
    var textfield: ElementTextFieldStyle = TextFieldCustom2()
    var error: ElementErrorViewStyle? = ErrorInputCustom2LabelStyle(text: "Enter Address Line 2", textColor: Constants.errorLabelBackgroundColor)
}

struct BillingFormCityCustom2CellStyle : CellTextFieldStyle {
    var isMandatory: Bool = true
    var isOptional: Bool = false
    var backgroundColor: UIColor = Constants.grayBackgroundColor
    var title: ElementStyle? = TitleLabelCustom2Style(text:  "Town*", textColor: Constants.fontColorLabel)
    var hint: ElementStyle? = nil
    var mandatory: ElementStyle? = nil
    var textfield: ElementTextFieldStyle = TextFieldCustom2()
    var error: ElementErrorViewStyle? = ErrorInputCustom2LabelStyle(text: "Enter Town", textColor: Constants.errorLabelBackgroundColor)
}

struct BillingFormStateCustom2CellStyle : CellTextFieldStyle {
    var isMandatory: Bool = true
    var isOptional: Bool = false
    var backgroundColor: UIColor = Constants.grayBackgroundColor
    var title: ElementStyle? = TitleLabelCustom2Style(text: "County", textColor: Constants.fontColorLabel)
    var hint: ElementStyle? = nil
    var mandatory: ElementStyle? = nil
    var textfield: ElementTextFieldStyle = TextFieldCustom2()
    var error: ElementErrorViewStyle? = ErrorInputCustom2LabelStyle(text: "Enter County", textColor: Constants.errorLabelBackgroundColor)
}

struct BillingFormPostcodeCustom2CellStyle : CellTextFieldStyle {
    var isMandatory: Bool = true
    var isOptional: Bool = false
    var backgroundColor: UIColor = Constants.grayBackgroundColor
    var title: ElementStyle? = TitleLabelCustom2Style(text:  "Postcode*", textColor: Constants.fontColorLabel)
    var hint: ElementStyle? = nil
    var mandatory: ElementStyle? = nil
    var textfield: ElementTextFieldStyle = TextFieldCustom2()
    var error: ElementErrorViewStyle? = ErrorInputCustom2LabelStyle(text: "Enter Postcode", textColor: Constants.errorLabelBackgroundColor)
}

struct BillingFormCountryCustom2CellStyle: CellButtonStyle {
    var isMandatory: Bool = true
    var backgroundColor: UIColor = Constants.grayBackgroundColor
    var button: ElementButtonStyle = CountryCustom2FormButtonStyle()
    var isOptional: Bool = false
    var title: ElementStyle? = TitleLabelCustom2Style(text: "Country*", textColor: Constants.fontColorLabel)
    var hint: ElementStyle? = nil
    var mandatory: ElementStyle? = nil
    var error: ElementErrorViewStyle? = ErrorInputCustom2LabelStyle(text: "Enter Country", textColor: Constants.errorLabelBackgroundColor)
}

struct BillingFormPhoneNumberCustom2CellStyle : CellTextFieldStyle {
    var isMandatory: Bool = true
    var isOptional: Bool = false
    var mandatory: ElementStyle? = nil
    var backgroundColor: UIColor = Constants.grayBackgroundColor
    var title: ElementStyle? = TitleLabelCustom2Style(text:  "Phone*", textColor: Constants.fontColorLabel)
    var hint: ElementStyle? = HintInputCustom2LabelStyle(isHidden: true, text:  "")
    var textfield: ElementTextFieldStyle = TextFieldCustom2(isSupportingNumericKeyboard: true)
    var error: ElementErrorViewStyle? = ErrorInputCustom2LabelStyle(text:  "Enter Phone Number", textColor: Constants.errorLabelBackgroundColor)
}

struct BillingFormCustom2HeaderCellStyle: BillingFormHeaderCellStyle {
    var backgroundColor: UIColor = .clear
    var headerLabel: ElementStyle = HeaderCustom2LabelFormStyle()
    var cancelButton: ElementButtonStyle = CancelCustom2ButtonFormStyle()
    var doneButton: ElementButtonStyle = DoneCustom2FormButtonStyle()
}

struct HeaderCustom2LabelFormStyle: ElementStyle {
    var backgroundColor: UIColor = .clear
    var isHidden: Bool = false
    var text: String = "Billing Details"
    var font: UIFont = UIFont.systemFont(ofSize: 24.0)
    var textColor: UIColor  = .white
}

struct CancelCustom2ButtonFormStyle: ElementButtonStyle {
    var image: UIImage?
    var text: String = "Cancel"
    var font: UIFont =  UIFont.systemFont(ofSize: UIFont.systemFontSize)
    var activeTitleColor: UIColor = .white
    var disabledTextColor: UIColor = .doveGray
    var disabledTintColor: UIColor = .doveGray
    var activeTintColor: UIColor = .brandeisBlue
    var backgroundColor: UIColor = Constants.greenBackgroundColor
    var textColor: UIColor = .clear
    var normalBorderColor: UIColor = .clear
    var focusBorderColor: UIColor = .clear
    var errorBorderColor: UIColor = .clear
    var imageTintColor: UIColor = .clear
    var isHidden: Bool = false
    var isEnabled: Bool = true
    var height: Double = 44
    var width: Double = 53
    var cornerRadius: CGFloat = 10
    var borderWidth: CGFloat = 3
    var textLeading: CGFloat = 0
}

struct DoneCustom2FormButtonStyle: ElementButtonStyle {
    var image: UIImage? = nil
    var text: String = "Done"
    var font: UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)
    var activeTitleColor: UIColor = .white
    var disabledTextColor: UIColor = .doveGray
    var disabledTintColor: UIColor = .doveGray
    var activeTintColor: UIColor = .brandeisBlue
    var backgroundColor: UIColor = Constants.greenBackgroundColor
    var normalBorderColor: UIColor = .clear
    var focusBorderColor: UIColor = .clear
    var errorBorderColor: UIColor = .clear
    var imageTintColor: UIColor = .clear
    var textColor: UIColor = .clear
    var isHidden: Bool = false
    var isEnabled: Bool = true
    var height: Double = 44
    var width: Double = 53
    var cornerRadius: CGFloat = 10
    var borderWidth: CGFloat = 3
    var textLeading: CGFloat = 0
}

struct TitleLabelCustom2Style: ElementStyle {
    var backgroundColor: UIColor = .clear
    var isHidden: Bool = false
    var text: String = ""
    var font: UIFont = UIFont(name: "Helvetica Neue", size: 14)!
    var textColor: UIColor = .systemPink
}

struct TextFieldCustom2: ElementTextFieldStyle {
    var cornerRadius: CGFloat = 10
    var borderWidth: CGFloat = 1.0
    var isHidden: Bool = false
    var text: String = ""
    var placeHolder: String = ""
    var isPlaceHolderHidden: Bool  = false
    var font: UIFont = UIFont(name: "Helvetica Neue", size: 14)!
    var textColor: UIColor = UIColor(red: 40/255.0, green: 46/255.0, blue: 54/255.0, alpha: 1.0)
    var normalBorderColor: UIColor = .mediumGray
    var focusBorderColor: UIColor = .brandeisBlue
    var errorBorderColor: UIColor = .tallPoppyRed
    var backgroundColor: UIColor = Constants.textFieldBackgroundColor
    var tintColor: UIColor = .codGray
    var width: Double = 335.0
    var height: Double = 56.0
    var isSecured: Bool = false
    var isSupportingNumericKeyboard: Bool = false
}

struct ErrorInputCustom2LabelStyle: ElementErrorViewStyle {
    var isHidden: Bool = true
    var isWarningImageOnLeft: Bool = true
    var backgroundColor: UIColor = .clear
    var tintColor: UIColor = .tallPoppyRed
    var text: String = ""
    var font: UIFont = UIFont(name: "Helvetica Neue", size: 14)!
    var textColor: UIColor =  .tallPoppyRed
    var image: UIImage = UIImage(named: "warning")!
    var height: Double = 18
}

struct CountryCustom2FormButtonStyle: ElementButtonStyle {
    var image: UIImage? =  UIImage(named: "arrow_blue_right")
    var text: String = "Country"
    var font: UIFont = UIFont(name: "Helvetica Neue", size: 14)!
    var activeTitleColor: UIColor = .brandeisBlue
    var disabledTextColor: UIColor = .mediumGray
    var disabledTintColor: UIColor = .mediumGray
    var activeTintColor: UIColor = .brandeisBlue
    var backgroundColor: UIColor = Constants.grayBackgroundColor
    var textColor: UIColor = .clear
    var normalBorderColor: UIColor = .mediumGray
    var focusBorderColor: UIColor = .brandeisBlue
    var errorBorderColor: UIColor = .tallPoppyRed
    var imageTintColor: UIColor = .mediumGray
    var isHidden: Bool = false
    var isEnabled: Bool = true
    var height: Double = 56
    var width: Double = 0
    var cornerRadius: CGFloat = 10
    var borderWidth: CGFloat = 1
    var textLeading: CGFloat = 20
}

struct HintInputCustom2LabelStyle: ElementStyle {
    var backgroundColor: UIColor = .clear
    var isHidden: Bool = false
    var text: String = ""
    var font: UIFont = UIFont(name: "Helvetica Neue", size: 14)!
    var textColor: UIColor = .doveGray
}
