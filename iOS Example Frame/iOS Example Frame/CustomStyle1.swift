//
//  CustomStyle1.swift
//  iOS Example Frame
//
//  Created by Deepesh.Vasthimal on 03/06/2022.
//  Copyright © 2022 Checkout. All rights reserved.
//

import Foundation
import Frames

struct BillingFormCustom1Style: BillingFormStyle {
    public var mainBackground: UIColor = .white
    public var header: BillingFormHeaderCellStyle = BillingFormCustom1HeaderCellStyle()
    public var cells: [BillingFormCell] = [.addressLine1(BillingFormAddressLine1Custom1CellStyle()),
                                           .addressLine2(BillingFormAddressLine2Custom1CellStyle()),
                                           .city(BillingFormCityCustom1CellStyle()),
                                           .state(BillingFormStateCustom1CellStyle()),
                                           .postcode(BillingFormPostcodeCustom1CellStyle()),
                                           .country(BillingFormCountryCustom1CellStyle()),
                                           .phoneNumber(BillingFormPhoneNumberCustom1CellStyle())]
}

struct BillingFormFullNameCustom1CellStyle : CellTextFieldStyle {
    public var isOptional: Bool = false
    public var backgroundColor: UIColor = UIColor(red: 241/255.0, green: 244/255.0, blue: 248/255.0, alpha: 1.0)
    public var title: ElementStyle? = TitleLabelCustom1Style(text:  "Full Name")
    public var hint: ElementStyle? = nil
    public var textfield: ElementTextFieldStyle = TextFieldCustom1()
    public var error: ElementErrorViewStyle = ErrorInputCustom1LabelStyle(text: "Enter Name")
}

struct BillingFormAddressLine1Custom1CellStyle : CellTextFieldStyle {
    public var isOptional: Bool = true
    public var backgroundColor: UIColor = UIColor(red: 241/255.0, green: 244/255.0, blue: 248/255.0, alpha: 1.0)
    public var title: ElementStyle? = TitleLabelCustom1Style(text:  "Address Line 1*")
    public var hint: ElementStyle? = nil
    public var textfield: ElementTextFieldStyle = TextFieldCustom1()
    public var error: ElementErrorViewStyle = ErrorInputCustom1LabelStyle(text:  "Enter Address Line 1")
}

struct BillingFormAddressLine2Custom1CellStyle : CellTextFieldStyle {
    public var isOptional: Bool = true
    public var backgroundColor: UIColor = UIColor(red: 241/255.0, green: 244/255.0, blue: 248/255.0, alpha: 1.0)
    public var title: ElementStyle? = TitleLabelCustom1Style(text:  "Address Line 2")
    public var hint: ElementStyle? = nil
    public var textfield: ElementTextFieldStyle = TextFieldCustom1()
    public var error: ElementErrorViewStyle = ErrorInputCustom1LabelStyle(text: "Enter Address Line 2")
}

struct BillingFormCityCustom1CellStyle : CellTextFieldStyle {
    public var isOptional: Bool = false
    public var backgroundColor: UIColor = UIColor(red: 241/255.0, green: 244/255.0, blue: 248/255.0, alpha: 1.0)
    public var title: ElementStyle? = TitleLabelCustom1Style(text:  "Town*")
    public var hint: ElementStyle? = nil
    public var textfield: ElementTextFieldStyle = TextFieldCustom1()
    public var error: ElementErrorViewStyle = ErrorInputCustom1LabelStyle(text: "Enter Town")
}

struct BillingFormStateCustom1CellStyle : CellTextFieldStyle {
    public var isOptional: Bool = false
    public var backgroundColor: UIColor = UIColor(red: 241/255.0, green: 244/255.0, blue: 248/255.0, alpha: 1.0)
    public var title: ElementStyle? = TitleLabelCustom1Style(text: "County")
    public var hint: ElementStyle? = nil
    public var textfield: ElementTextFieldStyle = TextFieldCustom1()
    public var error: ElementErrorViewStyle = ErrorInputCustom1LabelStyle(text: "Enter County")
}

