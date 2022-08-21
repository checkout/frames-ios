//
//  StringExtensions.swift
//  
//
//  Created by Alex Ioja-Yang on 12/08/2022.
//

import Foundation

extension String {
    func removeWhitespaces() -> String {
        filter { !$0.isWhitespace }
    }
}
