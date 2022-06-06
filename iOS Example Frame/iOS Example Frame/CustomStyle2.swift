//
//  CustomStyle2.swift
//  iOS Example Frame
//
//  Created by Deepesh.Vasthimal on 06/06/2022.
//  Copyright © 2022 Checkout. All rights reserved.
//

import Foundation
import Frames

private enum Constants {
    static let fontColorLabel = UIColor(red: 35/255.0, green: 38/255.0, blue: 39/255.0, alpha: 1.0)
    static let grayBackGroundColor = UIColor(red: 249/255.0, green: 249/255.0, blue: 249/255.0, alpha: 1.0)
    static let whitelBackGroundColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
    static let errorLabelBackgroudColor = UIColor(red: 79/255.0, green: 191/255.0, blue: 74/255.0, alpha: 1.0)
    static let greenBackGroundColor = UIColor(red: 79/255.0, green: 191/255.0, blue: 174/255.0, alpha: 1.0)
    static let textFieldBackGroundColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
}

struct BillingFormCustom2Style: BillingFormStyle {
    public var mainBackground: UIColor = Constants.grayBackGroundColor
    public var header: BillingFormHeaderCellStyle = BillingFormCustom2HeaderCellStyle()
    public var cells: [BillingFormCell] = [.fullName(BillingFormFullNameCustom2CellStyle()),
                                           .addressLine1(BillingFormAddressLine1Custom2CellStyle()),
                                           .addressLine2(BillingFormAddressLine2Custom2CellStyle()),
                                           .city(BillingFormCityCustom2CellStyle()),
                                           .state(BillingFormStateCustom2CellStyle()),
                                           .postcode(BillingFormPostcodeCustom2CellStyle()),
                                           .country(BillingFormCountryCustom2CellStyle()),
                                           .phoneNumber(BillingFormPhoneNumberCustom2CellStyle())]
}

struct BillingFormFullNameCustom2CellStyle : CellTextFieldStyle {
    public var isOptional: Bool = false
    public var backgroundColor: UIColor = Constants.grayBackGroundColor
    public var title: ElementStyle? = TitleLabelCustom2Style(text:  "Full Name", textColor: Constants.fontColorLabel)
    public var hint: ElementStyle? = nil
    public var textfield: ElementTextFieldStyle = TextFieldCustom2()
    public var error: ElementErrorViewStyle = ErrorInputCustom2LabelStyle(text: "Enter Name", textColor: Constants.errorLabelBackgroudColor)
}

struct BillingFormAddressLine1Custom2CellStyle : CellTextFieldStyle {
    public var isOptional: Bool = true
    public var backgroundColor: UIColor = Constants.grayBackGroundColor
    public var title: ElementStyle? = TitleLabelCustom2Style(text:  "Address Line 1*", textColor: Constants.fontColorLabel)
    public var hint: ElementStyle? = nil
    public var textfield: ElementTextFieldStyle = TextFieldCustom2()
    public var error: ElementErrorViewStyle = ErrorInputCustom2LabelStyle(text:  "Enter Address Line 1", textColor: Constants.errorLabelBackgroudColor)
}

struct BillingFormAddressLine2Custom2CellStyle : CellTextFieldStyle {
    public var isOptional: Bool = true
    public var backgroundColor: UIColor = Constants.grayBackGroundColor
    public var title: ElementStyle? = TitleLabelCustom2Style(text:  "Address Line 2", textColor: Constants.fontColorLabel)
    public var hint: ElementStyle? = nil
    public var textfield: ElementTextFieldStyle = TextFieldCustom2()
    public var error: ElementErrorViewStyle = ErrorInputCustom2LabelStyle(text: "Enter Address Line 2", textColor: Constants.errorLabelBackgroudColor)
}

struct BillingFormCityCustom2CellStyle : CellTextFieldStyle {
    public var isOptional: Bool = false
    public var backgroundColor: UIColor = Constants.grayBackGroundColor
    public var title: ElementStyle? = TitleLabelCustom2Style(text:  "Town*", textColor: Constants.fontColorLabel)
    public var hint: ElementStyle? = nil
    public var textfield: ElementTextFieldStyle = TextFieldCustom2()
    public var error: ElementErrorViewStyle = ErrorInputCustom2LabelStyle(text: "Enter Town", textColor: Constants.errorLabelBackgroudColor)
}

