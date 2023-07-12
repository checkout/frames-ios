//
//  Encoding.swift
//  
//
//  Created by Harry Brown on 25/11/2021.
//

import Foundation

protocol Encoding {
  func encode<T>(_ value: T) throws -> Data where T: Encodable
}
