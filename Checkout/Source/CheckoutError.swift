//
//  CheckoutError.swift
//  
//
//  Created by Daven.Gomes on 04/11/2021.
//

import Foundation

public protocol CheckoutError: Error, Equatable {
  var code: Int { get }
}