struct BillingFormStateCustom2CellStyle : CellTextFieldStyle {
    public var isOptional: Bool = false
    public var backgroundColor: UIColor = Constants.grayBackGroundColor
    public var title: ElementStyle? = TitleLabelCustom2Style(text: "County", textColor: Constants.fontColorLabel)
    public var hint: ElementStyle? = nil
    public var textfield: ElementTextFieldStyle = TextFieldCustom2()
    public var error: ElementErrorViewStyle = ErrorInputCustom2LabelStyle(text: "Enter County", textColor: Constants.errorLabelBackgroudColor)
}

struct BillingFormPostcodeCustom2CellStyle : CellTextFieldStyle {
    public var isOptional: Bool = false
    public var backgroundColor: UIColor = Constants.grayBackGroundColor
    public var title: ElementStyle? = TitleLabelCustom2Style(text:  "Postcode*", textColor: Constants.fontColorLabel)
    public var hint: ElementStyle? = nil
    public var textfield: ElementTextFieldStyle = TextFieldCustom2()
    public var error: ElementErrorViewStyle = ErrorInputCustom2LabelStyle(text: "Enter Postcode", textColor: Constants.errorLabelBackgroudColor)
}

struct BillingFormCountryCustom2CellStyle: CellButtonStyle {
    public var backgroundColor: UIColor = Constants.grayBackGroundColor
    public var button: ElementButtonStyle = CountryCustom2FormButtonStyle()
    public var isOptional: Bool = false
    public var title: ElementStyle? = TitleLabelCustom2Style(text: "Country*", textColor: Constants.fontColorLabel)
    public var hint: ElementStyle? = nil
    public var error: ElementErrorViewStyle = ErrorInputCustom2LabelStyle(text: "Enter Country", textColor: Constants.errorLabelBackgroudColor)
}

struct BillingFormPhoneNumberCustom2CellStyle : CellTextFieldStyle {
    public var isOptional: Bool = false
    public var backgroundColor: UIColor = Constants.grayBackGroundColor
    public var title: ElementStyle? = TitleLabelCustom2Style(text:  "Phone*", textColor: Constants.fontColorLabel)
    public var hint: ElementStyle? = HintInputCustom2LabelStyle(isHidden: true, text:  "")
    public var textfield: ElementTextFieldStyle = TextFieldCustom2(isSupportingNumericKeyboard: true)
    public var error: ElementErrorViewStyle = ErrorInputCustom2LabelStyle(text:  "Enter Phone Number", textColor: Constants.errorLabelBackgroudColor)
}

struct BillingFormCustom2HeaderCellStyle: BillingFormHeaderCellStyle {
    //public var backgroundColor: UIColor = .orange
    public var backgroundColor = Constants.greenBackGroundColor
    public var headerLabel: ElementStyle = HeaderCustom2LabelFormStyle()
    public var cancelButton: ElementButtonStyle = CancelCustom2ButtonFormStyle()
    public var doneButton: ElementButtonStyle = DoneCustom2FormButtonStyle()
}

struct HeaderCustom2LabelFormStyle: ElementStyle {
    //TODO: 1240 backgroundColor should be injected and allowed by merchants to be customized.
    public var backgroundColor: UIColor = .yellow // does not work
    public var isHidden: Bool = false
    public var text: String = "Billing Details"
    public var font: UIFont = UIFont.systemFont(ofSize: 24.0)
    public var textColor: UIColor  = .white
}

struct CancelCustom2ButtonFormStyle: ElementButtonStyle {
    public var image: UIImage?
    public var text: String = "Cancel"
    public var font: UIFont =  UIFont.systemFont(ofSize: UIFont.systemFontSize)
    public var activeTitleColor: UIColor = .white
    public var disabledTitleColor: UIColor = .doveGray
    public var disabledTintColor: UIColor = .doveGray
    public var activeTintColor: UIColor = .brandeisBlue
    public var backgroundColor: UIColor = Constants.greenBackGroundColor
    public var textColor: UIColor = .clear
    public var normalBorderColor: UIColor = .clear
    public var focusBorderColor: UIColor = .clear
    public var errorBorderColor: UIColor = .clear
    public var isHidden: Bool = false
    public var isEnabled: Bool = true
    public var height: Double = 44
    public var width: Double = 53
}

