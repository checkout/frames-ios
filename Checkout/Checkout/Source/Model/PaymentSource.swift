//
//  PaymentSource.swift
//  
//
//  Created by Harry Brown on 23/11/2021.
//

import Foundation

public enum PaymentSource: Equatable {
  case card(Card)
  case applePay(ApplePay)
}
