//
//  StringExtensions.swift
//  
//
//  Created by Alex Ioja-Yang on 12/08/2022.
//

import Foundation

public extension String {
    
    var decimalDigits: String {
        components(separatedBy: .decimalDigits.inverted).joined()
    }

    func removeWhitespaces() -> String {
        filter { !$0.isWhitespace }
    }
    
}