struct BillingFormPostcodeCustom1CellStyle : CellTextFieldStyle {
    public var isOptional: Bool = false
    public var backgroundColor: UIColor = UIColor(red: 241/255.0, green: 244/255.0, blue: 248/255.0, alpha: 1.0)
    public var title: ElementStyle? = TitleLabelCustom1Style(text:  "Postcode*")
    public var hint: ElementStyle? = nil
    public var textfield: ElementTextFieldStyle = TextFieldCustom1()
    public var error: ElementErrorViewStyle = ErrorInputCustom1LabelStyle(text: "Enter Postcode")
}

struct BillingFormCountryCustom1CellStyle: CellButtonStyle {
    public var backgroundColor: UIColor = UIColor(red: 241/255.0, green: 244/255.0, blue: 248/255.0, alpha: 1.0)
    public var button: ElementButtonStyle = CountryCustom1FormButtonStyle()
    public var isOptional: Bool = false
    public var title: ElementStyle? = TitleLabelCustom1Style(text: "Country*", textColor: .doveGray)
    public var hint: ElementStyle? = nil
    public var error: ElementErrorViewStyle = ErrorInputCustom1LabelStyle(text: "Enter Country")
}

struct BillingFormPhoneNumberCustom1CellStyle : CellTextFieldStyle {
    public var isOptional: Bool = false
    public var backgroundColor: UIColor = UIColor(red: 241/255.0, green: 244/255.0, blue: 248/255.0, alpha: 1.0)
    public var title: ElementStyle? = TitleLabelCustom1Style(text:  "Phone*")
    public var hint: ElementStyle? = HintInputCustom1LabelStyle(isHidden: true, text:  "")
    public var textfield: ElementTextFieldStyle = TextFieldCustom1(isSupportingNumericKeyboard: true)
    public var error: ElementErrorViewStyle = ErrorInputCustom1LabelStyle(text:  "Enter Phone Number")
}

struct BillingFormCustom1HeaderCellStyle: BillingFormHeaderCellStyle {

    public var backgroundColor: UIColor = .red
    public var headerLabel: ElementStyle = HeaderCustom1LabelFormStyle()
    public var cancelButton: ElementButtonStyle = CancelCustom1ButtonFormStyle()
    public var doneButton: ElementButtonStyle = DoneCustom1FormButtonStyle()
}

struct HeaderCustom1LabelFormStyle: ElementStyle {
    public var backgroundColor: UIColor = UIColor(red: 241/255.0, green: 244/255.0, blue: 248/255.0, alpha: 1.0)
    public var isHidden: Bool = false
    public var text: String = "Billing"
    public var font: UIFont = UIFont(name: "Helvetica Neue", size: 14)!
    public var textColor: UIColor  = .codGray
}

struct CancelCustom1ButtonFormStyle: ElementButtonStyle {
    public var image: UIImage?
    public var text: String = "Cancel"
    public var font: UIFont =  UIFont(name: "Helvetica Neue", size: 14)!
    public var activeTitleColor: UIColor = .white
    public var disabledTitleColor: UIColor = .doveGray
    public var disabledTintColor: UIColor = .doveGray
    public var activeTintColor: UIColor = .brandeisBlue
    public var backgroundColor: UIColor = .red
    public var textColor: UIColor = .clear
    public var normalBorderColor: UIColor = .clear
    public var focusBorderColor: UIColor = .clear
    public var errorBorderColor: UIColor = .clear
    public var isHidden: Bool = false
    public var isEnabled: Bool = true
    public var height: Double = 44
    public var width: Double = 53
}

public struct DoneCustom1FormButtonStyle: ElementButtonStyle {
    public var image: UIImage? = nil
    public var text: String = "Done"
    public var font: UIFont = UIFont(name: "Helvetica Neue", size: 14)!
    public var activeTitleColor: UIColor = .white
    public var disabledTitleColor: UIColor = .doveGray
    public var disabledTintColor: UIColor = .doveGray
    public var activeTintColor: UIColor = .brandeisBlue
    public var backgroundColor: UIColor = .red
    public var normalBorderColor: UIColor = .clear
    public var focusBorderColor: UIColor = .clear
    public var errorBorderColor: UIColor = .clear
    public var textColor: UIColor = .clear
    public var isHidden: Bool = false
    public var isEnabled: Bool = true
    public var height: Double = 44
    public var width: Double = 53
}

