//
//  ValidationResult.swift
//  
//
//  Created by Daven.Gomes on 04/11/2021.
//

import Foundation

/// Defines the outcome of a validation check, either success or failure.
public enum ValidationResult<T: CheckoutError>: Equatable {
  case success
  case failure(T)
}
