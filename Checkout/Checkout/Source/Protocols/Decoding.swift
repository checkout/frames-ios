//
//  Decoding.swift
//  
//
//  Created by Harry Brown on 25/11/2021.
//

import Foundation

protocol Decoding {
  func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable
}
