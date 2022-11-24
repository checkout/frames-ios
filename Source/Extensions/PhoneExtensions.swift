//
//  PhoneExtensions.swift
//  
//
//  Created by Alex Ioja-Yang on 24/11/2022.
//

import Foundation

extension Phone {
    
    func displayFormatted() -> String {
        PhoneNumberValidator().formatForDisplay(text: "\(country?.dialingCode ?? "")\(number ?? "")")
    }
    
}