public struct DoneCustom2FormButtonStyle: ElementButtonStyle {
    public var image: UIImage? = nil
    public var text: String = "Done"
    public var font: UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)
    public var activeTitleColor: UIColor = .white
    public var disabledTitleColor: UIColor = .doveGray
    public var disabledTintColor: UIColor = .doveGray
    public var activeTintColor: UIColor = .brandeisBlue
    //public var backgroundColor: UIColor = .red
    public var backgroundColor: UIColor = Constants.greenBackGroundColor
    public var normalBorderColor: UIColor = .clear
    public var focusBorderColor: UIColor = .clear
    public var errorBorderColor: UIColor = .clear
    public var textColor: UIColor = .clear
    public var isHidden: Bool = false
    public var isEnabled: Bool = true
    public var height: Double = 44
    public var width: Double = 53
}

public struct TitleLabelCustom2Style: ElementStyle {
    //TODO: 1240 backgroundColor should be injected and allowed by merchants to be customized. currently Not working.
    public var backgroundColor: UIColor = .purple
    public var isHidden: Bool = false
    public var text: String = ""
    public var font: UIFont = UIFont(name: "Helvetica Neue", size: 14)!
    public var textColor: UIColor = .systemPink
}

public struct TextFieldCustom2: ElementTextFieldStyle {
    public var isHidden: Bool = false
    public var text: String = ""
    public var placeHolder: String = ""
    public var isPlaceHolderHidden: Bool  = false
    public var font: UIFont = UIFont(name: "Helvetica Neue", size: 14)!
    public var textColor: UIColor = UIColor(red: 40/255.0, green: 46/255.0, blue: 54/255.0, alpha: 1.0)
    public var normalBorderColor: UIColor = .mediumGray
    public var focusBorderColor: UIColor = .brandeisBlue
    public var errorBorderColor: UIColor = .tallPoppyRed
    public var backgroundColor: UIColor = Constants.textFieldBackGroundColor
    public var tintColor: UIColor = .codGray
    public var width: Double = 335.0
    public var height: Double = 56.0
    public var isSecured: Bool = false
    public var isSupportingNumericKeyboard: Bool = false
}

public struct ErrorInputCustom2LabelStyle: ElementErrorViewStyle {
    public var isHidden: Bool = true
    public var isWarningImageOnLeft: Bool = true
    public var backgroundColor: UIColor = UIColor(red: 240/255.0, green: 245/255.0, blue: 249/255.0, alpha: 1.0)
    public var tintColor: UIColor = .tallPoppyRed
    public var text: String = ""
    public var font: UIFont = UIFont(name: "Helvetica Neue", size: 14)!
    public var textColor: UIColor =  .tallPoppyRed
    public var image: UIImage =  "warning".vectorPDFImage(forClass: CheckoutTheme.self) ?? UIImage()
    public var height: Double = 18
}

public class CountryCustom2FormButtonStyle: ElementButtonStyle {
    public var image: UIImage? = "arrow_blue_right".vectorPDFImage(forClass: CheckoutTheme.self)
    public var text: String = "Country"
    public var font: UIFont = UIFont(name: "Helvetica Neue", size: 14)!
    public var activeTitleColor: UIColor = .brandeisBlue
    public var disabledTitleColor: UIColor = .mediumGray
    public var disabledTintColor: UIColor = .mediumGray
    public var activeTintColor: UIColor = .brandeisBlue
    //TODO: 1240 backgroundColor not working for entire field
    public var backgroundColor: UIColor = Constants.grayBackGroundColor
    public var textColor: UIColor = .clear
    public var normalBorderColor: UIColor = .mediumGray
    public var focusBorderColor: UIColor = .brandeisBlue
    public var errorBorderColor: UIColor = .tallPoppyRed
    public var isHidden: Bool = false
    public var isEnabled: Bool = true
    public var height: Double = 56
    public var width: Double = 0
}

public struct HintInputCustom2LabelStyle: ElementStyle {
    public var backgroundColor: UIColor = .clear
    public var isHidden: Bool = false
    public var text: String = ""
    public var font: UIFont = UIFont(name: "Helvetica Neue", size: 14)!
    public var textColor: UIColor = .doveGray
}
