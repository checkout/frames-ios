//
//  Theme+BillingForm.swift
//  
//
//  Created by Alex Ioja-Yang on 18/08/2022.
//

import UIKit

public extension Theme {

    /// Theme generated Billing Form Style
    struct ThemeBillingForm: BillingFormStyle {
        public var mainBackground: UIColor
        public var header: BillingFormHeaderCellStyle
        public var cells: [BillingFormCell]
    }

    /// Create a Billing Form from Styles defined for each sub component
    func buildBillingForm(header: ThemeBillingHeader,
                          cells: [BillingFormCell]) -> ThemeBillingForm {
        ThemeBillingForm(mainBackground: self.backgroundColor,
                         header: header,
                         cells: cells)
    }

}