public struct TitleLabelCustom1Style: ElementStyle {
    public var backgroundColor: UIColor = .clear
    public var isHidden: Bool = false
    public var text: String = ""
    public var font: UIFont = UIFont(name: "Helvetica Neue", size: 14)!
    public var textColor: UIColor = .codGray
}

public struct TextFieldCustom1: ElementTextFieldStyle {
    public var isHidden: Bool = false
    public var text: String = ""
    public var placeHolder: String = ""
    public var isPlaceHolderHidden: Bool  = false
    public var font: UIFont = UIFont(name: "Helvetica Neue", size: 14)!
    public var textColor: UIColor = .codGray
    public var normalBorderColor: UIColor = .mediumGray
    public var focusBorderColor: UIColor = .brandeisBlue
    public var errorBorderColor: UIColor = .tallPoppyRed
    public var backgroundColor: UIColor = .white
    public var tintColor: UIColor = .codGray
    public var width: Double = 335.0
    public var height: Double = 56.0
    public var isSecured: Bool = false
    public var isSupportingNumericKeyboard: Bool = false
}

public struct ErrorInputCustom1LabelStyle: ElementErrorViewStyle {
    public var isHidden: Bool = true
    public var isWarningImageOnLeft: Bool = true
    public var backgroundColor: UIColor = .white
    public var tintColor: UIColor = .tallPoppyRed
    public var text: String = ""
    public var font: UIFont = UIFont(name: "Helvetica Neue", size: 14)!
    public var textColor: UIColor =  .tallPoppyRed
    public var image: UIImage =  "warning".vectorPDFImage(forClass: CheckoutTheme.self) ?? UIImage()
    public var height: Double = 18
}

public class CountryCustom1FormButtonStyle: ElementButtonStyle {
    public var image: UIImage? = "arrow_blue_right".vectorPDFImage(forClass: CheckoutTheme.self)
    public var text: String = "Country"
    public var font: UIFont = UIFont(name: "Helvetica Neue", size: 14)!
    public var activeTitleColor: UIColor = .brandeisBlue
    public var disabledTitleColor: UIColor = .mediumGray
    public var disabledTintColor: UIColor = .mediumGray
    public var activeTintColor: UIColor = .brandeisBlue
    public var backgroundColor: UIColor = .white
    public var textColor: UIColor = .clear
    public var normalBorderColor: UIColor = .mediumGray
    public var focusBorderColor: UIColor = .brandeisBlue
    public var errorBorderColor: UIColor = .tallPoppyRed
    public var isHidden: Bool = false
    public var isEnabled: Bool = true
    public var height: Double = 56
    public var width: Double = 0
}

public struct HintInputCustom1LabelStyle: ElementStyle {
    public var backgroundColor: UIColor = .clear
    public var isHidden: Bool = false
    public var text: String = ""
    public var font: UIFont = UIFont(name: "Helvetica Neue", size: 14)!
    public var textColor: UIColor = .doveGray
}

extension String {

    func getBundle(forClass: AnyClass) -> Foundation.Bundle {
#if SWIFT_PACKAGE
        let baseBundle = Bundle.module
#else
        let baseBundle = Foundation.Bundle(for: forClass)
#endif
        let path = baseBundle.path(forResource: "Frames", ofType: "bundle")
        return path == nil ? baseBundle : Foundation.Bundle(path: path!)!
    }

    func vectorPDFImage(forClass: AnyClass) -> UIImage? {
        let bundle = getBundle(forClass: forClass)
        guard let urlPath = bundle.url(forResource: self, withExtension: "pdf"),
              let document = CGPDFDocument(urlPath as CFURL),
              let page = document.page(at: 1) else { return nil }

        let pageRect = page.getBoxRect(.mediaBox)
        let renderer = UIGraphicsImageRenderer(size: pageRect.size)

        return renderer.image {
            UIColor.clear.set()
            $0.fill(pageRect)
            $0.cgContext.translateBy(x: 0.0, y: pageRect.size.height)
            $0.cgContext.scaleBy(x: 1.0, y: -1.0)
            $0.cgContext.drawPDFPage(page)
        }.withRenderingMode(.alwaysTemplate)
    }
}
