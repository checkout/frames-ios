//
//  ValidationResult.swift
//  
//
//  Created by Daven.Gomes on 04/11/2021.
//

import Foundation

public enum ValidationResult<T: CheckoutError> {
  case success
  case failure(T)
}
