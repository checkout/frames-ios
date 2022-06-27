//
//  Style.swift
//  iOS Example Frame
//
//  Created by Ehab Alsharkawy on 23/06/2022.
//  Copyright © 2022 Checkout. All rights reserved.
//

import Foundation

@frozen enum Style {

    enum Custom1 {
        static let paymentForm = PaymentFormStyleCustom1()
        static let billingForm = BillingFormStyleCustom1()
    }

    enum Custom2 {
        static let paymentForm = PaymentFormStyleCustom2()
        static let billingForm = BillingFormStyleCustom2()
    }
}
