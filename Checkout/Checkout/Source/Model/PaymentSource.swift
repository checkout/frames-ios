//
//  PaymentSource.swift
//  
//
//  Created by Harry Brown on 23/11/2021.
//

import Foundation

/// Defines the payment source - either card or Apple Pay.
public enum PaymentSource: Equatable {
  case card(Card)
  case applePay(ApplePay)
}
